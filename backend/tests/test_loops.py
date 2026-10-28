"""Boucles, adhésions et contrôle du périmètre.

Les sites sont alignés d'ouest en est (voir `site()`) : leurs distances se lisent directement.
Pour un périmètre de 2 km, la marge de 50 m fixe la limite à 1,95 km.
"""

from decimal import Decimal

import pytest

from app.perimeter import format_km
from tests.helpers import admin_headers, client, new_prm, site, user_headers

ADMIN = None


@pytest.fixture(scope="module", autouse=True)
def admin():
    global ADMIN
    ADMIN = admin_headers()


def new_loop(**overrides):
    data = {"name": "Boucle de test", "price_eur_kwh": "0.18", "commission_eur_kwh": "0.02"}
    response = client.post("/api/v1/admin/loops", json=data | overrides, headers=ADMIN)
    assert response.status_code == 201, response.text
    return response.json()


def new_meter(headers, km_east, direction="consumption"):
    data = {"prm": new_prm(), "direction": direction, "address": site(km_east).label}
    if direction == "production":
        data["peak_kw"] = 6
    response = client.post("/api/v1/meters", json=data, headers=headers)
    assert response.status_code == 201, response.text
    return response.json()["id"]


def join(headers, loop_id, meter_id):
    return client.post(f"/api/v1/loops/{loop_id}/join", json={"meter_id": meter_id}, headers=headers)


def member_at(loop_id, km_east, direction="consumption"):
    """Inscrit un nouvel utilisateur dont le compteur, à `km_east`, rejoint la boucle."""
    headers = user_headers("mixed")
    meter_id = new_meter(headers, km_east, direction)
    response = join(headers, loop_id, meter_id)
    return headers, meter_id, response


def approve(loop_id, member_id, joined_at="2026-11-01"):
    return client.post(
        f"/api/v1/admin/loops/{loop_id}/members/{member_id}/approve",
        json={"joined_at": joined_at},
        headers=ADMIN,
    )


# --- Création et paramétrage (administrateur) -------------------------------------------------


def test_creation_avec_valeurs_par_defaut():
    loop = new_loop()

    assert loop["perimeter_km"] == 2
    assert loop["price_eur_kwh"] == "0.1800"  # montant exact, jamais un flottant
    assert loop["commission_eur_kwh"] == "0.0200"
    assert loop["allocation_mode"] == "dynamic_default"
    assert loop["status"] == "open"
    assert loop["stats"]["member_count"] == 0


def test_creation_reservee_a_l_administrateur():
    data = {"name": "Pirate", "price_eur_kwh": "0.18", "commission_eur_kwh": "0.02"}
    assert client.post("/api/v1/admin/loops", json=data, headers=user_headers()).status_code == 403
    assert client.post("/api/v1/admin/loops", json=data).status_code == 401
    assert client.get("/api/v1/admin/loops", headers=user_headers()).status_code == 403


def test_commission_superieure_au_tarif_refusee():
    data = {"name": "Boucle", "price_eur_kwh": "0.10", "commission_eur_kwh": "0.10"}
    assert client.post("/api/v1/admin/loops", json=data, headers=ADMIN).status_code == 422

    loop = new_loop()
    response = client.patch(
        f"/api/v1/admin/loops/{loop['id']}", json={"price_eur_kwh": "0.01"}, headers=ADMIN
    )
    assert response.status_code == 422


def test_modification():
    loop = new_loop()

    response = client.patch(
        f"/api/v1/admin/loops/{loop['id']}",
        json={"name": "Quartier Saint-Leu", "price_eur_kwh": "0.1650", "enedis_operation_id": "ACC-42"},
        headers=ADMIN,
    )

    assert response.status_code == 200
    assert response.json()["name"] == "Quartier Saint-Leu"
    assert response.json()["price_eur_kwh"] == "0.1650"
    assert response.json()["enedis_operation_id"] == "ACC-42"


