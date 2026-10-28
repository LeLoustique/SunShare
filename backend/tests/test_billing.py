"""Facturation mensuelle : montants (fonctions pures), brouillons, émission et accès aux relevés.

L'émission porte sur tous les brouillons d'un mois : chaque test facture son propre mois.
"""

import re
from datetime import date
from decimal import Decimal as D

import pytest

from app.billing import consumer_amounts, producer_amounts
from app.db import SessionLocal
from app.models import Allocation, DataSource, Meter
from app.timesteps import day_steps
from tests.helpers import admin_headers, client, loop_with_members, user_headers

NUMBER = re.compile(r"^SS-\d{4}-(\d{6})$")


@pytest.fixture(scope="module")
def admin():
    return admin_headers()


def allocate(loop_id, month, pairs, source=DataSource.enedis):
    """Énergies affectées (producteur, consommateur, kWh) le 10 du mois, un pas chacune."""
    steps = day_steps(date.fromisoformat(f"{month}-10"))
    with SessionLocal() as db:
        for i, (producer, consumer, kwh) in enumerate(pairs):
            db.add(Allocation(
                loop_id=loop_id, ts=steps[40 + i], producer_meter_id=producer,
                consumer_meter_id=consumer, source=source, kwh=D(kwh),
            ))
        db.commit()


def neighbourhood(admin, month, joined_at="2026-10-01"):
    """Un producteur et deux consommateurs ; énergies Enedis du mois : 142,5 kWh à A, 10 kWh à B."""
    loop_id, members = loop_with_members(
        admin, [("production", 0), ("consumption", 0.2), ("consumption", 0.4)], joined_at
    )
    (p_headers, producer), (a_headers, a), (b_headers, b) = members
    allocate(loop_id, month, [(producer, a, "50"), (producer, a, "50"), (producer, a, "42.5"),
                              (producer, b, "10")])
    return {"loop_id": str(loop_id), "producer": p_headers, "a": a_headers, "b": b_headers}


def run(admin, month):
    response = client.post("/api/v1/admin/billing/run", params={"month": month}, headers=admin)
    assert response.status_code == 200, response.text
    return response.json()


def issue(admin, month):
    return client.post("/api/v1/admin/billing/issue", params={"month": month}, headers=admin)


def mine(headers):
    return client.get("/api/v1/me/statements", headers=headers).json()


# --- Montants -------------------------------------------------------------------------------------


def test_exemple_du_cahier_des_charges():
    """§8.3 : 142,5 kWh à 0,18 € avec 0,02 € de commission."""
    assert consumer_amounts(D("142.5"), D("0.18"), D(0)).gross == D("25.65")
    paid_out = producer_amounts(D("142.5"), D("0.18"), D("0.02"))
    assert paid_out.gross == D("25.65")
    assert (paid_out.commission, paid_out.net) == (D("2.85"), D("22.80"))


def test_un_seul_arrondi_et_brut_egal_commission_plus_net():
    # 0,333333 kWh × 0,18 € = 0,05999994 € → 0,06 € (un arrondi, sur le total)
    assert consumer_amounts(D("0.333333"), D("0.18"), D(0)).gross == D("0.06")
    amounts = producer_amounts(D("12.345678"), D("0.1777"), D("0.0333"))
    assert amounts.gross == amounts.commission + amounts.net
    assert (amounts.gross, amounts.commission) == (D("2.19"), D("0.41"))


def test_turpe_eventuel_ajoute_a_la_facture():
    amounts = consumer_amounts(D("142.5"), D("0.18"), D("0.01"))
    # 1,425 € → 1,43 € (arrondi commercial) ; brut = net = montant dû
    assert (amounts.network_fee, amounts.gross, amounts.net) == (D("1.43"), D("27.08"), D("27.08"))
    assert amounts.commission == D("0.00")


# --- Brouillons ----------------------------------------------------------------------------------


def test_brouillons_du_mois(admin):
    loop = neighbourhood(admin, "2027-01")
    report = run(admin, "2027-01")

    summary = next(item for item in report["loops"] if item["loop_id"] == loop["loop_id"])
    assert summary["statements"] == 3
    assert summary["consumers_eur"] == "27.45"  # 25,65 + 1,80
    assert summary["payouts_eur"] == "24.40"  # 152,5 kWh × 0,16
    assert summary["commission_eur"] == "3.05"

    statements = client.get(
        "/api/v1/admin/billing/statements",
        params={"month": "2027-01", "loop_id": loop["loop_id"]},
        headers=admin,
    ).json()
    by_kind = {(s["direction"], s["net_eur"]) for s in statements}
    assert by_kind == {("consumption", "25.65"), ("consumption", "1.80"), ("production", "24.40")}
    assert all(s["status"] == "draft" and s["number"] is None for s in statements)
    # Brouillons invisibles des participants
    assert mine(loop["a"]) == []


