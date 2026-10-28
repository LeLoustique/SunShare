"""Ce que le connecteur Enedis doit fournir, en termes métier (pas de format d'échange inventé).

Enedis identifie les participants par leur PRM. Un même PRM peut avoir une courbe de soutirage et
une courbe d'injection : le sens fait partie de l'identifiant. Pas de 15 min (app/timesteps.py).
"""

from dataclasses import dataclass
from datetime import datetime
from decimal import Decimal
from typing import Protocol

from app.config import settings
from app.models import MeterDirection


@dataclass(frozen=True)
class MeterReading:
    """Puissance moyenne d'un compteur sur un pas (kW), telle que relevée par Enedis."""

    prm: str
    direction: MeterDirection
    ts: datetime  # début du pas, avec fuseau
    kw_avg: Decimal


@dataclass(frozen=True)
class AllocatedEnergy:
    """Énergie affectée par Enedis d'un producteur à un consommateur sur un pas (kWh).

    Si l'API ne publie que des totaux par consommateur et par producteur, le client réel reconstitue
    les paires avec `app.allocation.pairs_from_totals`.
    """

    ts: datetime
    producer_prm: str
    consumer_prm: str
    kwh: Decimal


class EnedisUnavailable(Exception):
    """Enedis injoignable ou en erreur ; l'import peut être retenté."""


class EnedisNotConfigured(Exception):
    """Aucun accès Enedis configuré (pas encore de convention PMO)."""


class EnedisOperationClient(Protocol):
    """Données d'une opération d'ACC sur [start, end[ (instants UTC)."""

    def load_curves(self, operation_id: str, start: datetime, end: datetime) -> list[MeterReading]:
        ...

    def allocated_energies(
        self, operation_id: str, start: datetime, end: datetime
    ) -> list[AllocatedEnergy]:
        ...


def get_enedis_client() -> EnedisOperationClient:
    """Client de l'API PMO d'Enedis selon la configuration ; aucun n'existe encore."""
    raise EnedisNotConfigured(
        "Accès Enedis non configuré : le client de l'API PMO sera écrit avec la documentation "
        f"fournie par Enedis à la signature de la convention (mode actuel : {settings.enedis_mode})"
    )
