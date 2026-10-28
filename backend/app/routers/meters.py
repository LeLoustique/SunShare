import uuid

from fastapi import APIRouter, HTTPException, status
from geoalchemy2 import Geometry
from sqlalchemy import cast, func, select
from sqlalchemy.exc import IntegrityError

from app.deps import CurrentUser, DbSession
from app.geocoding import GeocoderDep, GeocodingUnavailable
from app.models import LoopMember, MembershipStatus, Meter, MeterDirection, UserRole
from app.routers.addresses import GEOCODING_DOWN
from app.schemas import MeterCreate, MeterOut

router = APIRouter(prefix="/meters", tags=["compteurs"])

# Sens de compteur autorisés selon le rôle choisi à l'inscription
ALLOWED_DIRECTIONS = {
    UserRole.producer: {MeterDirection.production},
    UserRole.consumer: {MeterDirection.consumption},
    UserRole.mixed: {MeterDirection.production, MeterDirection.consumption},
    UserRole.admin: {MeterDirection.production, MeterDirection.consumption},
}

METER_TAKEN = HTTPException(status.HTTP_409_CONFLICT, "Ce compteur est déjà enregistré")
METER_NOT_FOUND = HTTPException(status.HTTP_404_NOT_FOUND, "Compteur introuvable")

_point = cast(Meter.location, Geometry)
_LATITUDE = func.ST_Y(_point)
_LONGITUDE = func.ST_X(_point)


def _out(meter: Meter, latitude: float, longitude: float) -> MeterOut:
    return MeterOut(
        id=meter.id,
        prm=meter.prm,
        direction=meter.direction,
        address=meter.address,
        latitude=latitude,
        longitude=longitude,
        peak_kw=meter.peak_kw,
        created_at=meter.created_at,
    )


@router.get("", response_model=list[MeterOut])
def list_meters(user: CurrentUser, db: DbSession) -> list[MeterOut]:
    """Compteurs de l'utilisateur connecté (jamais ceux des autres)."""
    rows = db.execute(
        select(Meter, _LATITUDE, _LONGITUDE)
        .where(Meter.user_id == user.id)
        .order_by(Meter.created_at)
    ).all()
    return [_out(*row) for row in rows]


@router.post("", response_model=MeterOut, status_code=status.HTTP_201_CREATED)
def create_meter(
    data: MeterCreate, user: CurrentUser, db: DbSession, geocoder: GeocoderDep
) -> MeterOut:
    if data.direction not in ALLOWED_DIRECTIONS[user.role]:
        raise HTTPException(
            status.HTTP_400_BAD_REQUEST,
            "Ce type de compteur ne correspond pas à votre profil (producteur / consommateur)",
        )

    # Les coordonnées servent au contrôle du périmètre : on ne fait pas confiance au client
    try:
        address = geocoder.locate(data.address)
    except GeocodingUnavailable:
        raise GEOCODING_DOWN from None
    if address is None:
        raise HTTPException(
            status.HTTP_422_UNPROCESSABLE_CONTENT,
            "Adresse introuvable : choisissez-la dans la liste des suggestions",
        )

    meter = Meter(
        user_id=user.id,
        prm=data.prm,
        direction=data.direction,
        address=address.label,
        location=f"SRID=4326;POINT({address.longitude} {address.latitude})",
        peak_kw=data.peak_kw,
    )
    db.add(meter)
    try:
        db.commit()
    except IntegrityError:  # même PRM déjà enregistré dans ce sens (par quiconque)
        db.rollback()
        raise METER_TAKEN from None
    db.refresh(meter)
    return _out(meter, address.latitude, address.longitude)


@router.delete("/{meter_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_meter(meter_id: uuid.UUID, user: CurrentUser, db: DbSession) -> None:
    meter = db.get(Meter, meter_id)
    # 404 aussi pour le compteur d'un autre : on ne révèle pas son existence
    if meter is None or meter.user_id != user.id:
        raise METER_NOT_FOUND

    # L'historique de participation sert à la facturation : seules les demandes refusées s'effacent
    memberships = db.scalars(select(LoopMember).where(LoopMember.meter_id == meter.id)).all()
    if any(m.status is not MembershipStatus.rejected for m in memberships):
        raise HTTPException(
            status.HTTP_409_CONFLICT,
            "Ce compteur participe ou a participé à une boucle : il ne peut pas être supprimé",
        )
    for membership in memberships:
        db.delete(membership)
    db.delete(meter)
    db.commit()
