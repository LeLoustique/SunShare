"""Donne le rôle administrateur (PMO) à un compte existant ; ce rôle ne se choisit pas à l'inscription.

Usage, depuis backend/ avec le venv activé : python scripts/promote_admin.py remi@exemple.fr
"""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from sqlalchemy import select

from app.db import SessionLocal
from app.models import User, UserRole

if len(sys.argv) != 2:
    sys.exit(__doc__)

email = sys.argv[1].lower()
with SessionLocal() as db:
    user = db.scalar(select(User).where(User.email == email))
    if user is None:
        sys.exit(f"Aucun compte avec l'e-mail {email}")
    user.role = UserRole.admin
    db.commit()
print(f"{email} est maintenant administrateur")
