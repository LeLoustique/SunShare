"""Courbes de charge simulées, en attendant les données Enedis (cahier des charges : REP-02).

Déterministes : un même compteur, un même jour, donne toujours la même courbe. La météo du jour est
commune à tous les compteurs (des voisins voient le même ciel), le foyer est propre à chaque compteur.
Ordres de grandeur obtenus : ~4 000 kWh/an pour un foyer moyen, ~900 kWh/an par kWc installé à Amiens.
"""

import math
import random
import uuid
from datetime import date, datetime
from decimal import Decimal

from app.timesteps import PARIS, STEP, day_steps

KW_PRECISION = Decimal("0.001")

# Rendement global d'une installation (onduleur, câbles, température, salissures)
PERFORMANCE_RATIO = 0.85


def _sun_height(moment: datetime, latitude: float, longitude: float) -> float:
    """Sinus de la hauteur du soleil (négatif la nuit), formule approchée suffisante ici."""
    day_of_year = moment.timetuple().tm_yday
    declination = math.radians(23.44) * math.sin(2 * math.pi * (284 + day_of_year) / 365)
    solar_hours = moment.hour + moment.minute / 60 + longitude / 15
    hour_angle = math.radians(15 * (solar_hours - 12))
    lat = math.radians(latitude)
    return math.sin(lat) * math.sin(declination) + math.cos(lat) * math.cos(declination) * math.cos(
        hour_angle
    )


def _weather(day: date) -> float:
    """Ensoleillement du jour (0,15 couvert → 1 grand beau), commun à tous les compteurs."""
    rng = random.Random(f"meteo-{day.isoformat()}")
    return 0.15 + 0.85 * rng.random() ** 0.7


def production_curve(
    meter_id: uuid.UUID, day: date, peak_kw: Decimal, latitude: float, longitude: float
) -> list[tuple[datetime, Decimal]]:
    rng = random.Random(f"production-{meter_id}-{day.isoformat()}")
    weather = _weather(day)
    curve = []
    for ts in day_steps(day):
        sun = max(0.0, _sun_height(ts + STEP / 2, latitude, longitude))
        # Passages nuageux : variation d'un pas à l'autre, plus forte par temps couvert
        clouds = 1 - (1 - weather) * rng.random()
        kw = float(peak_kw) * PERFORMANCE_RATIO * sun * weather * clouds
        curve.append((ts, Decimal(str(round(kw, 3))).quantize(KW_PRECISION)))
    return curve


def _bump(hour: float, center: float, width: float) -> float:
    return math.exp(-((hour - center) ** 2) / (2 * width**2))


def consumption_curve(meter_id: uuid.UUID, day: date) -> list[tuple[datetime, Decimal]]:
    household = random.Random(f"foyer-{meter_id}")
    size = household.uniform(0.6, 1.5)  # du studio à la grande maison
    base = household.uniform(0.15, 0.3)  # réfrigérateur, box, veilles…
    rng = random.Random(f"consommation-{meter_id}-{day.isoformat()}")
    # Chauffage et éclairage : jusqu'à +70 % mi-janvier
    season = 1 + 0.7 * math.cos(2 * math.pi * (day.timetuple().tm_yday - 15) / 365)

    curve = []
    for ts in day_steps(day):
        local = (ts + STEP / 2).astimezone(PARIS)
        hour = local.hour + local.minute / 60
        activity = (
            0.6 * _bump(hour, 7.5, 1.0)
            + 0.35 * _bump(hour, 12.5, 1.2)
            + 1.1 * _bump(hour, 19.5, 1.6)
        )
        kw = (base + activity * season) * size * rng.uniform(0.8, 1.2)
        curve.append((ts, Decimal(str(round(kw, 3))).quantize(KW_PRECISION)))
    return curve
