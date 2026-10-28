"""Tableau de bord d'un utilisateur (DASH-01, DASH-02).

Uniquement ses propres compteurs : les courbes révèlent la présence au domicile. Les énergies
locales viennent des répartitions Enedis quand il y en a sur la période, sinon de la simulation
(estimation). Les montants sont calculés en Decimal et arrondis une seule fois, sur le total.
"""

import uuid
from collections import defaultdict
from datetime import date, datetime, timedelta
from decimal import Decimal

from sqlalchemy import or_, select
from sqlalchemy.orm import Session

from app.config import settings
from app.models import Allocation, DataSource, LoadCurve, Loop, Meter, MeterDirection, User
from app.money import to_cents
from app.schemas import ConsumerSummary, CurveStep, Dashboard, DayCurves, ProducerSummary
from app.timesteps import HOURS_PER_STEP, PARIS, bounds, day_steps, month_days

ZERO = Decimal(0)


def yesterday() -> date:
    """Les données arrivent en J+1 : la veille est le jour le plus récent consultable."""
    return datetime.now(PARIS).date() - timedelta(days=1)


def current_month() -> str:
    return datetime.now(PARIS).strftime("%Y-%m")


def _number(value: Decimal) -> float:
    return float(value.quantize(Decimal("0.001")))


def _rate(part: Decimal, total: Decimal) -> float | None:
    return None if total <= 0 else round(float(part / total), 3)


def _my_meters(db: Session, user: User) -> dict[uuid.UUID, MeterDirection]:
    return dict(db.execute(select(Meter.id, Meter.direction).where(Meter.user_id == user.id)).all())


def _curves(db: Session, meters, start: datetime, end: datetime):
    return db.execute(
        select(LoadCurve.meter_id, LoadCurve.ts, LoadCurve.kw_avg, LoadCurve.source).where(
            LoadCurve.meter_id.in_(meters), LoadCurve.ts >= start, LoadCurve.ts < end
        )
    ).all()


def _allocations(db: Session, meters, start: datetime, end: datetime):
    """Répartitions impliquant les compteurs de l'utilisateur ; celles d'Enedis priment."""
    rows = db.execute(
        select(
            Allocation.ts,
            Allocation.producer_meter_id,
            Allocation.consumer_meter_id,
            Allocation.loop_id,
            Allocation.kwh,
            Allocation.source,
        ).where(
            or_(Allocation.consumer_meter_id.in_(meters), Allocation.producer_meter_id.in_(meters)),
            Allocation.ts >= start,
            Allocation.ts < end,
        )
    ).all()
    source = _source({row.source for row in rows})
    return source, [row for row in rows if row.source is source]


def _source(sources: set[DataSource]) -> DataSource | None:
    if DataSource.enedis in sources:
        return DataSource.enedis
    return DataSource.simulated if sources else None


def day_curves(db: Session, user: User, day: date) -> DayCurves:
    meters = _my_meters(db, user)
    steps = day_steps(day)
    start, end = bounds(day, day)

    power: dict[MeterDirection, dict[datetime, Decimal]] = defaultdict(dict)
    curve_sources = set()
    for meter_id, ts, kw, source in _curves(db, meters, start, end):
        direction = meters[meter_id]
        power[direction][ts] = power[direction].get(ts, ZERO) + kw
        curve_sources.add(source)

    source, rows = _allocations(db, meters, start, end)
    received: dict[datetime, Decimal] = defaultdict(Decimal)
    sold: dict[datetime, Decimal] = defaultdict(Decimal)
    for row in rows:
        if row.consumer_meter_id in meters:
            received[row.ts] += row.kwh
        if row.producer_meter_id in meters:
            sold[row.ts] += row.kwh

    def kw(direction: MeterDirection, ts: datetime) -> float | None:
        value = power[direction].get(ts)
        return None if value is None else _number(value)

    return DayCurves(
        day=day,
        data_source=source or _source(curve_sources),
        steps=[
            CurveStep(
                ts=ts,
                consumption_kw=kw(MeterDirection.consumption, ts),
                production_kw=kw(MeterDirection.production, ts),
                received_kwh=_number(received[ts]),
                sold_kwh=_number(sold[ts]),
            )
            for ts in steps
        ],
    )


def month_dashboard(db: Session, user: User, period: str) -> Dashboard:
    start, end = bounds(*month_days(period))
    meters = _my_meters(db, user)

    energy = {MeterDirection.consumption: ZERO, MeterDirection.production: ZERO}
    curve_sources, last_ts = set(), None
    for meter_id, ts, kw, source in _curves(db, meters, start, end):
        energy[meters[meter_id]] += kw * HOURS_PER_STEP
        curve_sources.add(source)
        last_ts = ts if last_ts is None else max(last_ts, ts)

    source, rows = _allocations(db, meters, start, end)
    received_by_loop: dict[uuid.UUID, Decimal] = defaultdict(Decimal)
    sold_by_loop: dict[uuid.UUID, Decimal] = defaultdict(Decimal)
    local_total = ZERO  # chaque affectation comptée une fois, même entre deux compteurs à soi
    for row in rows:
        if row.consumer_meter_id in meters:
            received_by_loop[row.loop_id] += row.kwh
        if row.producer_meter_id in meters:
            sold_by_loop[row.loop_id] += row.kwh
        local_total += row.kwh

    loops = {
        loop.id: loop
        for loop in db.scalars(select(Loop).where(Loop.id.in_({r.loop_id for r in rows})))
    }
    received = sum(received_by_loop.values(), ZERO)
    sold = sum(sold_by_loop.values(), ZERO)
    directions = set(meters.values())

    consumer = None
    if MeterDirection.consumption in directions:
        consumption = energy[MeterDirection.consumption]
        consumer = ConsumerSummary(
            consumption_kwh=_number(consumption),
            local_kwh=_number(received),
            self_consumption_rate=_rate(received, consumption),
            amount_eur=to_cents(
                sum((kwh * loops[i].price_eur_kwh for i, kwh in received_by_loop.items()), ZERO)
            ),
        )

    producer = None
    if MeterDirection.production in directions:
        production = energy[MeterDirection.production]
        producer = ProducerSummary(
            production_kwh=_number(production),
            sold_kwh=_number(sold),
            local_share=_rate(sold, production),
            commission_eur=to_cents(
                sum((kwh * loops[i].commission_eur_kwh for i, kwh in sold_by_loop.items()), ZERO)
            ),
            net_eur=to_cents(
                sum(
                    (
                        kwh * (loops[i].price_eur_kwh - loops[i].commission_eur_kwh)
                        for i, kwh in sold_by_loop.items()
                    ),
                    ZERO,
                )
            ),
        )

    return Dashboard(
        period=period,
        data_source=source or _source(curve_sources),
        data_complete_until=None if last_ts is None else last_ts.astimezone(PARIS).date(),
        consumer=consumer,
        producer=producer,
        co2_avoided_kg=round(float(local_total * settings.co2_kg_per_kwh), 1),
        co2_kg_per_kwh=float(settings.co2_kg_per_kwh),
    )
