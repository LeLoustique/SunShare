from typing import Annotated

import jwt
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session

from app.db import get_db
from app.models import User
from app.security import decode_token

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/v1/auth/login")

DbSession = Annotated[Session, Depends(get_db)]


def unauthorized(detail: str = "Jeton invalide ou expiré") -> HTTPException:
    return HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail=detail,
        headers={"WWW-Authenticate": "Bearer"},
    )


def get_current_user(token: Annotated[str, Depends(oauth2_scheme)], db: DbSession) -> User:
    try:
        user_id = decode_token(token, "access")
    except (jwt.InvalidTokenError, ValueError, KeyError):
        raise unauthorized() from None
    user = db.get(User, user_id)
    if user is None:
        raise unauthorized()
    return user


CurrentUser = Annotated[User, Depends(get_current_user)]
