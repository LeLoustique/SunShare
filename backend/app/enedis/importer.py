"""Import mensuel des données Enedis d'une opération : Enedis les publie en M+1 pour le mois M.

Courbes et énergies affectées sont enregistrées avec la source `enedis` : elles priment sur la
simulation et seules elles servent à facturer. Toutes les données sont récupérées avant la
moindre écriture, et un import rejoué remplace le précédent sans doublon. Ce qui ne peut pas être
rattaché à la boucle n'est pas importé mais signalé (anomalies de données).
"""

import time
import uuid
from collections.abc import Callable
from dataclasses import dataclass, field
from datetime import datetime
from typing import TypeVar

from sqlalchemy import delete, insert, select
from sqlalchemy.dialects.postgresql import insert as pg_insert
from sqlalchemy.orm import Session

from app.enedis.client import EnedisOperationClient, EnedisUnavailable
from app.models import (
    Allocation,
    DataSource,
    LoadCurve,
    Loop,
    LoopMember,
    MembershipStatus,
    Meter,
    MeterDirection,
)
from app.timesteps import STEP, bounds, month_days

T = TypeVar("T")

ATTEMPTS = 3
RETRY_DELAY_S = 60.0


@dataclass
class ImportReport:
    loop_name: str
    period: str
    curve_points: int = 0
    allocations: int = 0
    anomalies: list[str] = field(default_factory=list)


def _with_retries(
    call: Callable[[], T], attempts: int, sleep: Callable[[float], None], delay: float
) -> T:
    """Nouvelle tentative en cas d'erreur Enedis (ENE-03), avec une attente croissante."""
    for attempt in range(1, attempts + 1):
        try:
            return call()
        except EnedisUnavailable:
            if attempt == attempts:
                raise
            sleep(delay * attempt)
    raise AssertionError("inatteignable")


def _step_problem(ts: datetime, start: datetime, end: datetime) -> str | None:
    if ts.tzinfo is None:
        return f"horodatage sans fuseau ({ts.isoformat()})"
    if not start <= ts < end:
        return f"hors de la période ({ts.isoformat()})"
    if (ts - start) % STEP:
        return f"pas mal aligné ({ts.isoformat()})"
    return None


def _members(db: Session, loop: Loop) -> dict[tuple[str, MeterDirection], uuid.UUID]:
    """Compteurs ayant participé à l'opération (actifs ou sortis), par (PRM, sens)."""
    rows = db.execute(
        select(Meter.prm, Meter.direction, Meter.id)
        .join(LoopMember, LoopMember.meter_id == Meter.id)
        .where(
            LoopMember.loop_id == loop.id,
            LoopMember.status.in_((MembershipStatus.active, MembershipStatus.left)),
        )
    ).all()
    return {(prm, direction): meter_id for prm, direction, meter_id in rows}


def import_month(
    db: Session,
    loop: Loop,
    client: EnedisOperationClient,
    period: str,
    *,
    attempts: int = ATTEMPTS,
    sleep: Callable[[float], None] = time.sleep,
    retry_delay: float = RETRY_DELAY_S,
) -> ImportReport:
    if not loop.enedis_operation_id:
        raise ValueError(f"La boucle « {loop.name} » n'a pas d'identifiant d'opération Enedis")
    start, end = bounds(*month_days(period))
    operation = loop.enedis_operation_id

    readings = _with_retries(
        lambda: client.load_curves(operation, start, end), attempts, sleep, retry_delay
    )
    energies = _with_retries(
        lambda: client.allocated_energies(operation, start, end), attempts, sleep, retry_delay
    )

    report = ImportReport(loop_name=loop.name, period=period)
    meters = _members(db, loop)

    curves: dict[tuple[uuid.UUID, datetime], dict] = {}
    for reading in readings:
        label = f"Courbe {reading.prm} ({reading.direction.value})"
        meter_id = meters.get((reading.prm, reading.direction))
        problem = _step_problem(reading.ts, start, end)
        if problem:
            report.anomalies.append(f"{label} : {problem}")
        elif meter_id is None:
            report.anomalies.append(f"{label} : PRM qui n'est pas membre de la boucle")
        elif reading.kw_avg < 0:
            report.anomalies.append(f"{label} : puissance négative à {reading.ts.isoformat()}")
        elif (meter_id, reading.ts) in curves:
            report.anomalies.append(f"{label} : mesure en double à {reading.ts.isoformat()}")
        else:
            curves[(meter_id, reading.ts)] = {
                "meter_id": meter_id,
                "ts": reading.ts,
                "kw_avg": reading.kw_avg,
                "source": DataSource.enedis,
            }

    pairs: dict[tuple[datetime, uuid.UUID, uuid.UUID], dict] = {}
    for energy in energies:
        label = f"Énergie affectée {energy.producer_prm} → {energy.consumer_prm}"
        producer = meters.get((energy.producer_prm, MeterDirection.production))
        consumer = meters.get((energy.consumer_prm, MeterDirection.consumption))
        problem = _step_problem(energy.ts, start, end)
        if problem:
            report.anomalies.append(f"{label} : {problem}")
        elif producer is None or consumer is None:
            report.anomalies.append(f"{label} : PRM qui n'est pas membre de la boucle")
        elif energy.kwh < 0:
            report.anomalies.append(f"{label} : énergie négative à {energy.ts.isoformat()}")
        elif (energy.ts, producer, consumer) in pairs:
            report.anomalies.append(f"{label} : valeur en double à {energy.ts.isoformat()}")
        elif energy.kwh > 0:
            pairs[(energy.ts, producer, consumer)] = {
                "loop_id": loop.id,
                "ts": energy.ts,
                "producer_meter_id": producer,
                "consumer_meter_id": consumer,
                "source": DataSource.enedis,
                "kwh": energy.kwh,
            }

    if curves:
        upsert = pg_insert(LoadCurve).values(list(curves.values()))
        db.execute(
            upsert.on_conflict_do_update(
                index_elements=[LoadCurve.meter_id, LoadCurve.ts],
                set_={"kw_avg": upsert.excluded.kw_avg, "source": upsert.excluded.source},
            )
        )
    db.execute(
        delete(Allocation).where(
            Allocation.loop_id == loop.id,
            Allocation.source == DataSource.enedis,
            Allocation.ts >= start,
            Allocation.ts < end,
        )
    )
    if pairs:
        db.execute(insert(Allocation), list(pairs.values()))
    db.commit()

    report.curve_points, report.allocations = len(curves), len(pairs)
    return report
