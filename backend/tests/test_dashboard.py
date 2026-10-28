"""Tableau de bord : /me/curves et /me/dashboard, sur la base de test."""

from datetime import date
from decimal import Decimal

import pytest
from sqlalchemy import func, select

from app.db import SessionLocal
from app.jobs import run_day
from app.models import Allocation, DataSource, LoadCurve
from app.money import to_cents
from app.timesteps import HOURS_PER_STEP, day_steps
from tests.helpers import admin_headers, client, loop_with_members, user_headers

DAY1, DAY2 = date(2026, 10, 20), date(2026, 10, 21)

# Chaque pas est affiché à 3 décimales : la somme de 96 pas arrondis peut s'écarter du total exact
# d'au plus 96 × 0,0005 kWh (les totaux du mois, eux, sont calculés exactement puis arrondis)
STEPS_SUM_TOLERANCE = 96 * 0.0005


@pytest.fixture(scope="module")
def admin():
    return admin_headers()


@pytest.fixture(scope="module")
def loop(admin):
    """Un producteur et deux consommateurs, deux journées d'octobre simulées."""
    loop_id, members = loop_with_members(
        admin, [("production", 0), ("consumption", 0.3), ("consumption", 0.8)]
    )
    with SessionLocal() as db:
        run_day(db, DAY1)
        run_day(db, DAY2)
    return loop_id, members


def curves(headers, day):
    response = client.get("/api/v1/me/curves", params={"date": day.isoformat()}, headers=headers)
    assert response.status_code == 200, response.text
    return response.json()


def dashboard(headers, period):
    response = client.get("/api/v1/me/dashboard", params={"period": period}, headers=headers)
    assert response.status_code == 200, response.text
    return response.json()


def allocated(db, *, consumer=None, producer=None, first=DAY1, last=DAY1):
    query = select(func.coalesce(func.sum(Allocation.kwh), 0)).where(
        Allocation.ts >= day_steps(first)[0], Allocation.ts <= day_steps(last)[-1]
    )
    if consumer:
        query = query.where(Allocation.consumer_meter_id == consumer)
    if producer:
        query = query.where(Allocation.producer_meter_id == producer)
    return db.scalar(query)


# --- Courbe du jour ------------------------------------------------------------------------------


def test_courbe_du_jour_d_un_consommateur(loop):
    _, (_, (headers, meter), _) = loop
    day = curves(headers, DAY1)

    assert day["day"] == "2026-10-20"
    assert day["data_source"] == "simulated"
    assert len(day["steps"]) == 96
    assert all(step["consumption_kw"] > 0 for step in day["steps"])
    assert all(step["production_kw"] is None for step in day["steps"])
    assert all(step["sold_kwh"] == 0 for step in day["steps"])
    with SessionLocal() as db:
        expected = allocated(db, consumer=meter)
    assert sum(step["received_kwh"] for step in day["steps"]) == pytest.approx(float(expected), abs=STEPS_SUM_TOLERANCE)


def test_courbe_du_jour_d_un_producteur(loop):
    _, ((headers, meter), *_) = loop
    day = curves(headers, DAY1)

    assert all(step["consumption_kw"] is None for step in day["steps"])
    assert max(step["production_kw"] for step in day["steps"]) > 0
    assert day["steps"][0]["production_kw"] == 0  # minuit
    with SessionLocal() as db:
        expected = allocated(db, producer=meter)
    assert sum(step["sold_kwh"] for step in day["steps"]) == pytest.approx(float(expected), abs=STEPS_SUM_TOLERANCE)


def test_chacun_ne_voit_que_sa_part(loop):
    _, (_, (a_headers, a), (_, b)) = loop
    with SessionLocal() as db:
        a_expected, b_expected = allocated(db, consumer=a), allocated(db, consumer=b)
    assert a_expected != b_expected

    a_total = sum(step["received_kwh"] for step in curves(a_headers, DAY1)["steps"])
    assert a_total == pytest.approx(float(a_expected), abs=STEPS_SUM_TOLERANCE)


def test_jour_sans_donnees(loop):
    _, (_, (headers, _), _) = loop
    day = curves(headers, date(2026, 9, 15))

    assert day["data_source"] is None
    assert len(day["steps"]) == 96
    assert all(s["consumption_kw"] is None and s["received_kwh"] == 0 for s in day["steps"])


# --- Tableau de bord du mois ---------------------------------------------------------------------


