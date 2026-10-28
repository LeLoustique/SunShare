"""Découpage du temps : pas de mesure d'Enedis et journées françaises.

Enedis relève les courbes de charge et répartit la production au pas de 15 min pour
l'autoconsommation collective (présentation Enedis ACC, novembre 2025). Tout le reste du code
s'appuie sur ces définitions : un changement de pas ne touche que ce fichier.
"""

from datetime import UTC, date, datetime, time, timedelta
from decimal import Decimal
from zoneinfo import ZoneInfo

PARIS = ZoneInfo("Europe/Paris")
STEP = timedelta(minutes=15)
# Énergie d'un pas : kWh = kW moyen × durée du pas en heures (0,25 h)
HOURS_PER_STEP = Decimal(int(STEP.total_seconds())) / 3600


def day_steps(day: date) -> list[datetime]:
    """Débuts des pas d'une journée française, en UTC.

    96 pas, ou 92 / 100 les jours de passage à l'heure d'été / d'hiver.
    """
    start = datetime.combine(day, time(), PARIS).astimezone(UTC)
    end = datetime.combine(day + timedelta(days=1), time(), PARIS).astimezone(UTC)
    steps = []
    while start < end:
        steps.append(start)
        start += STEP
    return steps


def bounds(first: date, last: date) -> tuple[datetime, datetime]:
    """Instants UTC [début, fin[ couvrant les journées françaises de `first` à `last` incluses."""
    return day_steps(first)[0], day_steps(last)[-1] + STEP


def month_days(period: str) -> tuple[date, date]:
    """Premier et dernier jour d'un mois « AAAA-MM »."""
    first = date.fromisoformat(f"{period}-01")
    following = (first.replace(day=28) + timedelta(days=4)).replace(day=1)
    return first, following - timedelta(days=1)
