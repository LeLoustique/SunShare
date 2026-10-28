"""Montants en euros : Decimal de bout en bout, arrondi au centime une seule fois, sur le total."""

from decimal import ROUND_HALF_UP, Decimal

CENT = Decimal("0.01")


def to_cents(amount: Decimal) -> Decimal:
    """Arrondi commercial au centime (0,005 → 0,01), à n'appliquer qu'au montant final."""
    return amount.quantize(CENT, ROUND_HALF_UP)
