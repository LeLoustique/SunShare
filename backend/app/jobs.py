"""Traitements par lots, jour par jour : jamais en temps réel, les données Enedis arrivent en J+1.

Pour une journée (française, de minuit à minuit) : courbes simulées des compteurs membres actifs,
puis répartition de chaque boucle pas par pas. Rejouer une journée donne le même résultat.
"""

import uuid
from dataclasses import dataclass
from datetime import date, timedelta
from decimal import Decimal

from geoalchemy2 import Geometry
from sqlalchemy import cast, delete, func, insert, or_, select
from sqlalchemy.dialects.postgresql import insert as pg_insert
from sqlalchemy.orm import Session

from app import allocation
from app.models import (
    Allocation,
    AllocationMode,
    DataSource,
    LoadCurve,
    Loop,
    LoopMember,
    MembershipStatus,
    Meter,
    MeterDirection,
)
from app.simulation import consumption_curve, production_curve
from app.timesteps import HOURS_PER_STEP, STEP, day_steps

SUPPORTED_MODES = {AllocationMode.dynamic_default, AllocationMode.static}


@dataclass
class DayReport:
    day: date
    curve_points: int
    loops: int
    allocations: int
    # Boucles ignorées (clé de répartition non prise en charge) : les autres sont traitées
    skipped: list[str]


def _active_on(day: date):
    """Conditions SQL : participation active à cette date (entrée passée, pas encore sortie)."""
    return (
        LoopMember.status == MembershipStatus.active,
        LoopMember.joined_at <= day,
        or_(LoopMember.left_at.is_(None), LoopMember.left_at > day),
    )


def simulate_curves(db: Session, day: date) -> int:
    """Courbes simulées des compteurs membres actifs d'une boucle ce jour-là.

    Une courbe Enedis déjà présente n'est jamais remplacée par une courbe simulée.
    """
    point = cast(Meter.location, Geometry)
    meters = db.execute(
        select(Meter, func.ST_Y(point), func.ST_X(point))
        .join(LoopMember, LoopMember.meter_id == Meter.id)
        .where(*_active_on(day))
        .distinct()
    ).all()

    rows = []
    for meter, latitude, longitude in meters:
        if meter.direction is MeterDirection.production:
            curve = production_curve(meter.id, day, meter.peak_kw, latitude, longitude)
        else:
            curve = consumption_curve(meter.id, day)
        rows += [
            {"meter_id": meter.id, "ts": ts, "kw_avg": kw, "source": DataSource.simulated}
            for ts, kw in curve
        ]
    if not rows:
        return 0

    upsert = pg_insert(LoadCurve).values(rows)
    db.execute(
        upsert.on_conflict_do_update(
            index_elements=[LoadCurve.meter_id, LoadCurve.ts],
            set_={"kw_avg": upsert.excluded.kw_avg, "source": upsert.excluded.source},
            where=LoadCurve.source == DataSource.simulated,
        )
    )
    return len(rows)


def allocate_day(db: Session, loop: Loop, day: date) -> int:
    """Répartition simulée d'une boucle sur une journée ; renvoie le nombre de paires enregistrées.

    Un pas sans mesure pour un compteur compte pour zéro (rien n'est affecté sur une donnée absente).
    """
    if loop.allocation_mode not in SUPPORTED_MODES:
        # Avant toute écriture : la répartition existante de la boucle reste intacte
        raise NotImplementedError(f"Clé de répartition non prise en charge : {loop.allocation_mode.value}")

    members = db.execute(
        select(LoopMember.meter_id, Meter.direction, LoopMember.static_key)
        .join(Meter, Meter.id == LoopMember.meter_id)
        .where(LoopMember.loop_id == loop.id, *_active_on(day))
    ).all()
    directions = {meter_id: direction for meter_id, direction, _ in members}
    keys = {meter_id: key for meter_id, _, key in members if key is not None}

    steps = day_steps(day)
    start, end = steps[0], steps[-1] + STEP
    db.execute(
        delete(Allocation).where(
            Allocation.loop_id == loop.id,
            Allocation.source == DataSource.simulated,
            Allocation.ts >= start,
            Allocation.ts < end,
        )
    )
    if not members:
        return 0

    energy: dict = {ts: ({}, {}) for ts in steps}  # pas → (production, consommation) en kWh
    for meter_id, ts, kw in db.execute(
        select(LoadCurve.meter_id, LoadCurve.ts, LoadCurve.kw_avg).where(
            LoadCurve.meter_id.in_(directions), LoadCurve.ts >= start, LoadCurve.ts < end
        )
    ):
        production, consumption = energy[ts]
        target = production if directions[meter_id] is MeterDirection.production else consumption
        target[meter_id] = kw * HOURS_PER_STEP

    rows = []
    for ts, (production, consumption) in energy.items():
        pairs = _allocate(loop.allocation_mode, production, consumption, keys)
        rows += [
            {
                "loop_id": loop.id,
                "ts": ts,
                "producer_meter_id": producer,
                "consumer_meter_id": consumer,
                "source": DataSource.simulated,
                "kwh": kwh,
            }
            for (producer, consumer), kwh in pairs.items()
        ]
    if rows:
        db.execute(insert(Allocation), rows)
    return len(rows)


def _allocate(
    mode: AllocationMode,
    production: dict[uuid.UUID, Decimal],
    consumption: dict[uuid.UUID, Decimal],
    keys: dict[uuid.UUID, Decimal],
) -> allocation.Pairs:
    if mode is AllocationMode.dynamic_default:
        return allocation.dynamic_default(production, consumption)
    return allocation.static(production, consumption, keys)


def run_day(db: Session, day: date) -> DayReport:
    """Courbes simulées puis répartition de toutes les boucles ayant des membres actifs ce jour-là."""
    points = simulate_curves(db, day)
    loops = db.scalars(
        select(Loop).join(LoopMember, LoopMember.loop_id == Loop.id).where(*_active_on(day)).distinct()
    ).all()
    allocations, skipped = 0, []
    for loop in loops:
        try:
            allocations += allocate_day(db, loop, day)
        except NotImplementedError:
            skipped.append(loop.name)
    db.commit()
    return DayReport(
        day=day, curve_points=points, loops=len(loops), allocations=allocations, skipped=skipped
    )


def days(first: date, last: date) -> list[date]:
    return [first + timedelta(days=i) for i in range((last - first).days + 1)]
