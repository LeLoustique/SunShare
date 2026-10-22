from fastapi.testclient import TestClient

from app.main import app


def test_health_repond_et_liste_les_extensions():
    response = TestClient(app).get("/health")

    assert response.status_code == 200
    body = response.json()
    assert body["status"] == "ok"
    assert {"postgis", "timescaledb", "pgcrypto"} <= body["extensions"].keys()
