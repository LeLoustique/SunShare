"""Moteur de répartition : fonctions pures, sans base de données."""

import random
from decimal import Decimal as D

import pytest

from app.allocation import (
    KWH_PRECISION,
    dynamic_default,
    received_by_consumer,
    sold_by_producer,
    static,
)


def test_production_superieure_chacun_recoit_toute_sa_consommation():
    pairs = dynamic_default({"p": D(3)}, {"a": D(1), "b": D("0.5")})

    assert received_by_consumer(pairs) == {"a": D(1), "b": D("0.5")}
    # Le surplus (1,5 kWh) part sur le réseau
    assert sold_by_producer(pairs) == {"p": D("1.5")}


def test_production_insuffisante_partage_au_prorata():
    pairs = dynamic_default({"p": D(1)}, {"a": D(1), "b": D(3)})

    assert pairs == {("p", "a"): D("0.25"), ("p", "b"): D("0.75")}


def test_plusieurs_producteurs_au_prorata_de_leur_production():
    pairs = dynamic_default({"p1": D(3), "p2": D(1)}, {"a": D(2)})

    # Production 4 kWh > consommation 2 kWh : a reçoit 2 kWh, fournis à 75 % / 25 %
    assert pairs == {("p1", "a"): D("1.5"), ("p2", "a"): D("0.5")}
    assert sold_by_producer(pairs) == {"p1": D("1.5"), "p2": D("0.5")}


def test_exemple_avec_arrondi_vers_le_bas():
    pairs = dynamic_default({"p": D(1)}, {"a": D(1), "b": D(1), "c": D(1)})

    # 1/3 kWh chacun, arrondi vers le bas : le reliquat de 0,000001 kWh part sur le réseau
    assert set(pairs.values()) == {D("0.333333")}
    assert sum(pairs.values()) == D("0.999999")


@pytest.mark.parametrize(
    ("production", "consumption"),
    [
        ({"p": D(0)}, {"a": D(1)}),  # nuit
        ({"p": D(2)}, {"a": D(0)}),  # personne ne consomme
        ({}, {"a": D(1)}),
        ({"p": D(2)}, {}),
    ],
)
def test_rien_a_repartir(production, consumption):
    assert dynamic_default(production, consumption) == {}


def test_les_valeurs_nulles_ne_creent_pas_de_paire():
    pairs = dynamic_default({"p": D(2), "eteint": D(0)}, {"a": D(1), "absent": D(0)})
    assert pairs == {("p", "a"): D(1)}


def test_valeur_negative_refusee():
    with pytest.raises(ValueError, match="production"):
        dynamic_default({"p": D(-1)}, {"a": D(1)})
    with pytest.raises(ValueError, match="consommation"):
        dynamic_default({"p": D(1)}, {"a": D(-1)})


def test_invariants_sur_des_pas_aleatoires():
    """Jamais plus que la consommation de chacun, la production de chacun, ni le total disponible."""
    rng = random.Random(42)
    for _ in range(500):
        production = {f"p{j}": D(rng.randint(0, 5000)) / 1000 for j in range(rng.randint(1, 4))}
        consumption = {f"c{i}": D(rng.randint(0, 3000)) / 1000 for i in range(rng.randint(1, 12))}

        pairs = dynamic_default(production, consumption)
        received = received_by_consumer(pairs)
        sold = sold_by_producer(pairs)
        total = sum(pairs.values(), D(0))
        available = min(sum(production.values()), sum(consumption.values()))

        assert all(kwh > 0 and kwh == kwh.quantize(KWH_PRECISION) for kwh in pairs.values())
        assert all(received[c] <= consumption[c] for c in received)
        assert all(sold[p] <= production[p] for p in sold)
        assert total <= available
        # L'arrondi ne perd qu'au plus 1e-6 kWh par paire
        assert available - total <= KWH_PRECISION * max(len(pairs), 1)


def test_cle_statique_plafonnee_a_la_consommation():
    production = {"p": D(4)}
    consumption = {"a": D(1), "b": D(3)}
    pairs = static(production, consumption, {"a": D("0.5"), "b": D("0.5")})

    # a : min(1, 0,5 × 4) = 1 ; b : min(3, 0,5 × 4) = 2 ; 1 kWh part sur le réseau
    assert received_by_consumer(pairs) == {"a": D(1), "b": D(2)}


def test_cle_statique_consommateur_sans_cle():
    pairs = static({"p": D(4)}, {"a": D(1), "b": D(1)}, {"a": D("0.5")})
    assert received_by_consumer(pairs) == {"a": D(1)}


def test_cle_statique_invalide():
    with pytest.raises(ValueError, match="dépasse 1"):
        static({"p": D(1)}, {"a": D(1)}, {"a": D("0.6"), "b": D("0.5")})
    with pytest.raises(ValueError, match="clé"):
        static({"p": D(1)}, {"a": D(1)}, {"a": D("-0.1")})


def test_cle_statique_sans_production():
    assert static({"p": D(0)}, {"a": D(1)}, {"a": D(1)}) == {}
