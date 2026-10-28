import pytest

from app.geocoding import get_geocoder
from app.main import app
from tests.helpers import FakeGeocoder


@pytest.fixture(autouse=True)
def fake_geocoder():
    """Aucun test de l'API n'appelle la vraie Base Adresse Nationale."""
    FakeGeocoder.available = True
    app.dependency_overrides[get_geocoder] = FakeGeocoder
    yield
    app.dependency_overrides.pop(get_geocoder)
