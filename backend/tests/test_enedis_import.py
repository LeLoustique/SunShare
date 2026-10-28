"""Import mensuel des données Enedis, avec un faux client Enedis (aucun appel réseau)."""

import uuid
from datetime import UTC, date, datetime, timedelta
from decimal import Decimal

import pytest
from sqlalchemy import func, select

from app.db import SessionLocal
from app.enedis.client import (
    AllocatedEnergy,
    EnedisNotConfigured,
    EnedisUnavailable,
    MeterReading,
    get_enedis_client,
)
from app.enedis.importer import import_month
from app.jobs import run_day
from app.models import Allocation, DataSource, LoadCurve, Loop, Meter, MeterDirection
from app.timesteps import day_steps
from tests.helpers import admin_headers, client, loop_with_members

PERIOD = "2026-11"
STEPS = day_steps(date(2026, 11, 12))
PRODUCTION, CONSUMPTION = MeterDirection.production, MeterDirection.consumption


class FakeEnedis:
    """Renvoie les données qu'on lui donne ; `failures` premières demandes de courbes en échec."""

    def __init__(self, readings=(), energies=(), failures=0):
        self.readings, self.energies, self.failures = list(readings), list(energies), failures
        self.calls = []

    def load_curves(self, operation_id, start, end):
        self.calls.append((operation_id, start, end))
        if self.failures:
            self.failures -= 1
            raise EnedisUnavailable("panne simulée")
        return self.readings

    def allocated_energies(self, operation_id, start, end):
        return self.energies


@pytest.fixture(scope="module")
def admin():
    return admin_headers()


@pytest.fixture
def operation(admin):
    """Boucle avec un identifiant d'opération Enedis : un producteur et un consommateur actifs."""
    loop_id, ((p_headers, producer), (c_headers, consumer)) = loop_with_members(
        admin,
        [("production", 0), ("consumption", 0.2)],
        enedis_operation_id=f"ACC-{uuid.uuid4().hex[:8]}",
    )
    with SessionLocal() as db:
        meters = db.scalars(select(Meter).where(Meter.id.in_([producer, consumer])))
        prm = {meter.id: meter.prm for meter in meters}
    return {
        "loop_id": loop_id,
        "producer": producer,
        "consumer": consumer,
        "producer_prm": prm[producer],
        "consumer_prm": prm[consumer],
        "consumer_headers": c_headers,
        "producer_headers": p_headers,
    }


def run_import(operation, fake, **options):
    with SessionLocal() as db:
        loop = db.get(Loop, operation["loop_id"])
        return import_month(db, loop, fake, PERIOD, sleep=lambda _: None, **options)


def spec_example(op):
    """Exemple §8.3 : 142,5 kWh affectés sur trois pas, et les courbes correspondantes."""
    steps = STEPS[20:23]
    readings = [MeterReading(op["producer_prm"], PRODUCTION, ts, Decimal(250)) for ts in steps]
    readings += [MeterReading(op["consumer_prm"], CONSUMPTION, ts, Decimal(200)) for ts in steps]
    energies = [
        AllocatedEnergy(ts, op["producer_prm"], op["consumer_prm"], Decimal(kwh))
        for ts, kwh in zip(STEPS[20:23], ("50", "50", "42.5"), strict=True)
    ]
    return readings, energies


def stored(db, model, column, value, source=DataSource.enedis):
    return db.scalars(select(model).where(column == value, model.source == source)).all()


def test_import_des_courbes_et_energies_jusqu_au_tableau_de_bord(operation):
    readings, energies = spec_example(operation)

    report = run_import(operation, FakeEnedis(readings, energies))

    assert (report.curve_points, report.allocations, report.anomalies) == (6, 3, [])
    with SessionLocal() as db:
        assert len(stored(db, LoadCurve, LoadCurve.meter_id, operation["consumer"])) == 3
        assert len(stored(db, Allocation, Allocation.loop_id, operation["loop_id"])) == 3

    consumer = client.get(
        "/api/v1/me/dashboard", params={"period": PERIOD}, headers=operation["consumer_headers"]
    ).json()
    producer = client.get(
        "/api/v1/me/dashboard", params={"period": PERIOD}, headers=operation["producer_headers"]
    ).json()
    assert consumer["data_source"] == "enedis"
    assert consumer["consumer"]["amount_eur"] == "25.65"
    assert producer["producer"]["net_eur"] == "22.80"
    assert producer["producer"]["commission_eur"] == "2.85"


def test_le_client_recoit_le_mois_en_heure_de_paris(operation):
    fake = FakeEnedis()
    run_import(operation, fake)

    with SessionLocal() as db:
        operation_id = db.get(Loop, operation["loop_id"]).enedis_operation_id
    assert fake.calls == [(
        operation_id,
        datetime(2026, 10, 31, 23, tzinfo=UTC),  # 1er novembre, minuit à Paris
        datetime(2026, 11, 30, 23, tzinfo=UTC),
    )]


