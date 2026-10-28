"""Traitement d'une journée : courbes simulées puis répartition, sur la base de test.

La base est partagée par les tests : chaque test crée sa boucle et ne vérifie que ses compteurs.
"""

from collections import defaultdict
from datetime import date
from decimal import Decimal

import pytest
from sqlalchemy import select, text, update

from app.db import SessionLocal
from app.jobs import allocate_day, run_day
from app.models import Allocation, DataSource, LoadCurve, Loop, LoopMember
from app.timesteps import HOURS_PER_STEP, day_steps
from tests.helpers import admin_headers, loop_with_members

DAY = date(2026, 10, 20)


@pytest.fixture(scope="module")
def admin():
    return admin_headers()


def create_loop(admin, members, joined_at="2026-10-01", **loop_fields):
    """Boucle dont les membres (sens, km à l'est) sont validés à `joined_at` ; renvoie id et compteurs."""
    loop_id, joined = loop_with_members(admin, members, joined_at, **loop_fields)
    return loop_id, [meter for _, meter in joined]


def curves(db, meter_ids, day=DAY):
    steps = day_steps(day)
    rows = db.execute(
        select(LoadCurve.meter_id, LoadCurve.ts, LoadCurve.kw_avg, LoadCurve.source).where(
            LoadCurve.meter_id.in_(meter_ids), LoadCurve.ts >= steps[0], LoadCurve.ts <= steps[-1]
        )
    ).all()
    return rows


def allocations(db, loop_id):
    return db.scalars(select(Allocation).where(Allocation.loop_id == loop_id)).all()


def test_journee_simulee_et_repartie(admin):
    loop_id, (producer, *consumers) = create_loop(
        admin, [("production", 0), ("consumption", 0.4), ("consumption", 1)]
    )

    with SessionLocal() as db:
        report = run_day(db, DAY)
        points = curves(db, [producer, *consumers])
        rows = allocations(db, loop_id)

    assert report.loops >= 1
    assert len(points) == 3 * 96
    assert {source for *_, source in points} == {DataSource.simulated}
    assert rows, "un jour d'octobre, des panneaux de 9 kWc produisent"

    kwh = {(meter, ts): kw * HOURS_PER_STEP for meter, ts, kw, _ in points}
    received, sold = defaultdict(Decimal), defaultdict(Decimal)
    for row in rows:
        assert row.producer_meter_id == producer and row.consumer_meter_id in consumers
        received[(row.consumer_meter_id, row.ts)] += row.kwh
        sold[row.ts] += row.kwh
    # Jamais plus que la consommation de chacun ni que la production
    assert all(total <= kwh[key] for key, total in received.items())
    assert all(total <= kwh[(producer, ts)] for ts, total in sold.items())
    # Quand la production couvre tout le monde, chacun reçoit toute sa consommation
    for ts in day_steps(DAY):
        consumption = sum(kwh[(c, ts)] for c in consumers)
        if kwh[(producer, ts)] >= consumption > 0:
            assert consumption - sold[ts] <= Decimal("0.000002")


def test_rejouer_une_journee_ne_duplique_rien(admin):
    loop_id, meters = create_loop(admin, [("production", 0), ("consumption", 0.3)])

    with SessionLocal() as db:
        run_day(db, DAY)
        first = len(allocations(db, loop_id))
        run_day(db, DAY)
        assert len(allocations(db, loop_id)) == first
        assert len(curves(db, meters)) == 2 * 96


def test_seuls_les_membres_entres_sont_simules(admin):
    _, entered = create_loop(admin, [("consumption", 0)], joined_at="2026-10-01")
    _, later = create_loop(admin, [("consumption", 0)], joined_at="2026-11-01")
    _, pending = create_loop(admin, [("consumption", 0)], joined_at=None)

    with SessionLocal() as db:
        run_day(db, DAY)
        assert len(curves(db, entered)) == 96
        assert curves(db, later) == []
        assert curves(db, pending) == []


def test_une_courbe_enedis_n_est_jamais_remplacee(admin):
    _, (meter,) = create_loop(admin, [("consumption", 0)])
    first_step = day_steps(DAY)[0]

    with SessionLocal() as db:
        db.add(LoadCurve(meter_id=meter, ts=first_step, kw_avg=Decimal("7.777"), source=DataSource.enedis))
        db.commit()
        run_day(db, DAY)
        kept = db.get(LoadCurve, (meter, first_step))
        assert (kept.kw_avg, kept.source) == (Decimal("7.777"), DataSource.enedis)


def test_changement_d_heure(admin):
    _, meters = create_loop(admin, [("consumption", 0)])
    day = date(2026, 10, 25)

    with SessionLocal() as db:
        run_day(db, day)
        assert len(curves(db, meters, day)) == 100


def test_cle_statique(admin):
    loop_id, (_, a, _) = create_loop(
        admin,
        [("production", 0), ("consumption", 0.2), ("consumption", 0.4)],
        allocation_mode="static",
    )
    with SessionLocal() as db:
        # Toute la production est réservée au consommateur a : l'autre ne reçoit rien
        db.execute(update(LoopMember).where(LoopMember.meter_id == a).values(static_key=Decimal(1)))
        db.commit()
        run_day(db, DAY)
        consumers = {row.consumer_meter_id for row in allocations(db, loop_id)}

    assert consumers == {a}


def test_cle_non_prise_en_charge_ignoree_sans_bloquer_les_autres(admin):
    unsupported, _ = create_loop(
        admin, [("production", 0), ("consumption", 0.2)], allocation_mode="dynamic_custom"
    )
    supported, _ = create_loop(admin, [("production", 0), ("consumption", 0.2)])

    with SessionLocal() as db:
        report = run_day(db, DAY)
        name = db.get(Loop, unsupported).name
        assert name in report.skipped
        assert allocations(db, unsupported) == []
        assert allocations(db, supported)
        with pytest.raises(NotImplementedError):
            allocate_day(db, db.get(Loop, unsupported), DAY)


def test_les_hypertables_sont_en_place():
    with SessionLocal() as db:
        tables = set(db.scalars(text("SELECT hypertable_name FROM timescaledb_information.hypertables")))
    assert {"load_curves", "allocations"} <= tables