def test_reduire_le_perimetre_sous_le_diametre_actuel_refuse():
    loop = new_loop()
    member_at(loop["id"], 0)
    member_at(loop["id"], 1.5)

    url = f"/api/v1/admin/loops/{loop['id']}"
    assert client.patch(url, json={"perimeter_km": 1}, headers=ADMIN).status_code == 409
    assert client.patch(url, json={"perimeter_km": 10}, headers=ADMIN).status_code == 200


# --- Contrôle du périmètre ---------------------------------------------------------------------


def test_perimetre_est_un_diametre_pas_un_rayon():
    loop = new_loop()
    for km in (0, 1, 1.9):
        assert member_at(loop["id"], km)[2].status_code == 201

    # À 2 km du premier site : au-delà de la limite de 1,95 km
    assert member_at(loop["id"], 2.0)[2].status_code == 409

    # À 500 m à l'ouest du premier site, mais à 2,4 km du site le plus à l'est : refusé
    _, _, response = member_at(loop["id"], -0.5)
    assert response.status_code == 409
    assert "hors du périmètre" in response.json()["detail"]


def test_les_demandes_en_attente_comptent_dans_le_perimetre():
    loop = new_loop()
    assert member_at(loop["id"], 0)[2].json()["status"] == "pending"
    assert member_at(loop["id"], 2.5)[2].status_code == 409


def test_perimetre_derogatoire_de_10_km():
    loop = new_loop(perimeter_km=10)
    member_at(loop["id"], 0)
    assert member_at(loop["id"], 8)[2].status_code == 201

    _, _, response = member_at(loop["id"], -2.5)
    assert response.status_code == 409
    assert "(10 km au plus" in response.json()["detail"]


@pytest.mark.parametrize(("km", "text"), [("2.00", "2 km"), ("2.50", "2,5 km"), ("10.00", "10 km")])
def test_format_km(km, text):
    assert format_km(Decimal(km)) == text


def test_un_utilisateur_mixte_engage_ses_deux_compteurs():
    loop = new_loop()
    headers = user_headers("mixed")
    consumption = new_meter(headers, 0.3)
    production = new_meter(headers, 0.3, "production")

    assert join(headers, loop["id"], consumption).status_code == 201
    assert join(headers, loop["id"], production).status_code == 201


# --- Boucles disponibles -----------------------------------------------------------------------


def test_boucles_disponibles_selon_l_adresse():
    loop = new_loop()
    member_at(loop["id"], 0)

    near = user_headers()
    near_meter = new_meter(near, 1)
    far = user_headers()
    new_meter(far, 3)

    available = client.get("/api/v1/loops/available", headers=near).json()
    entry = next(item for item in available if item["id"] == loop["id"])
    assert entry["joinable_meter_ids"] == [near_meter]
    assert entry["price_eur_kwh"] == "0.1800"

    far_ids = [item["id"] for item in client.get("/api/v1/loops/available", headers=far).json()]
    assert loop["id"] not in far_ids


def test_compteur_deja_engage_n_a_plus_de_boucle_disponible():
    loop = new_loop()
    headers, meter_id, _ = member_at(loop["id"], 0)

    available = client.get("/api/v1/loops/available", headers=headers).json()
    assert available == []
    # … et ne peut pas rejoindre une seconde boucle
    assert join(headers, new_loop()["id"], meter_id).status_code == 409


def test_boucle_fermee():
    loop = new_loop()
    client.patch(f"/api/v1/admin/loops/{loop['id']}", json={"status": "closed"}, headers=ADMIN)

    headers = user_headers()
    meter_id = new_meter(headers, 0)
    assert join(headers, loop["id"], meter_id).status_code == 404
    ids = [item["id"] for item in client.get("/api/v1/loops/available", headers=headers).json()]
    assert loop["id"] not in ids


def test_impossible_d_engager_le_compteur_d_un_autre():
    loop = new_loop()
    other_meter = new_meter(user_headers(), 0)
    assert join(user_headers(), loop["id"], other_meter).status_code == 404


# --- Validation, refus, annulation -------------------------------------------------------------


