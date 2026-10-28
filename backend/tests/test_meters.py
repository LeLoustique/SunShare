import uuid

import pytest
from fastapi.testclient import TestClient

from app.geocoding import Address, GeocodingUnavailable, get_geocoder
from app.main import app

client = TestClient(app)
PASSWORD = "MotDePasseSolide42"

AMIENS = Address(
    label="8 Boulevard du Port 80000 Amiens",
    postcode="80000",
    city="Amiens",
    longitude=2.290084,
    latitude=49.897442,
    score=0.97,
)


class FakeGeocoder:
    """Ne connaît qu'une adresse ; `available=False` simule une panne du service."""

    available = True

    def _check(self):
        if not FakeGeocoder.available:
            raise GeocodingUnavailable

    def suggest(self, query):
        self._check()
        return [AMIENS] if "port" in query.lower() else []

    def locate(self, label):
        self._check()
        return AMIENS if label == AMIENS.label else None


@pytest.fixture(autouse=True)
def fake_geocoder():
    FakeGeocoder.available = True
    app.dependency_overrides[get_geocoder] = FakeGeocoder
    yield
    app.dependency_overrides.pop(get_geocoder)


def new_prm():
    return str(uuid.uuid4().int)[:14]


def user_headers(role="mixed"):
    email = f"test-{uuid.uuid4().hex[:12]}@sunshare-test.fr"
    client.post("/api/v1/auth/register", json={
        "email": email,
        "password": PASSWORD,
        "first_name": "Test",
        "last_name": "Compteur",
        "role": role,
    })
    tokens = client.post(
        "/api/v1/auth/login", data={"username": email, "password": PASSWORD}
    ).json()
    return {"Authorization": f"Bearer {tokens['access_token']}"}


def consumption(**overrides):
    return {"prm": new_prm(), "direction": "consumption", "address": AMIENS.label} | overrides


def production(**overrides):
    return consumption(direction="production", peak_kw=6) | overrides


def create(headers, data):
    return client.post("/api/v1/meters", json=data, headers=headers)


def test_ajout_et_liste():
    headers = user_headers("consumer")
    data = consumption()

    response = create(headers, data)

    assert response.status_code == 201
    meter = response.json()
    assert meter["prm"] == data["prm"]
    assert meter["address"] == AMIENS.label
    assert meter["latitude"] == pytest.approx(AMIENS.latitude)
    assert meter["longitude"] == pytest.approx(AMIENS.longitude)
    assert meter["peak_kw"] is None

    meters = client.get("/api/v1/meters", headers=headers).json()
    assert [m["id"] for m in meters] == [meter["id"]]
    assert meters[0]["latitude"] == pytest.approx(AMIENS.latitude)


def test_compteur_de_production_avec_puissance_crete():
    response = create(user_headers("producer"), production(peak_kw=6.5))

    assert response.status_code == 201
    assert response.json()["peak_kw"] == 6.5


def test_on_ne_voit_que_ses_compteurs():
    create(user_headers(), consumption())
    assert client.get("/api/v1/meters", headers=user_headers()).json() == []


@pytest.mark.parametrize("prm", ["1234567890123", "123456789012345", "1234567890123a", "١٢٣٤٥٦٧٨٩٠١٢٣٤"])
def test_prm_invalide(prm):
    assert create(user_headers(), consumption(prm=prm)).status_code == 422


def test_prm_deja_enregistre():
    data = consumption()
    assert create(user_headers(), data).status_code == 201

    response = create(user_headers(), data)
    assert response.status_code == 409
    assert response.json()["detail"] == "Ce compteur est déjà enregistré"


def test_meme_prm_en_soutirage_et_en_injection():
    headers = user_headers("mixed")
    prm = new_prm()
    assert create(headers, consumption(prm=prm)).status_code == 201
    assert create(headers, production(prm=prm)).status_code == 201


def test_sens_incompatible_avec_le_role():
    assert create(user_headers("consumer"), production()).status_code == 400
    assert create(user_headers("producer"), consumption()).status_code == 400


def test_puissance_crete_obligatoire_en_production_seulement():
    headers = user_headers()
    assert create(headers, production(peak_kw=None)).status_code == 422
    assert create(headers, consumption(peak_kw=3)).status_code == 422
    assert create(headers, production(peak_kw=0)).status_code == 422


def test_adresse_introuvable():
    response = create(user_headers(), consumption(address="12 rue imaginaire 99999 Nullepart"))

    assert response.status_code == 422
    assert "Adresse introuvable" in response.json()["detail"]


def test_service_adresses_indisponible():
    FakeGeocoder.available = False
    assert create(user_headers(), consumption()).status_code == 503


def test_suppression():
    headers = user_headers()
    meter_id = create(headers, consumption()).json()["id"]

    assert client.delete(f"/api/v1/meters/{meter_id}", headers=headers).status_code == 204
    assert client.get("/api/v1/meters", headers=headers).json() == []


def test_impossible_de_supprimer_le_compteur_d_un_autre():
    meter_id = create(user_headers(), consumption()).json()["id"]
    assert client.delete(f"/api/v1/meters/{meter_id}", headers=user_headers()).status_code == 404


def test_compteurs_sans_jeton():
    assert client.get("/api/v1/meters").status_code == 401
    assert client.post("/api/v1/meters", json=consumption()).status_code == 401


def test_suggestions_d_adresses():
    response = client.get("/api/v1/addresses", params={"q": "8 bd du port"}, headers=user_headers())

    assert response.status_code == 200
    assert response.json() == [{
        "label": AMIENS.label,
        "postcode": "80000",
        "city": "Amiens",
        "latitude": AMIENS.latitude,
        "longitude": AMIENS.longitude,
    }]


def test_suggestions_requete_trop_courte_ou_sans_jeton():
    assert client.get("/api/v1/addresses", params={"q": "8"}, headers=user_headers()).status_code == 422
    assert client.get("/api/v1/addresses", params={"q": "8 bd du port"}).status_code == 401


def test_suggestions_service_indisponible():
    FakeGeocoder.available = False
    response = client.get("/api/v1/addresses", params={"q": "8 bd du port"}, headers=user_headers())
    assert response.status_code == 503
