"""Générateur de courbes simulées : fonctions pures."""

import uuid
from datetime import UTC, date, datetime
from decimal import Decimal

import pytest

from app.simulation import consumption_curve, day_steps, production_curve

METER = uuid.UUID(int=1)
AMIENS = (49.897, 2.290)


@pytest.mark.parametrize(
    ("day", "steps"),
    [(date(2026, 10, 24), 48), (date(2026, 10, 25), 50), (date(2026, 3, 29), 46)],
)
def test_journee_francaise_et_changements_d_heure(day, steps):
    assert len(day_steps(day)) == steps


def test_la_journee_commence_a_minuit_heure_de_paris():
    winter, summer = day_steps(date(2026, 1, 15)), day_steps(date(2026, 7, 15))
    assert winter[0] == datetime(2026, 1, 14, 23, 0, tzinfo=UTC)
    assert summer[0] == datetime(2026, 7, 14, 22, 0, tzinfo=UTC)


def test_production_nulle_la_nuit_et_bornee_par_la_puissance_crete():
    curve = dict(production_curve(METER, date(2026, 6, 21), Decimal(6), *AMIENS))

    assert curve[datetime(2026, 6, 21, 0, 0, tzinfo=UTC)] == 0  # 2 h du matin
    assert max(curve.values()) > 0
    assert max(curve.values()) <= 6


def test_plus_de_production_en_ete_qu_en_hiver():
    def total(day):
        return sum(kw for _, kw in production_curve(METER, day, Decimal(6), *AMIENS))

    june = sum(total(date(2026, 6, d)) for d in range(1, 31))
    december = sum(total(date(2026, 12, d)) for d in range(1, 32))
    assert june > 3 * december


def test_la_meteo_est_commune_au_quartier():
    """Deux installations identiques voisines : la journée nuageuse l'est pour les deux."""
    day = date(2026, 5, 10)
    a = sum(kw for _, kw in production_curve(uuid.UUID(int=1), day, Decimal(3), *AMIENS))
    b = sum(kw for _, kw in production_curve(uuid.UUID(int=2), day, Decimal(3), *AMIENS))
    assert abs(a - b) / max(a, b) < Decimal("0.35")


def test_consommation_positive_et_plus_forte_le_soir():
    curve = consumption_curve(METER, date(2026, 1, 15))
    by_local_hour = {(ts.hour + 1) % 24 + ts.minute / 60: kw for ts, kw in curve}  # UTC+1 en hiver

    assert all(kw > 0 for kw in by_local_hour.values())
    assert by_local_hour[19.5] > by_local_hour[3.5]


def test_courbes_deterministes_avec_trois_decimales():
    day = date(2026, 4, 2)
    assert consumption_curve(METER, day) == consumption_curve(METER, day)
    assert production_curve(METER, day, Decimal(6), *AMIENS) == production_curve(
        METER, day, Decimal(6), *AMIENS
    )
    assert all(kw == kw.quantize(Decimal("0.001")) for _, kw in consumption_curve(METER, day))