def test_recalcul_d_un_brouillon(admin):
    loop = neighbourhood(admin, "2027-02")
    run(admin, "2027-02")
    with SessionLocal() as db:  # Enedis publie une correction : 50 → 60 kWh sur un pas
        allocation = db.query(Allocation).filter(Allocation.loop_id == loop["loop_id"]).first()
        allocation.kwh = D(60)
        db.commit()

    run(admin, "2027-02")
    statements = client.get(
        "/api/v1/admin/billing/statements",
        params={"month": "2027-02", "loop_id": loop["loop_id"]},
        headers=admin,
    ).json()
    assert len(statements) == 3
    assert {s["kwh"] for s in statements if s["direction"] == "production"} == {162.5}


def test_la_simulation_n_est_jamais_facturee(admin):
    loop_id, ((_, producer), (_, consumer)) = loop_with_members(
        admin, [("production", 0), ("consumption", 0.2)]
    )
    allocate(loop_id, "2027-03", [(producer, consumer, "99")], source=DataSource.simulated)

    report = run(admin, "2027-03")
    assert all(item["loop_id"] != str(loop_id) for item in report["loops"])
    assert any("aucune énergie publiée par Enedis" in reason for reason in report["skipped"])


def test_un_utilisateur_mixte_recoit_facture_et_reversement(admin):
    loop_id, members = loop_with_members(admin, [("production", 0), ("consumption", 0.2)])
    (headers, producer), (_, consumer) = members
    # Le compteur de consommation appartient au même utilisateur que les panneaux
    with SessionLocal() as db:
        user_id = db.get(Meter, producer).user_id
        db.get(Meter, consumer).user_id = user_id
        db.commit()
    allocate(loop_id, "2027-04", [(producer, consumer, "10")])

    run(admin, "2027-04")
    assert issue(admin, "2027-04").status_code == 200
    assert sorted(s["direction"] for s in mine(headers)) == ["consumption", "production"]


# --- Émission -----------------------------------------------------------------------------------


def test_emission_numerotee_sans_trou_et_visible(admin):
    loop = neighbourhood(admin, "2027-05")
    run(admin, "2027-05")

    response = issue(admin, "2027-05")
    assert response.status_code == 200
    body = response.json()
    first = int(NUMBER.match(body["first_number"]).group(1))
    last = int(NUMBER.match(body["last_number"]).group(1))
    assert last - first + 1 == body["issued"] == 3

    statements = client.get(
        "/api/v1/admin/billing/statements", params={"month": "2027-05"}, headers=admin
    ).json()
    numbers = sorted(int(NUMBER.match(s["number"]).group(1)) for s in statements)
    assert numbers == list(range(first, last + 1))

    (bill,) = mine(loop["a"])
    assert (bill["status"], bill["period"], bill["net_eur"]) == ("issued", "2027-05", "25.65")
    assert bill["price_eur_kwh"] == "0.1800"
    (payout,) = mine(loop["producer"])
    assert (payout["gross_eur"], payout["commission_eur"], payout["net_eur"]) == (
        "27.45", "3.05", "24.40",
    )


def test_deux_emissions_successives_se_suivent(admin):
    neighbourhood(admin, "2027-06")
    neighbourhood(admin, "2027-07")
    run(admin, "2027-06")
    run(admin, "2027-07")

    june = issue(admin, "2027-06").json()
    july = issue(admin, "2027-07").json()
    assert int(july["first_number"][-6:]) == int(june["last_number"][-6:]) + 1


def test_un_mois_emis_est_fige(admin):
    loop = neighbourhood(admin, "2027-08")
    run(admin, "2027-08")
    issue(admin, "2027-08")
    before = mine(loop["a"])

    report = run(admin, "2027-08")
    assert any("déjà émis" in reason for reason in report["skipped"])
    assert issue(admin, "2027-08").status_code == 409  # plus rien à émettre
    assert mine(loop["a"]) == before


# --- Accès ---------------------------------------------------------------------------------------


def test_acces_a_un_releve(admin):
    loop = neighbourhood(admin, "2027-09")
    run(admin, "2027-09")
    issue(admin, "2027-09")
    (bill,) = mine(loop["a"])
    url = f"/api/v1/statements/{bill['id']}"

    assert client.get(url, headers=loop["a"]).json()["number"] == bill["number"]
    assert client.get(url, headers=loop["b"]).status_code == 404  # celui d'un voisin
    assert client.get(url, headers=admin).status_code == 200


def test_reserve_a_l_administrateur():
    headers = user_headers()
    for path in ("/api/v1/admin/billing/run", "/api/v1/admin/billing/issue"):
        assert client.post(path, params={"month": "2027-10"}, headers=headers).status_code == 403
    assert client.get(
        "/api/v1/admin/billing/statements", params={"month": "2027-10"}, headers=headers
    ).status_code == 403


def test_mois_invalide(admin):
    assert client.post(
        "/api/v1/admin/billing/run", params={"month": "2027-13"}, headers=admin
    ).status_code == 422
