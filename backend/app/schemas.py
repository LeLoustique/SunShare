import uuid
from datetime import datetime

from pydantic import BaseModel, ConfigDict, EmailStr, Field, field_validator

from app.models import UserRole


class UserCreate(BaseModel):
    email: EmailStr
    password: str = Field(min_length=10, max_length=128)
    first_name: str = Field(min_length=1, max_length=100)
    last_name: str = Field(min_length=1, max_length=100)
    role: UserRole

    @field_validator("role")
    @classmethod
    def admin_interdit(cls, role: UserRole) -> UserRole:
        if role is UserRole.admin:
            raise ValueError("Ce rôle ne peut pas être choisi à l'inscription")
        return role


class UserOut(BaseModel):
    """Ce que l'API renvoie : jamais le mot de passe haché."""

    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    email: EmailStr
    first_name: str
    last_name: str
    role: UserRole
    created_at: datetime


class TokenPair(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"


class RefreshRequest(BaseModel):
    refresh_token: str
