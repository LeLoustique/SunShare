import uuid
from datetime import datetime
from decimal import Decimal
from typing import Annotated

from pydantic import (
    BaseModel,
    ConfigDict,
    EmailStr,
    Field,
    PlainSerializer,
    WithJsonSchema,
    field_validator,
    model_validator,
)

from app.models import MeterDirection, UserRole


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


class HealthOut(BaseModel):
    status: str
    extensions: dict[str, str]


# Point de référence mesure : identifiant du compteur Linky (touche « + » du compteur, ou facture)
Prm = Annotated[str, Field(pattern=r"^[0-9]{14}$", examples=["12345678901234"])]

# Puissance crête de l'installation en kWc : Decimal en base, nombre JSON sur le réseau (ce n'est
# pas un montant, et le client Dart généré gère mieux un nombre qu'un `number | string`)
PeakKw = Annotated[
    Decimal,
    Field(gt=0, le=1000, decimal_places=2),
    PlainSerializer(float, return_type=float, when_used="json"),
    WithJsonSchema({"type": "number", "exclusiveMinimum": 0, "maximum": 1000}),
]


class MeterCreate(BaseModel):
    prm: Prm
    direction: MeterDirection
    # Libellé choisi parmi les suggestions de /addresses : le serveur le géocode lui-même
    address: str = Field(min_length=3, max_length=200)
    peak_kw: PeakKw | None = None

    @model_validator(mode="after")
    def puissance_crete(self) -> "MeterCreate":
        if self.direction is MeterDirection.production and self.peak_kw is None:
            raise ValueError("La puissance crête (kWc) est obligatoire pour un compteur de production")
        if self.direction is MeterDirection.consumption and self.peak_kw is not None:
            raise ValueError("La puissance crête ne concerne que les compteurs de production")
        return self


class MeterOut(BaseModel):
    id: uuid.UUID
    prm: str
    direction: MeterDirection
    address: str
    latitude: float
    longitude: float
    peak_kw: PeakKw | None
    created_at: datetime


class AddressSuggestion(BaseModel):
    label: str
    postcode: str
    city: str
    latitude: float
    longitude: float
