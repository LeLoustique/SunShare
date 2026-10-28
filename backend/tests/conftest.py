"""Configuration des tests : base dédiée, recréée à chaque lancement, et géocodage simulé.

La base de test se déduit de DATABASE_URL (ou de backend/.env) en suffixant le nom par `_test` :
sunshare → sunshare_test, sur le même serveur. TEST_DATABASE_URL permet d'en imposer une autre.
"""

import os
from pathlib import Path

from dotenv import dotenv_values
from sqlalchemy.engine import make_url

BACKEND = Path(__file__).resolve().parents[1]


# Base de développement : sert aussi de point d'entrée sur le serveur pour recréer la base de test
DEV_URL = os.environ.get("DATABASE_URL") or dotenv_values(BACKEND / ".env").get("DATABASE_URL")


def _test_database_url() -> str:
    if url := os.environ.get("TEST_DATABASE_URL"):
        return url
    url = make_url(DEV_URL)
    return url.set(database=f"{url.database}_test").render_as_string(hide_password=False)


# Avant tout import de `app` : la configuration et le moteur SQLAlchemy lisent DATABASE_URL à l'import
os.environ["DATABASE_URL"] = _test_database_url()

import pytest
from alembic import command
from alembic.config import Config
from sqlalchemy import create_engine, text

from app.geocoding import get_geocoder
from app.main import app
from tests.helpers import FakeGeocoder


def _recreate_test_database() -> None:
    test_url = make_url(os.environ["DATABASE_URL"])
    # Garde-fou : ce code supprime la base, il ne doit jamais viser celle de développement
    if not test_url.database.endswith("_test"):
        raise RuntimeError(f"Base de test refusée (le nom doit finir par _test) : {test_url.database}")

    # Connexion à la base de développement (qui existe toujours) pour recréer la base de test
    server = create_engine(DEV_URL, isolation_level="AUTOCOMMIT")
    with server.connect() as conn:
        conn.execute(text(f'DROP DATABASE IF EXISTS "{test_url.database}" WITH (FORCE)'))
        conn.execute(text(f'CREATE DATABASE "{test_url.database}"'))
    server.dispose()

    database = create_engine(test_url)
    with database.begin() as conn:
        conn.execute(text((BACKEND.parent / "infra/initdb/01-extensions.sql").read_text(encoding="utf-8")))
    database.dispose()

    command.upgrade(Config(str(BACKEND / "alembic.ini")), "head")


@pytest.fixture(scope="session", autouse=True)
def test_database():
    """Base vide et migrée à chaque lancement : les tests ne dépendent pas des lancements précédents."""
    _recreate_test_database()


@pytest.fixture(scope="session", autouse=True)
def fake_geocoder():
    """Aucun test de l'API n'appelle la vraie Base Adresse Nationale, fixtures de module comprises."""
    app.dependency_overrides[get_geocoder] = FakeGeocoder
    yield
    app.dependency_overrides.pop(get_geocoder)


@pytest.fixture(autouse=True)
def geocoder_available():
    """Chaque test repart d'un service d'adresses disponible (certains simulent une panne)."""
    FakeGeocoder.available = True
