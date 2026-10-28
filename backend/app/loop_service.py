"""Requêtes et conversions partagées par les routes des boucles (membres et administrateur)."""

import uuid

from fastapi import HTTPException, status
from sqlalchemy import func, select
from sqlalchemy.orm import Session

from app import perimeter
from app.models import (
    ENGAGED_STATUSES,
    Loop,
    LoopMember,
    MembershipStatus,
    Meter,
    MeterDirection,
)
from app.schemas import AdminLoopOut, AdminMemberOut, LoopOut, LoopStats, MembershipOut

LOOP_NOT_FOUND = HTTPException(status.HTTP_404_NOT_FOUND, "Boucle introuvable")


def stats(db: Session, loop: Loop) -> LoopStats:
    """Chiffres de la boucle, calculés sur les membres actifs (le diamètre inclut les demandes)."""
    rows = db.execute(
        select(Meter.direction, func.count(), func.coalesce(func.sum(Meter.peak_kw), 0))
        .join(LoopMember, LoopMember.meter_id == Meter.id)
        .where(LoopMember.loop_id == loop.id, LoopMember.status == MembershipStatus.active)
        .group_by(Meter.direction)
    ).all()
    counts = {direction: (count, peak) for direction, count, peak in rows}
    producers, peak = counts.get(MeterDirection.production, (0, 0))
    consumers, _ = counts.get(MeterDirection.consumption, (0, 0))
    return LoopStats(
        member_count=producers + consumers,
        producer_count=producers,
        consumer_count=consumers,
        total_peak_kw=float(peak),
        diameter_km=round(perimeter.diameter_km(db, loop.id), 3),
    )


def loop_out(db: Session, loop: Loop) -> LoopOut:
    return LoopOut(
        id=loop.id,
        name=loop.name,
        perimeter_km=loop.perimeter_km,
        price_eur_kwh=loop.price_eur_kwh,
        status=loop.status,
        stats=stats(db, loop),
    )


def admin_loop_out(db: Session, loop: Loop) -> AdminLoopOut:
    pending = db.scalar(
        select(func.count())
        .select_from(LoopMember)
        .where(LoopMember.loop_id == loop.id, LoopMember.status == MembershipStatus.pending)
    )
    return AdminLoopOut(
        **loop_out(db, loop).model_dump(),
        commission_eur_kwh=loop.commission_eur_kwh,
        allocation_mode=loop.allocation_mode,
        enedis_operation_id=loop.enedis_operation_id,
        pending_count=pending,
        created_at=loop.created_at,
    )


def membership_out(member: LoopMember) -> MembershipOut:
    return MembershipOut(
        id=member.id,
        loop_id=member.loop_id,
        loop_name=member.loop.name,
        meter_id=member.meter_id,
        prm=member.meter.prm,
        direction=member.meter.direction,
        status=member.status,
        requested_at=member.requested_at,
        joined_at=member.joined_at,
        left_at=member.left_at,
    )


def admin_member_out(member: LoopMember) -> AdminMemberOut:
    meter, user = member.meter, member.meter.user
    return AdminMemberOut(
        **membership_out(member).model_dump(),
        first_name=user.first_name,
        last_name=user.last_name,
        email=user.email,
        address=meter.address,
        peak_kw=meter.peak_kw,
    )


def is_engaged(db: Session, meter_id: uuid.UUID) -> bool:
    """Le compteur a-t-il une demande en attente ou une participation active ?"""
    return db.scalar(
        select(LoopMember.id)
        .where(LoopMember.meter_id == meter_id, LoopMember.status.in_(ENGAGED_STATUSES))
        .limit(1)
    ) is not None
