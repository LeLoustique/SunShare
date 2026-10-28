"""Facturation mensuelle (TAR-02, cahier des charges §8.3), sur les seules énergies Enedis (REP-03).

Pour chaque boucle et chaque mois : une facture par consommateur (kWh reçus × tarif) et un relevé
de reversement par producteur (kWh vendus × tarif, moins la commission). Les relevés naissent en
brouillon, recalculables ; une fois émis, ils reçoivent un numéro chronologique sans trou et ne
changent plus. Chaque montant est arrondi une seule fois au centime, sur le total du mois, et
brut = commission + net sur chaque relevé.
"""

import uuid
from dataclasses import dataclass, field
from datetime import datetime
from decimal import Decimal

from sqlalchemy import delete, func, select
from sqlalchemy.dialects.postgresql import insert as pg_insert
from sqlalchemy.orm import Session

from app.config import settings
from app.models import (
    Allocation,
    DataSource,
    Loop,
    LoopMember,
    MembershipStatus,
    Meter,
    MeterDirection,
    Statement,
    StatementCounter,
    StatementStatus,
)
from app.money import to_cents
from app.statement_pdf import document_for, render
from app.timesteps import PARIS, bounds, month_days

NO_AMOUNT = Decimal("0.00")


class BillingError(Exception):
    """Facturation impossible en l'état (rien à émettre…)."""


@dataclass(frozen=True)
class Amounts:
    gross: Decimal
    network_fee: Decimal
    commission: Decimal
    net: Decimal


def consumer_amounts(kwh: Decimal, price: Decimal, network_fee: Decimal) -> Amounts:
    """Facture : énergie locale au tarif de la boucle, plus le TURPE éventuel (0 par défaut)."""
    fee = to_cents(kwh * network_fee)
    total = to_cents(kwh * price) + fee
    return Amounts(gross=total, network_fee=fee, commission=NO_AMOUNT, net=total)


def producer_amounts(kwh: Decimal, price: Decimal, commission: Decimal) -> Amounts:
    """Reversement : énergie vendue au tarif, moins la commission de l'app."""
    gross, kept = to_cents(kwh * price), to_cents(kwh * commission)
    return Amounts(gross=gross, network_fee=NO_AMOUNT, commission=kept, net=gross - kept)


@dataclass
class LoopBilling:
    loop_id: uuid.UUID
    loop_name: str
    statements: int = 0
    # Payé par les consommateurs, reversé aux producteurs, conservé par l'app
    consumers_eur: Decimal = NO_AMOUNT
    payouts_eur: Decimal = NO_AMOUNT
    commission_eur: Decimal = NO_AMOUNT


@dataclass
class BillingRun:
    period: str
    loops: list[LoopBilling] = field(default_factory=list)
    skipped: list[str] = field(default_factory=list)


def _energy_by_user(db: Session, loop: Loop, side, start: datetime, end: datetime):
    """kWh Enedis du mois par utilisateur, côté consommateur ou producteur."""
    if side is MeterDirection.consumption:
        meter_column = Allocation.consumer_meter_id
    else:
        meter_column = Allocation.producer_meter_id
    return db.execute(
        select(Meter.user_id, func.sum(Allocation.kwh))
        .join(Meter, Meter.id == meter_column)
        .where(
            Allocation.loop_id == loop.id,
            Allocation.source == DataSource.enedis,
            Allocation.ts >= start,
            Allocation.ts < end,
        )
        .group_by(Meter.user_id)
    ).all()


def run(db: Session, period: str) -> BillingRun:
    """Calcule (ou recalcule) les brouillons du mois pour toutes les boucles en activité."""
    first, last = month_days(period)
    start, end = bounds(first, last)
    report = BillingRun(period=period)

    loops = db.scalars(
        select(Loop)
        .join(LoopMember, LoopMember.loop_id == Loop.id)
        .where(LoopMember.status.in_((MembershipStatus.active, MembershipStatus.left)))
        .distinct()
        .order_by(Loop.name)
    ).all()
    for loop in loops:
        issued = db.scalar(
            select(func.count())
            .select_from(Statement)
            .where(
                Statement.loop_id == loop.id,
                Statement.month == first,
                Statement.status == StatementStatus.issued,
            )
        )
        if issued:
            report.skipped.append(f"{loop.name} : relevés déjà émis pour ce mois")
            continue

        consumers = _energy_by_user(db, loop, MeterDirection.consumption, start, end)
        producers = _energy_by_user(db, loop, MeterDirection.production, start, end)
        if not consumers and not producers:
            report.skipped.append(f"{loop.name} : aucune énergie publiée par Enedis pour ce mois")
            continue

        db.execute(
            delete(Statement).where(
                Statement.loop_id == loop.id,
                Statement.month == first,
                Statement.status == StatementStatus.draft,
            )
        )
        summary = LoopBilling(loop_id=loop.id, loop_name=loop.name)
        network_fee = settings.network_fee_eur_kwh
        lines = [
            (
                user_id,
                MeterDirection.consumption,
                kwh,
                consumer_amounts(kwh, loop.price_eur_kwh, network_fee),
            )
            for user_id, kwh in consumers
        ] + [
            (
                user_id,
                MeterDirection.production,
                kwh,
                producer_amounts(kwh, loop.price_eur_kwh, loop.commission_eur_kwh),
            )
            for user_id, kwh in producers
        ]
        for user_id, direction, kwh, amounts in lines:
            db.add(Statement(
                loop_id=loop.id,
                user_id=user_id,
                month=first,
                direction=direction,
                kwh=kwh,
                price_eur_kwh=loop.price_eur_kwh,
                commission_eur_kwh=loop.commission_eur_kwh,
                network_fee_eur_kwh=network_fee,
                gross_eur=amounts.gross,
                network_fee_eur=amounts.network_fee,
                commission_eur=amounts.commission,
                net_eur=amounts.net,
            ))
            summary.statements += 1
            if direction is MeterDirection.consumption:
                summary.consumers_eur += amounts.gross
            else:
                summary.payouts_eur += amounts.net
                summary.commission_eur += amounts.commission
        report.loops.append(summary)
    db.commit()
    return report


def issue(db: Session, period: str) -> list[Statement]:
    """Émet les brouillons du mois : numéros chronologiques sans trou, relevés figés."""
    first, _ = month_days(period)
    now = datetime.now(PARIS)

    # Le compteur de l'année est verrouillé AVANT de lire les brouillons, jusqu'à la fin de la
    # transaction : une émission simultanée attend, puis ne trouve plus rien à émettre (sans ce
    # verrou, elle renuméroterait les mêmes relevés et laisserait des trous)
    db.execute(
        pg_insert(StatementCounter)
        .values(year=now.year, last_number=0)
        .on_conflict_do_nothing(index_elements=[StatementCounter.year])
    )
    counter = db.scalar(
        select(StatementCounter).where(StatementCounter.year == now.year).with_for_update()
    )
    drafts = db.scalars(
        select(Statement)
        .join(Loop, Loop.id == Statement.loop_id)
        .where(Statement.month == first, Statement.status == StatementStatus.draft)
        .order_by(Loop.name, Statement.direction, Statement.created_at, Statement.id)
    ).all()
    if not drafts:
        db.rollback()
        raise BillingError("Aucun relevé en brouillon à émettre pour ce mois")

    for statement in drafts:
        counter.last_number += 1
        statement.number = f"SS-{now.year}-{counter.last_number:06d}"
        statement.status = StatementStatus.issued
        statement.issued_at = now
        # PDF archivé dans la même transaction : pas de relevé émis sans son document
        statement.pdf = render(document_for(db, statement))
    db.commit()
    return drafts
