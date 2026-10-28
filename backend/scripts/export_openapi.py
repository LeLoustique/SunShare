"""Écrit le schéma OpenAPI de l'API dans openapi.json (à la racine du dépôt).

Usage, depuis backend/ avec le venv activé : python scripts/export_openapi.py
Pas besoin que l'API tourne : le schéma est calculé à partir du code.
"""

import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from app.main import app

OUTPUT = Path(__file__).resolve().parents[2] / "openapi.json"

schema = json.dumps(app.openapi(), indent=2, ensure_ascii=False) + "\n"
OUTPUT.write_text(schema, encoding="utf-8", newline="\n")  # LF, identique sous Windows et en CI
print(f"Schéma écrit dans {OUTPUT}")
