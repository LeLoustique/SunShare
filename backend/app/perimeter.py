"""Contrôle du périmètre d'une boucle (cahier des charges §8.1).

La boucle est conforme si la plus grande distance entre deux de ses sites ne dépasse pas le
périmètre (un diamètre, pas un rayon autour d'un utilisateur). À l'ajout d'un site, il suffit de
le comparer aux sites déjà engagés : les paires existantes sont conformes par construction.
"""

import uuid
from decimal import Decimal

from sqlalchemy import func, select
from sqlalchemy.orm import Session, aliased

from app.models import ENGAGED_STATUSES, LoopMember, Meter

# Le géocodage de l'adresse n'est qu'une approximation du point de livraison : 50 m de marge
# (2 km → refus au-delà de 1,95 km)
MARGIN_KM = Decimal("0.05")


def max_allowed_km(perimeter_km: Decimal) -> Decimal:
    return perimeter_km - MARGIN_KM


def format_km(km: Decimal) -> str:
    """« 2 km », « 2,5 km », « 10 km » (et non « 1E+1 » comme avec Decimal.normalize)."""
    return f"{km:f}".rstrip("0").rstrip(".").replace(".", ",") + " km"


def fits(perimeter_km: Decimal, distance_km: float | None) -> bool:
    """La distance (None : boucle encore vide) respecte-t-elle le périmètre, marge comprise ?"""
    return distance_km is None or distance_km <= float(max_allowed_km(perimeter_km))


def farthest_member_km(db: Session, loop_id: uuid.UUID, meter_id: uuid.UUID) -> float | None:
    """Distance entre le compteur et le site engagé le plus éloigné de la boucle (None si vide).

    `location` est de type geography : ST_Distance renvoie des mètres sur l'ellipsoïde.
    """
    candidate = aliased(Meter)
    member = aliased(Meter)
    distance_m = db.scalar(
        select(func.max(func.ST_Distance(member.location, candidate.location)))
        .select_from(LoopMember)
        .join(member, member.id == LoopMember.meter_id)
        .join(candidate, candidate.id == meter_id)
        .where(LoopMember.loop_id == loop_id, LoopMember.status.in_(ENGAGED_STATUSES))
    )
    return None if distance_m is None else distance_m / 1000


def diameter_km(db: Session, loop_id: uuid.UUID) -> float:
    """Plus grande distance entre deux sites engagés de la boucle (0 s'il y en a moins de deux)."""
    a, b = aliased(LoopMember), aliased(LoopMember)
    meter_a, meter_b = aliased(Meter), aliased(Meter)
    distance_m = db.scalar(
        select(func.max(func.ST_Distance(meter_a.location, meter_b.location)))
        .select_from(a)
        .join(b, (b.loop_id == a.loop_id) & (b.id < a.id))
        .join(meter_a, meter_a.id == a.meter_id)
        .join(meter_b, meter_b.id == b.meter_id)
        .where(
            a.loop_id == loop_id,
            a.status.in_(ENGAGED_STATUSES),
            b.status.in_(ENGAGED_STATUSES),
        )
    )
    return 0.0 if distance_m is None else distance_m / 1000
