import uuid

from fastapi import APIRouter, HTTPException, status
from sqlalchemy import select
from sqlalchemy.exc import IntegrityError

from app import loop_service, perimeter
from app.deps import CurrentUser, DbSession
from app.models import (
    ENGAGED_STATUSES,
    Loop,
    LoopMember,
    LoopStatus,
    MembershipStatus,
    Meter,
    UserRole,
)
from app.schemas import AvailableLoop, JoinRequest, LoopOut, MembershipOut

router = APIRouter(prefix="/loops", tags=["boucles"])
me_router = APIRouter(prefix="/me/memberships", tags=["boucles"])

METER_NOT_FOUND = HTTPException(status.HTTP_404_NOT_FOUND, "Compteur introuvable")
ALREADY_ENGAGED = HTTPException(
    status.HTTP_409_CONFLICT, "Ce compteur a déjà une demande en cours ou participe à une boucle"
)


@router.get("/available", response_model=list[AvailableLoop])
def list_available_loops(user: CurrentUser, db: DbSession) -> list[AvailableLoop]:
    """Boucles ouvertes que les compteurs libres de l'utilisateur peuvent rejoindre."""
    free_meters = [
        meter
        for meter in db.scalars(select(Meter).where(Meter.user_id == user.id))
        if not loop_service.is_engaged(db, meter.id)
    ]
    if not free_meters:
        return []

    available = []
    for loop in db.scalars(select(Loop).where(Loop.status == LoopStatus.open).order_by(Loop.name)):
        joinable = [
            meter.id
            for meter in free_meters
            if perimeter.fits(
                loop.perimeter_km, perimeter.farthest_member_km(db, loop.id, meter.id)
            )
        ]
        if joinable:
            available.append(AvailableLoop(
                id=loop.id,
                name=loop.name,
                perimeter_km=loop.perimeter_km,
                price_eur_kwh=loop.price_eur_kwh,
                member_count=loop_service.stats(db, loop).member_count,
                joinable_meter_ids=joinable,
            ))
    return available


@router.post("/{loop_id}/join", response_model=MembershipOut, status_code=status.HTTP_201_CREATED)
def join_loop(loop_id: uuid.UUID, data: JoinRequest, user: CurrentUser, db: DbSession) -> MembershipOut:
    """Demande d'adhésion d'un compteur ; validée ensuite par l'administrateur de la PMO."""
    # Verrou sur la boucle : deux demandes simultanées ne peuvent pas passer chacune le contrôle
    # du périmètre puis, ensemble, le dépasser
    loop = db.scalar(select(Loop).where(Loop.id == loop_id).with_for_update())
    if loop is None or loop.status is not LoopStatus.open:
        raise loop_service.LOOP_NOT_FOUND

    meter = db.get(Meter, data.meter_id)
    if meter is None or meter.user_id != user.id:
        raise METER_NOT_FOUND
    if loop_service.is_engaged(db, meter.id):
        raise ALREADY_ENGAGED

    distance = perimeter.farthest_member_km(db, loop.id, meter.id)
    if not perimeter.fits(loop.perimeter_km, distance):
        # Pas de distance dans le message : elle renseignerait sur la position des autres membres
        raise HTTPException(
            status.HTTP_409_CONFLICT,
            f"Votre compteur est hors du périmètre de la boucle ({perimeter.format_km(loop.perimeter_km)} "
            "au plus entre les deux sites les plus éloignés)",
        )

    member = LoopMember(loop_id=loop.id, meter_id=meter.id)
    db.add(member)
    try:
        db.commit()
    except IntegrityError:  # index unique partiel : demande simultanée pour le même compteur
        db.rollback()
        raise ALREADY_ENGAGED from None
    db.refresh(member)
    return loop_service.membership_out(member)


@router.get("/{loop_id}", response_model=LoopOut)
def read_loop(loop_id: uuid.UUID, user: CurrentUser, db: DbSession) -> LoopOut:
    """Détail d'une boucle, réservé à ses membres (demande en cours comprise) et à l'administrateur."""
    loop = db.get(Loop, loop_id)
    if loop is None:
        raise loop_service.LOOP_NOT_FOUND
    if user.role is not UserRole.admin:
        is_member = db.scalar(
            select(LoopMember.id)
            .join(Meter, Meter.id == LoopMember.meter_id)
            .where(
                LoopMember.loop_id == loop.id,
                Meter.user_id == user.id,
                LoopMember.status.in_(ENGAGED_STATUSES),
            )
            .limit(1)
        )
        if is_member is None:
            raise loop_service.LOOP_NOT_FOUND  # 404 : on ne confirme pas l'existence de la boucle
    return loop_service.loop_out(db, loop)


@me_router.get("", response_model=list[MembershipOut])
def list_my_memberships(user: CurrentUser, db: DbSession) -> list[MembershipOut]:
    """Demandes et participations de l'utilisateur, toutes boucles et tous statuts confondus."""
    members = db.scalars(
        select(LoopMember)
        .join(Meter, Meter.id == LoopMember.meter_id)
        .where(Meter.user_id == user.id)
        .order_by(LoopMember.requested_at.desc())
    )
    return [loop_service.membership_out(m) for m in members]


@me_router.delete("/{membership_id}", status_code=status.HTTP_204_NO_CONTENT)
def cancel_membership(membership_id: uuid.UUID, user: CurrentUser, db: DbSession) -> None:
    """Annule une demande encore en attente (la sortie d'un membre actif viendra plus tard)."""
    member = db.get(LoopMember, membership_id)
    if member is None or member.meter.user_id != user.id:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Demande introuvable")
    if member.status is not MembershipStatus.pending:
        raise HTTPException(status.HTTP_409_CONFLICT, "Seule une demande en attente peut être annulée")
    db.delete(member)
    db.commit()