def test_validation_par_l_administrateur():
    loop = new_loop()
    headers, _, response = member_at(loop["id"], 0, "production")
    member_id = response.json()["id"]

    members = client.get(f"/api/v1/admin/loops/{loop['id']}/members", headers=ADMIN).json()
    assert members[0]["status"] == "pending"
    assert members[0]["email"].endswith("@sunshare-test.fr")

    approved = approve(loop["id"], member_id)
    assert approved.status_code == 200
    assert approved.json()["status"] == "active"
    assert approved.json()["joined_at"] == "2026-11-01"
    assert approve(loop["id"], member_id).status_code == 409  # déjà traitée

    mine = client.get("/api/v1/me/memberships", headers=headers).json()
    assert [(m["loop_name"], m["status"]) for m in mine] == [("Boucle de test", "active")]


def test_validation_reservee_a_l_administrateur():
    loop = new_loop()
    headers, _, response = member_at(loop["id"], 0)
    url = f"/api/v1/admin/loops/{loop['id']}/members/{response.json()['id']}/approve"
    assert client.post(url, json={"joined_at": "2026-11-01"}, headers=headers).status_code == 403


def test_refus_libere_le_compteur_et_la_place():
    loop = new_loop()
    headers, meter_id, response = member_at(loop["id"], 0)

    rejected = client.post(
        f"/api/v1/admin/loops/{loop['id']}/members/{response.json()['id']}/reject", headers=ADMIN
    )
    assert rejected.json()["status"] == "rejected"

    # Le site refusé ne compte plus dans le périmètre…
    assert member_at(loop["id"], 1.9)[2].status_code == 201
    # … et le compteur peut demander une autre boucle
    assert join(headers, new_loop()["id"], meter_id).status_code == 201


def test_annulation_d_une_demande_en_attente():
    loop = new_loop()
    headers, _, response = member_at(loop["id"], 0)
    membership_id = response.json()["id"]

    assert client.delete(f"/api/v1/me/memberships/{membership_id}", headers=headers).status_code == 204
    assert client.get("/api/v1/me/memberships", headers=headers).json() == []


def test_impossible_d_annuler_une_participation_active():
    loop = new_loop()
    headers, _, response = member_at(loop["id"], 0)
    approve(loop["id"], response.json()["id"])

    url = f"/api/v1/me/memberships/{response.json()['id']}"
    assert client.delete(url, headers=headers).status_code == 409
    assert client.delete(url, headers=user_headers()).status_code == 404  # pas la sienne


# --- Détail d'une boucle -----------------------------------------------------------------------


def test_detail_reserve_aux_membres():
    loop = new_loop()
    producer, _, p = member_at(loop["id"], 0, "production")
    _, _, c = member_at(loop["id"], 1.2)
    approve(loop["id"], p.json()["id"])
    approve(loop["id"], c.json()["id"])
    member_at(loop["id"], 0.5)  # en attente : hors statistiques

    detail = client.get(f"/api/v1/loops/{loop['id']}", headers=producer)
    assert detail.status_code == 200
    stats = detail.json()["stats"]
    assert stats["member_count"] == 2
    assert stats["producer_count"] == 1
    assert stats["consumer_count"] == 1
    assert stats["total_peak_kw"] == 6
    assert stats["diameter_km"] == pytest.approx(1.2, abs=0.01)
    # Rien d'individuel sur les autres membres
    assert "members" not in detail.json()

    assert client.get(f"/api/v1/loops/{loop['id']}", headers=user_headers()).status_code == 404
    assert client.get(f"/api/v1/loops/{loop['id']}", headers=ADMIN).status_code == 200


# --- Compteurs engagés -------------------------------------------------------------------------


def test_compteur_engage_non_supprimable():
    loop = new_loop()
    headers, meter_id, _ = member_at(loop["id"], 0)

    response = client.delete(f"/api/v1/meters/{meter_id}", headers=headers)
    assert response.status_code == 409


def test_compteur_seulement_refuse_supprimable():
    loop = new_loop()
    headers, meter_id, response = member_at(loop["id"], 0)
    client.post(
        f"/api/v1/admin/loops/{loop['id']}/members/{response.json()['id']}/reject", headers=ADMIN
    )

    assert client.delete(f"/api/v1/meters/{meter_id}", headers=headers).status_code == 204
