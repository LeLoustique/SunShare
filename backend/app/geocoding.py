"""Géocodage avec la Base Adresse Nationale (service de la Géoplateforme IGN, sans clé d'API).

Documentation : https://geoservices.ign.fr/documentation/services/services-geoplateforme/geocodage
"""

from dataclasses import dataclass
from typing import Annotated

import httpx
from fastapi import Depends

from app.config import settings

# Adresses assez précises pour un compteur : numéro dans une voie, ou lieu-dit (fréquent en zone
# rurale). Les voies (`street`) et communes (`municipality`) sont écartées.
PRECISE_TYPES = {"housenumber", "locality"}

# Un libellé repris tel quel d'une suggestion obtient ~0,97 ; une adresse inventée ~0,3
MIN_SCORE = 0.8


@dataclass(frozen=True)
class Address:
    label: str
    postcode: str
    city: str
    longitude: float
    latitude: float
    score: float


class GeocodingUnavailable(Exception):
    """Service d'adresses injoignable ou en erreur."""


class Geocoder:
    def __init__(self, client: httpx.Client):
        self._client = client

    def _search(self, query: str, limit: int, autocomplete: bool) -> list[Address]:
        params = {"q": query, "limit": limit, "index": "address", "autocomplete": int(autocomplete)}
        try:
            response = self._client.get("/search", params=params)
            response.raise_for_status()
            features = response.json()["features"]
        except (httpx.HTTPError, ValueError, KeyError) as e:
            raise GeocodingUnavailable from e

        addresses = []
        for feature in features:
            props = feature["properties"]
            if props.get("type") not in PRECISE_TYPES:
                continue
            longitude, latitude = feature["geometry"]["coordinates"]
            addresses.append(Address(
                label=props["label"],
                postcode=props.get("postcode", ""),
                city=props.get("city", ""),
                longitude=longitude,
                latitude=latitude,
                score=props["score"],
            ))
        return addresses

    def suggest(self, query: str) -> list[Address]:
        """Suggestions pendant la saisie (5 au plus)."""
        return self._search(query, limit=10, autocomplete=True)[:5]

    def locate(self, label: str) -> Address | None:
        """Adresse précise correspondant au libellé, ou None si aucune n'est assez sûre."""
        for address in self._search(label, limit=5, autocomplete=False):
            if address.score >= MIN_SCORE:
                return address
        return None


_client = httpx.Client(base_url=settings.geocoding_url, timeout=5.0)


def get_geocoder() -> Geocoder:
    return Geocoder(_client)


GeocoderDep = Annotated[Geocoder, Depends(get_geocoder)]
