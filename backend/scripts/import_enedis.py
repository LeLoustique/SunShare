"""Importe les données Enedis d'un mois pour les boucles ayant un identifiant d'opération.

Usage, depuis backend/ avec le venv activé :
    python scripts/import_enedis.py                 # mois précédent (publication en M+1)
    python scripts/import_enedis.py --mois 2026-10
"""

import argparse
import sys
from datetime import date, timedelta
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from sqlalchemy import select

from app.db import SessionLocal
from app.enedis.client import EnedisNotConfigured, get_enedis_client
from app.enedis.importer import import_month
from app.models import Loop

previous_month = (date.today().replace(day=1) - timedelta(days=1)).strftime("%Y-%m")
parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
parser.add_argument("--mois", default=previous_month, help="mois à importer (AAAA-MM)")
args = parser.parse_args()

try:
    client = get_enedis_client()
except EnedisNotConfigured as error:
    sys.exit(str(error))

with SessionLocal() as db:
    loops = db.scalars(select(Loop).where(Loop.enedis_operation_id.is_not(None))).all()
    if not loops:
        print("Aucune boucle n'a d'identifiant d'opération Enedis")
    for loop in loops:
        report = import_month(db, loop, client, args.mois)
        print(
            f"{loop.name} ({args.mois}) : {report.curve_points} points de courbe, "
            f"{report.allocations} énergies affectées, {len(report.anomalies)} anomalie(s)"
        )
        for anomaly in report.anomalies:
            print(f"  - {anomaly}")
