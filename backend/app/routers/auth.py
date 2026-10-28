from typing import Annotated

import jwt
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy import select
from sqlalchemy.exc import IntegrityError

from app.deps import DbSession, unauthorized
from app.models import User
from app.schemas import RefreshRequest, TokenPair, UserCreate, UserOut
from app.security import (
    create_access_token,
    create_refresh_token,
    decode_token,
    hash_password,
    verify_password,
)

router = APIRouter(prefix="/auth", tags=["auth"])

EMAIL_TAKEN = HTTPException(status.HTTP_409_CONFLICT, "Un compte existe déjà avec cet e-mail")


def _tokens_for(user: User) -> TokenPair:
    return TokenPair(
        access_token=create_access_token(user.id),
        refresh_token=create_refresh_token(user.id),
    )


@router.post("/register", response_model=UserOut, status_code=status.HTTP_201_CREATED)
def register(data: UserCreate, db: DbSession) -> User:
    email = data.email.lower()
    if db.scalar(select(User).where(User.email == email)):
        raise EMAIL_TAKEN

    user = User(
        email=email,
        password_hash=hash_password(data.password),
        first_name=data.first_name,
        last_name=data.last_name,
        role=data.role,
    )
    db.add(user)
    try:
        db.commit()
    except IntegrityError:  # deux inscriptions simultanées avec le même e-mail
        db.rollback()
        raise EMAIL_TAKEN from None
    db.refresh(user)
    return user


@router.post("/login", response_model=TokenPair)
def login(form: Annotated[OAuth2PasswordRequestForm, Depends()], db: DbSession) -> TokenPair:
    """Le champ `username` contient l'e-mail (convention OAuth2)."""
    user = db.scalar(select(User).where(User.email == form.username.lower()))
    if user is None or not verify_password(form.password, user.password_hash):
        raise unauthorized("E-mail ou mot de passe incorrect")
    return _tokens_for(user)


@router.post("/refresh", response_model=TokenPair)
def refresh(data: RefreshRequest, db: DbSession) -> TokenPair:
    try:
        user_id = decode_token(data.refresh_token, "refresh")
    except (jwt.InvalidTokenError, ValueError, KeyError):
        raise unauthorized() from None
    user = db.get(User, user_id)
    if user is None:
        raise unauthorized()
    return _tokens_for(user)
