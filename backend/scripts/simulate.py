"""Génère les courbes simulées et calcule la répartition, jour par jour (hier par défaut).

Usage, depuis backend/ avec le venv activé :
    python scripts/simulate.py                          # hier
    python scripts/simulate.py --du 2026-10-01 --au 2026-10-27

Seuls les compteurs membres actifs d'une boucle (date d'entrée passée) sont simulés.
"""

import argparse
import sys
from datetime import date, timedelta
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from app.db import SessionLocal
from app.jobs import days, run_day

yesterday = date.today() - timedelta(days=1)
parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
parser.add_argument("--du", type=date.fromisoformat, default=yesterday, help="premier jour (AAAA-MM-JJ)")
parser.add_argument("--au", type=date.fromisoformat, help="dernier jour inclus (par défaut : --du)")
args = parser.parse_args()

with SessionLocal() as db:
    for day in days(args.du, args.au or args.du):
        report = run_day(db, day)
        print(
            f"{day} : {report.curve_points} points de courbe, {report.loops} boucle(s), "
            f"{report.allocations} affectations"
        )
        for name in report.skipped:
            print(f"  ignorée (clé de répartition non prise en charge) : {name}")
