import uuid

from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)
PASSWORD = "MotDePasseSolide42"


def payload(**overrides):
    data = {
        "email": f"test-{uuid.uuid4().hex[:12]}@sunshare-test.fr",
        "password": PASSWORD,
        "first_name": "Test",
        "last_name": "Utilisateur",
        "role": "consumer",
    }
    return data | overrides


def register(**overrides):
    return client.post("/api/v1/auth/register", json=payload(**overrides))


def login(email, password=PASSWORD):
    return client.post("/api/v1/auth/login", data={"username": email, "password": password})


def test_inscription_connexion_profil():
    data = payload()
    assert client.post("/api/v1/auth/register", json=data).status_code == 201

    tokens = login(data["email"]).json()
    response = client.get("/api/v1/me", headers={"Authorization": f"Bearer {tokens['access_token']}"})

    assert response.status_code == 200
    assert response.json()["email"] == data["email"]
    assert "password_hash" not in response.json()


def test_email_deja_utilise():
    data = payload()
    client.post("/api/v1/auth/register", json=data)
    assert client.post("/api/v1/auth/register", json=data).status_code == 409


def test_email_insensible_a_la_casse():
    data = payload()
    client.post("/api/v1/auth/register", json=data)
    assert login(data["email"].upper()).status_code == 200


def test_mauvais_mot_de_passe():
    data = payload()
    client.post("/api/v1/auth/register", json=data)
    assert login(data["email"], "mauvais-mot-de-passe").status_code == 401


def test_role_admin_refuse():
    assert register(role="admin").status_code == 422


def test_mot_de_passe_trop_court():
    assert register(password="court").status_code == 422


def test_profil_sans_jeton():
    assert client.get("/api/v1/me").status_code == 401


def test_rafraichissement():
    data = payload()
    client.post("/api/v1/auth/register", json=data)
    tokens = login(data["email"]).json()

    response = client.post("/api/v1/auth/refresh", json={"refresh_token": tokens["refresh_token"]})
    assert response.status_code == 200
    assert response.json()["access_token"]


def test_jeton_acces_refuse_pour_rafraichir():
    data = payload()
    client.post("/api/v1/auth/register", json=data)
    tokens = login(data["email"]).json()

    response = client.post("/api/v1/auth/refresh", json={"refresh_token": tokens["access_token"]})
    assert response.status_code == 401
