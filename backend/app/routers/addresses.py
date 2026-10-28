from typing import Annotated

from fastapi import APIRouter, HTTPException, Query, status

from app.deps import CurrentUser
from app.geocoding import GeocoderDep, GeocodingUnavailable
from app.schemas import AddressSuggestion

router = APIRouter(prefix="/addresses", tags=["adresses"])

GEOCODING_DOWN = HTTPException(
    status.HTTP_503_SERVICE_UNAVAILABLE,
    "Le service d'adresses est momentanément indisponible. Réessayez plus tard.",
)


@router.get("", response_model=list[AddressSuggestion])
def search_addresses(
    q: Annotated[str, Query(min_length=3, max_length=200)],
    _user: CurrentUser,  # réservé aux utilisateurs connectés : pas de relais ouvert vers la BAN
    geocoder: GeocoderDep,
) -> list[AddressSuggestion]:
    """Suggestions d'adresses précises (numéro ou lieu-dit) pendant la saisie."""
    try:
        addresses = geocoder.suggest(q)
    except GeocodingUnavailable:
        raise GEOCODING_DOWN from None
    return [
        AddressSuggestion(
            label=a.label,
            postcode=a.postcode,
            city=a.city,
            latitude=a.latitude,
            longitude=a.longitude,
        )
        for a in addresses
    ]
