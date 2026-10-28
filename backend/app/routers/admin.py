import uuid

from fastapi import APIRouter, HTTPException, status
from sqlalchemy import select

from app import loop_service, perimeter
from app.deps import AdminUser, DbSession
from app.models import Loop, LoopMember, MembershipStatus
from app.schemas import AdminLoopOut, AdminMemberOut, ApproveRequest, LoopCreate, LoopUpdate

router = APIRouter(prefix="/admin/loops", tags=["admin"])

MEMBER_NOT_FOUND = HTTPException(status.HTTP_404_NOT_FOUND, "Adhésion introuvable")
NOT_PENDING = HTTPException(status.HTTP_409_CONFLICT, "Cette demande a déjà été traitée")


def _get_loop(db, loop_id: uuid.UUID) -> Loop:
    loop = db.get(Loop, loop_id)
    if loop is None:
        raise loop_service.LOOP_NOT_FOUND
    return loop


def _get_pending_member(db, loop_id: uuid.UUID, member_id: uuid.UUID) -> LoopMember:
    member = db.get(LoopMember, member_id)
    if member is None or member.loop_id != loop_id:
        raise MEMBER_NOT_FOUND
    if member.status is not MembershipStatus.pending:
        raise NOT_PENDING
    return member


@router.get("", response_model=list[AdminLoopOut])
def admin_list_loops(_admin: AdminUser, db: DbSession) -> list[AdminLoopOut]:
    loops = db.scalars(select(Loop).order_by(Loop.created_at.desc()))
    return [loop_service.admin_loop_out(db, loop) for loop in loops]


@router.post("", response_model=AdminLoopOut, status_code=status.HTTP_201_CREATED)
def admin_create_loop(data: LoopCreate, _admin: AdminUser, db: DbSession) -> AdminLoopOut:
    loop = Loop(**data.model_dump(exclude_none=True))
    db.add(loop)
    db.commit()
    db.refresh(loop)
    return loop_service.admin_loop_out(db, loop)


@router.patch("/{loop_id}", response_model=AdminLoopOut)
def admin_update_loop(
    loop_id: uuid.UUID, data: LoopUpdate, _admin: AdminUser, db: DbSession
) -> AdminLoopOut:
    loop = db.scalar(select(Loop).where(Loop.id == loop_id).with_for_update())
    if loop is None:
        raise loop_service.LOOP_NOT_FOUND
    # Un champ envoyé à null est ignoré, sauf l'identifiant Enedis qu'on peut effacer
    changes = {
        field: value
        for field, value in data.model_dump(exclude_unset=True).items()
        if value is not None or field == "enedis_operation_id"
    }

    price = changes.get("price_eur_kwh", loop.price_eur_kwh)
    commission = changes.get("commission_eur_kwh", loop.commission_eur_kwh)
    if commission >= price:
        raise HTTPException(
            status.HTTP_422_UNPROCESSABLE_CONTENT, "La commission doit être inférieure au tarif"
        )

    new_perimeter = changes.get("perimeter_km")
    if new_perimeter is not None and not perimeter.fits(
        new_perimeter, perimeter.diameter_km(db, loop.id)
    ):
        raise HTTPException(
            status.HTTP_409_CONFLICT,
            "Les membres actuels de la boucle sont plus éloignés que ce périmètre",
        )

    for field, value in changes.items():
        setattr(loop, field, value)
    db.commit()
    db.refresh(loop)
    return loop_service.admin_loop_out(db, loop)


@router.get("/{loop_id}/members", response_model=list[AdminMemberOut])
def admin_list_members(loop_id: uuid.UUID, _admin: AdminUser, db: DbSession) -> list[AdminMemberOut]:
    loop = _get_loop(db, loop_id)
    members = db.scalars(
        select(LoopMember).where(LoopMember.loop_id == loop.id).order_by(LoopMember.requested_at)
    )
    return [loop_service.admin_member_out(m) for m in members]


@router.post("/{loop_id}/members/{member_id}/approve", response_model=AdminMemberOut)
def admin_approve_member(
    loop_id: uuid.UUID,
    member_id: uuid.UUID,
    data: ApproveRequest,
    _admin: AdminUser,
    db: DbSession,
) -> AdminMemberOut:
    """Valide l'adhésion et fixe la date d'entrée dans l'opération.

    Pas de nouveau contrôle du périmètre : une demande en attente y est déjà prise en compte.
    """
    member = _get_pending_member(db, loop_id, member_id)
    member.status = MembershipStatus.active
    member.joined_at = data.joined_at
    db.commit()
    return loop_service.admin_member_out(member)


@router.post("/{loop_id}/members/{member_id}/reject", response_model=AdminMemberOut)
def admin_reject_member(
    loop_id: uuid.UUID, member_id: uuid.UUID, _admin: AdminUser, db: DbSession
) -> AdminMemberOut:
    member = _get_pending_member(db, loop_id, member_id)
    member.status = MembershipStatus.rejected
    db.commit()
    return loop_service.admin_member_out(member)
