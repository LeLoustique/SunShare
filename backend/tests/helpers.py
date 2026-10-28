"""Outils partagés par les tests de l'API (base réelle, géocodage simulé)."""

import math
import uuid

from fastapi.testclient import TestClient
from sqlalchemy import select

from app.db import SessionLocal
from app.geocoding import Address, GeocodingUnavailable
from app.main import app
from app.models import User, UserRole

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


def site(km_east: float) -> Address:
    """Adresse fictive à `km_east` km à l'est (négatif : à l'ouest) de AMIENS, sur le même parallèle."""
    km_per_degree = 111.32 * math.cos(math.radians(AMIENS.latitude))
    return Address(
        label=f"Site à {km_east:+.2f} km 80000 Amiens",
        postcode="80000",
        city="Amiens",
        longitude=AMIENS.longitude + km_east / km_per_degree,
        latitude=AMIENS.latitude,
        score=0.97,
    )


class FakeGeocoder:
    """Connaît AMIENS et les adresses fabriquées par `site()` ; `available=False` simule une panne."""

    available = True

    def _check(self):
        if not FakeGeocoder.available:
            raise GeocodingUnavailable

    def suggest(self, query):
        self._check()
        return [AMIENS] if "port" in query.lower() else []

    def locate(self, label):
        self._check()
        if label == AMIENS.label:
            return AMIENS
        if label.startswith("Site à "):
            return site(float(label.split()[2]))
        return None


def new_prm() -> str:
    return str(uuid.uuid4().int)[:14]


def register(role: str = "mixed") -> str:
    email = f"test-{uuid.uuid4().hex[:12]}@sunshare-test.fr"
    client.post("/api/v1/auth/register", json={
        "email": email,
        "password": PASSWORD,
        "first_name": "Test",
        "last_name": "Utilisateur",
        "role": role,
    })
    return email


def headers_for(email: str) -> dict[str, str]:
    tokens = client.post(
        "/api/v1/auth/login", data={"username": email, "password": PASSWORD}
    ).json()
    return {"Authorization": f"Bearer {tokens['access_token']}"}


def user_headers(role: str = "mixed") -> dict[str, str]:
    return headers_for(register(role))


def admin_headers() -> dict[str, str]:
    """Le rôle admin ne se choisit pas à l'inscription : on le donne directement en base."""
    email = register("consumer")
    with SessionLocal() as db:
        db.scalar(select(User).where(User.email == email)).role = UserRole.admin
        db.commit()
    return headers_for(email)
