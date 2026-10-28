"""Moteur de répartition de l'énergie produite entre les membres d'une boucle (cahier des charges §8.2).

Fonctions pures, sur un pas de 30 min, en kWh et en Decimal. Elles servent à la simulation interne
(REP-02) : la facturation repose uniquement sur les énergies publiées par Enedis (REP-03).

Clé dynamique par défaut, au prorata des consommations, avec P la production totale et C_i la
consommation du consommateur i :

    E_i = C_i × min(1, P / Σ C_k)      énergie reçue par le consommateur i
    V_j = P_j / P × Σ E_i              énergie vendue localement par le producteur j

Chaque paire (producteur j, consommateur i) reçoit e_ij = E_i × P_j / P. L'arrondi se fait vers le
bas, à 6 décimales : l'énergie affectée ne dépasse jamais ni la consommation ni la production, et
le reliquat infime part sur le réseau comme le surplus.
"""

from collections.abc import Hashable, Mapping
from decimal import ROUND_DOWN, Decimal

KWH_PRECISION = Decimal("0.000001")
ZERO = Decimal(0)

type Pairs[K: Hashable] = dict[tuple[K, K], Decimal]


def _check(values: Mapping[Hashable, Decimal], name: str) -> None:
    for key, value in values.items():
        if value < 0:
            raise ValueError(f"{name} négative pour {key!r} : {value}")


def _split(production: Mapping[Hashable, Decimal], received: Mapping[Hashable, Decimal]) -> Pairs:
    """Répartit l'énergie reçue par chaque consommateur entre producteurs, au prorata de P_j / P."""
    total_production = sum(production.values(), ZERO)
    pairs = {}
    for consumer, energy in received.items():
        if energy <= 0:
            continue
        for producer, produced in production.items():
            if produced <= 0:
                continue
            kwh = (energy * produced / total_production).quantize(KWH_PRECISION, ROUND_DOWN)
            if kwh > 0:
                pairs[(producer, consumer)] = kwh
    return pairs


def dynamic_default(
    production: Mapping[Hashable, Decimal], consumption: Mapping[Hashable, Decimal]
) -> Pairs:
    """Clé dynamique par défaut : la production est partagée au prorata des consommations."""
    _check(production, "production")
    _check(consumption, "consommation")
    total_production = sum(production.values(), ZERO)
    total_consumption = sum(consumption.values(), ZERO)
    if total_production <= 0 or total_consumption <= 0:
        return {}

    ratio = min(Decimal(1), total_production / total_consumption)
    return _split(production, {consumer: c * ratio for consumer, c in consumption.items()})


def static(
    production: Mapping[Hashable, Decimal],
    consumption: Mapping[Hashable, Decimal],
    keys: Mapping[Hashable, Decimal],
) -> Pairs:
    """Clé statique : chaque consommateur reçoit une part fixe k_i de la production, plafonnée à sa
    consommation (E_i = min(C_i, k_i × P)). La part non consommée n'est pas redistribuée.
    """
    _check(production, "production")
    _check(consumption, "consommation")
    _check(keys, "clé")
    if sum(keys.values(), ZERO) > 1:
        raise ValueError("La somme des clés statiques dépasse 1")
    total_production = sum(production.values(), ZERO)
    if total_production <= 0:
        return {}

    received = {
        consumer: min(c, keys.get(consumer, ZERO) * total_production)
        for consumer, c in consumption.items()
    }
    return _split(production, received)


def received_by_consumer(pairs: Pairs) -> dict[Hashable, Decimal]:
    """E_i : énergie locale reçue par chaque consommateur."""
    totals: dict[Hashable, Decimal] = {}
    for (_, consumer), kwh in pairs.items():
        totals[consumer] = totals.get(consumer, ZERO) + kwh
    return totals


def sold_by_producer(pairs: Pairs) -> dict[Hashable, Decimal]:
    """V_j : énergie vendue localement par chaque producteur."""
    totals: dict[Hashable, Decimal] = {}
    for (producer, _), kwh in pairs.items():
        totals[producer] = totals.get(producer, ZERO) + kwh
    return totals