def test_les_donnees_enedis_remplacent_la_simulation(operation):
    day = date(2026, 11, 12)
    with SessionLocal() as db:
        run_day(db, day)
    reading = MeterReading(operation["consumer_prm"], CONSUMPTION, STEPS[30], Decimal("9.999"))

    run_import(operation, FakeEnedis([reading]))
    with SessionLocal() as db:
        run_day(db, day)  # la simulation rejouée ne touche pas à la mesure Enedis
        kept = db.get(LoadCurve, (operation["consumer"], STEPS[30]))
        others = db.scalar(
            select(func.count()).select_from(LoadCurve).where(
                LoadCurve.meter_id == operation["consumer"],
                LoadCurve.source == DataSource.simulated,
            )
        )
    assert (kept.kw_avg, kept.source) == (Decimal("9.999"), DataSource.enedis)
    assert others == len(STEPS) - 1


def test_rejouer_l_import_remplace_sans_doublon(operation):
    readings, energies = spec_example(operation)
    run_import(operation, FakeEnedis(readings, energies))

    corrected = [
        AllocatedEnergy(STEPS[20], operation["producer_prm"], operation["consumer_prm"], Decimal(10))
    ]
    report = run_import(operation, FakeEnedis(readings, corrected))

    assert report.allocations == 1
    with SessionLocal() as db:
        rows = stored(db, Allocation, Allocation.loop_id, operation["loop_id"])
        assert [row.kwh for row in rows] == [Decimal(10)]
        assert len(stored(db, LoadCurve, LoadCurve.meter_id, operation["producer"])) == 3


def test_anomalies_signalees_et_non_importees(operation):
    prm, producer_prm = operation["consumer_prm"], operation["producer_prm"]
    good = MeterReading(prm, CONSUMPTION, STEPS[10], Decimal(1))
    readings = [
        good,
        MeterReading("99999999999999", CONSUMPTION, STEPS[10], Decimal(1)),  # inconnu
        MeterReading(prm, PRODUCTION, STEPS[10], Decimal(1)),  # ne produit pas dans la boucle
        MeterReading(prm, CONSUMPTION, STEPS[11] + timedelta(minutes=7), Decimal(1)),
        MeterReading(prm, CONSUMPTION, datetime(2026, 10, 15, 10, tzinfo=UTC), Decimal(1)),
        MeterReading(prm, CONSUMPTION, datetime(2026, 11, 15, 10), Decimal(1)),  # sans fuseau
        MeterReading(prm, CONSUMPTION, STEPS[12], Decimal(-1)),
        MeterReading(prm, CONSUMPTION, STEPS[10], Decimal(2)),  # doublon de `good`
    ]
    energies = [
        AllocatedEnergy(STEPS[10], producer_prm, prm, Decimal("0.5")),
        AllocatedEnergy(STEPS[10], prm, producer_prm, Decimal("0.5")),  # sens inversés
        AllocatedEnergy(STEPS[11], producer_prm, prm, Decimal(-1)),
    ]

    report = run_import(operation, FakeEnedis(readings, energies))

    assert (report.curve_points, report.allocations) == (1, 1)
    assert len(report.anomalies) == 9
    text = "\n".join(report.anomalies)
    for expected in ("99999999999999", "pas mal aligné", "hors de la période", "sans fuseau",
                     "puissance négative", "en double", "énergie négative"):
        assert expected in text
    with SessionLocal() as db:
        assert db.get(LoadCurve, (operation["consumer"], STEPS[10])).kw_avg == Decimal(1)


def test_un_membre_en_attente_n_est_pas_importe(admin):
    loop_id, ((_, meter),) = loop_with_members(
        admin, [("consumption", 0)], joined_at=None, enedis_operation_id="ACC-ATTENTE"
    )
    with SessionLocal() as db:
        prm = db.get(Meter, meter).prm
        report = import_month(
            db, db.get(Loop, loop_id),
            FakeEnedis([MeterReading(prm, CONSUMPTION, STEPS[0], Decimal(1))]), PERIOD,
        )
    assert report.curve_points == 0
    assert "n'est pas membre" in report.anomalies[0]


def test_nouvelles_tentatives_puis_succes(operation):
    readings, energies = spec_example(operation)
    waits = []
    with SessionLocal() as db:
        report = import_month(
            db, db.get(Loop, operation["loop_id"]), FakeEnedis(readings, energies, failures=2),
            PERIOD, sleep=waits.append, retry_delay=10,
        )
    assert waits == [10, 20]
    assert report.allocations == 3


def test_echec_persistant_rien_n_est_ecrit(operation):
    readings, energies = spec_example(operation)
    with pytest.raises(EnedisUnavailable):
        run_import(operation, FakeEnedis(readings, energies, failures=3))
    with SessionLocal() as db:
        assert stored(db, Allocation, Allocation.loop_id, operation["loop_id"]) == []


def test_boucle_sans_identifiant_d_operation(admin):
    loop_id, _ = loop_with_members(admin, [("consumption", 0)])
    with SessionLocal() as db, pytest.raises(ValueError, match="identifiant d'opération"):
        import_month(db, db.get(Loop, loop_id), FakeEnedis(), PERIOD)


def test_aucun_acces_enedis_configure():
    with pytest.raises(EnedisNotConfigured, match="non configuré"):
        get_enedis_client()
