"""Lecture des réponses de la BAN, sur un serveur simulé (aucun appel réseau)."""

import httpx
import pytest

from app.geocoding import Geocoder, GeocodingUnavailable


def feature(label, type_, score, lon=2.29, lat=49.89):
    return {
        "type": "Feature",
        "geometry": {"type": "Point", "coordinates": [lon, lat]},
        "properties": {
            "label": label,
            "type": type_,
            "score": score,
            "postcode": "80000",
            "city": "Amiens",
        },
    }


def geocoder(handler):
    transport = httpx.MockTransport(handler)
    return Geocoder(httpx.Client(transport=transport, base_url="https://ban.test"))


def respond(*features):
    return lambda request: httpx.Response(200, json={"features": list(features)})


def test_suggestions_ne_garde_que_les_adresses_precises():
    g = geocoder(respond(
        feature("Boulevard du Port 80000 Amiens", "street", 0.9),
        feature("8 Boulevard du Port 80000 Amiens", "housenumber", 0.8),
        feature("Le Moulin 80150 Bernay-en-Ponthieu", "locality", 0.7),
        feature("Amiens", "municipality", 0.6),
    ))

    labels = [a.label for a in g.suggest("bd du port")]

    assert labels == ["8 Boulevard du Port 80000 Amiens", "Le Moulin 80150 Bernay-en-Ponthieu"]


def test_parametres_envoyes():
    requests = []

    def handler(request):
        requests.append(request)
        return httpx.Response(200, json={"features": []})

    geocoder(handler).suggest("8 bd du port")

    params = requests[0].url.params
    assert requests[0].url.path == "/search"
    assert params["q"] == "8 bd du port"
    assert params["index"] == "address"
    assert params["autocomplete"] == "1"


def test_localisation_avec_coordonnees():
    g = geocoder(respond(feature("8 Boulevard du Port 80000 Amiens", "housenumber", 0.97, 2.290084, 49.897442)))

    address = g.locate("8 Boulevard du Port 80000 Amiens")

    assert address.longitude == 2.290084
    assert address.latitude == 49.897442


def test_localisation_score_trop_faible():
    g = geocoder(respond(feature("Allée du Musée Imaginaire 03400 Yzeure", "housenumber", 0.32)))
    assert g.locate("12 rue imaginaire 99999 nullepart") is None


@pytest.mark.parametrize("handler", [
    lambda request: httpx.Response(500),
    lambda request: httpx.Response(200, text="pas du json"),
    lambda request: (_ for _ in ()).throw(httpx.ConnectError("injoignable")),
])
def test_service_indisponible(handler):
    with pytest.raises(GeocodingUnavailable):
        geocoder(handler).suggest("8 bd du port")
