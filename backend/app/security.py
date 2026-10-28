import uuid
from datetime import UTC, datetime, timedelta

import jwt
from pwdlib import PasswordHash

from app.config import settings

ALGORITHM = "HS256"
_password_hash = PasswordHash.recommended()  # Argon2


def hash_password(password: str) -> str:
    return _password_hash.hash(password)


def verify_password(password: str, hashed: str) -> bool:
    return _password_hash.verify(password, hashed)


def _create_token(user_id: uuid.UUID, token_type: str, lifetime: timedelta) -> str:
    now = datetime.now(UTC)
    payload = {"sub": str(user_id), "type": token_type, "iat": now, "exp": now + lifetime}
    return jwt.encode(payload, settings.jwt_secret, algorithm=ALGORITHM)


def create_access_token(user_id: uuid.UUID) -> str:
    return _create_token(user_id, "access", timedelta(minutes=settings.access_token_minutes))


def create_refresh_token(user_id: uuid.UUID) -> str:
    return _create_token(user_id, "refresh", timedelta(days=settings.refresh_token_days))


def decode_token(token: str, expected_type: str) -> uuid.UUID:
    """Renvoie l'id utilisateur, ou lève une exception si le jeton est invalide,
    expiré ou n'est pas du type attendu (un jeton de rafraîchissement ne doit
    pas servir de jeton d'accès, et inversement)."""
    payload = jwt.decode(token, settings.jwt_secret, algorithms=[ALGORITHM])
    if payload.get("type") != expected_type:
        raise jwt.InvalidTokenError("type de jeton inattendu")
    return uuid.UUID(payload["sub"])