def test_mois_d_un_consommateur(loop):
    _, (_, (headers, meter), _) = loop
    month = dashboard(headers, "2026-10")

    with SessionLocal() as db:
        local = allocated(db, consumer=meter, first=DAY1, last=DAY2)
        consumption = db.scalar(
            select(func.sum(LoadCurve.kw_avg) * HOURS_PER_STEP).where(LoadCurve.meter_id == meter)
        )

    assert month["data_source"] == "simulated"
    assert month["data_complete_until"] == "2026-10-21"
    assert month["producer"] is None
    consumer = month["consumer"]
    assert consumer["consumption_kwh"] == pytest.approx(float(consumption), abs=1e-3)
    assert consumer["local_kwh"] == pytest.approx(float(local), abs=1e-3)
    assert consumer["self_consumption_rate"] == pytest.approx(float(local / consumption), abs=1e-3)
    # Montant exact : Decimal, un seul arrondi, chaîne dans le JSON
    assert consumer["amount_eur"] == str(to_cents(local * Decimal("0.18")))
    assert month["co2_avoided_kg"] == pytest.approx(float(local) * 0.052, abs=0.06)


def test_mois_d_un_producteur(loop):
    _, ((headers, meter), *_) = loop
    producer = dashboard(headers, "2026-10")["producer"]

    with SessionLocal() as db:
        sold = allocated(db, producer=meter, first=DAY1, last=DAY2)
    assert producer["sold_kwh"] == pytest.approx(float(sold), abs=1e-3)
    assert 0 < producer["local_share"] <= 1
    commission = to_cents(sold * Decimal("0.02"))
    assert producer["commission_eur"] == str(commission)
    # Même règle que le relevé de reversement : net = brut − commission
    assert producer["net_eur"] == str(to_cents(sold * Decimal("0.18")) - commission)


def test_exemple_du_cahier_des_charges(admin):
    """§8.3 : 142,5 kWh à 0,18 € avec 0,02 € de commission → 25,65 € payés, 2,85 € de commission,
    22,80 € reversés ; 7,4 kg de CO2 évités. Données Enedis saisies à la main (novembre)."""
    loop_id, ((p_headers, producer), (c_headers, consumer)) = loop_with_members(
        admin, [("production", 0), ("consumption", 0.2)]
    )
    steps = day_steps(date(2026, 11, 12))
    with SessionLocal() as db:
        for ts, kwh in zip(steps[20:23], ("50", "50", "42.5"), strict=True):
            db.add(Allocation(
                loop_id=loop_id, ts=ts, producer_meter_id=producer, consumer_meter_id=consumer,
                source=DataSource.enedis, kwh=Decimal(kwh),
            ))
        db.commit()

    consumer_month = dashboard(c_headers, "2026-11")
    producer_month = dashboard(p_headers, "2026-11")

    assert consumer_month["data_source"] == "enedis"
    assert consumer_month["consumer"]["local_kwh"] == 142.5
    assert consumer_month["consumer"]["amount_eur"] == "25.65"
    assert producer_month["producer"]["commission_eur"] == "2.85"
    assert producer_month["producer"]["net_eur"] == "22.80"
    assert consumer_month["co2_avoided_kg"] == 7.4


def test_les_donnees_enedis_priment_sur_la_simulation(admin):
    loop_id, ((_, producer), (headers, consumer)) = loop_with_members(
        admin, [("production", 0), ("consumption", 0.2)]
    )
    day = date(2026, 10, 22)
    with SessionLocal() as db:
        run_day(db, day)
        db.add(Allocation(
            loop_id=loop_id, ts=day_steps(day)[24], producer_meter_id=producer,
            consumer_meter_id=consumer, source=DataSource.enedis, kwh=Decimal("1.5"),
        ))
        db.commit()

    assert curves(headers, day)["data_source"] == "enedis"
    assert sum(s["received_kwh"] for s in curves(headers, day)["steps"]) == 1.5


def test_sans_compteur(admin):
    month = dashboard(user_headers(), "2026-10")
    assert (month["consumer"], month["producer"], month["data_source"]) == (None, None, None)
    assert month["co2_avoided_kg"] == 0


def test_parametres(loop):
    _, (_, (headers, _), _) = loop
    assert client.get("/api/v1/me/dashboard", params={"period": "2026-13"}, headers=headers).status_code == 422
    assert client.get("/api/v1/me/curves", params={"date": "hier"}, headers=headers).status_code == 422
    # Par défaut : mois en cours, et hier pour la courbe (données en J+1)
    assert client.get("/api/v1/me/dashboard", headers=headers).status_code == 200
    assert client.get("/api/v1/me/curves", headers=headers).status_code == 200
    assert client.get("/api/v1/me/dashboard").status_code == 401


@pytest.mark.parametrize(("amount", "cents"), [("25.645", "25.65"), ("22.8", "22.80"), ("0.004", "0.00")])
def test_arrondi_au_centime(amount, cents):
    assert str(to_cents(Decimal(amount))) == cents
