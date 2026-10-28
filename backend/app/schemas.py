import uuid
from datetime import date, datetime
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

from app.models import AllocationMode, LoopStatus, MembershipStatus, MeterDirection, UserRole


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


# Tarifs en €/kWh : chaîne décimale exacte sur le réseau, jamais de flottant pour de l'argent
EurPerKwh = Annotated[
    Decimal,
    Field(ge=0, lt=10, max_digits=6, decimal_places=4),
    PlainSerializer(str, return_type=str, when_used="json"),
    WithJsonSchema({"type": "string", "pattern": r"^[0-9]+(\.[0-9]{1,4})?$", "examples": ["0.18"]}),
]

# Périmètre d'une boucle : 2 km en zone urbaine, jusqu'à 10 ou 20 km sur dérogation
PerimeterKm = Annotated[
    Decimal,
    Field(gt=0, le=20, decimal_places=2),
    PlainSerializer(float, return_type=float, when_used="json"),
    WithJsonSchema({"type": "number", "exclusiveMinimum": 0, "maximum": 20}),
]


class LoopCreate(BaseModel):
    name: str = Field(min_length=1, max_length=100)
    perimeter_km: PerimeterKm = Decimal(2)
    price_eur_kwh: EurPerKwh
    commission_eur_kwh: EurPerKwh
    # Absent : clé dynamique par défaut (valeur par défaut de la base). Pas de défaut enum ici :
    # le générateur dart-dio produit alors un code qui ne compile pas
    allocation_mode: AllocationMode | None = None
    enedis_operation_id: str | None = Field(default=None, max_length=50)

    @model_validator(mode="after")
    def commission_sous_le_tarif(self) -> "LoopCreate":
        if self.commission_eur_kwh >= self.price_eur_kwh:
            raise ValueError("La commission doit être inférieure au tarif")
        return self


class LoopUpdate(BaseModel):
    """Champs absents : inchangés."""

    name: str | None = Field(default=None, min_length=1, max_length=100)
    perimeter_km: PerimeterKm | None = None
    price_eur_kwh: EurPerKwh | None = None
    commission_eur_kwh: EurPerKwh | None = None
    allocation_mode: AllocationMode | None = None
    status: LoopStatus | None = None
    enedis_operation_id: str | None = Field(default=None, max_length=50)


class LoopStats(BaseModel):
    """Chiffres agrégés : jamais d'information individuelle sur les autres membres."""

    member_count: int
    producer_count: int
    consumer_count: int
    total_peak_kw: float
    diameter_km: float


class LoopOut(BaseModel):
    id: uuid.UUID
    name: str
    perimeter_km: PerimeterKm
    price_eur_kwh: EurPerKwh
    status: LoopStatus
    stats: LoopStats


class AdminLoopOut(LoopOut):
    commission_eur_kwh: EurPerKwh
    allocation_mode: AllocationMode
    enedis_operation_id: str | None
    pending_count: int
    created_at: datetime


class AvailableLoop(BaseModel):
    id: uuid.UUID
    name: str
    perimeter_km: PerimeterKm
    price_eur_kwh: EurPerKwh
    member_count: int
    # Compteurs de l'utilisateur qui peuvent rejoindre cette boucle sans dépasser le périmètre
    joinable_meter_ids: list[uuid.UUID]


class JoinRequest(BaseModel):
    meter_id: uuid.UUID


class MembershipOut(BaseModel):
    id: uuid.UUID
    loop_id: uuid.UUID
    loop_name: str
    meter_id: uuid.UUID
    prm: str
    direction: MeterDirection
    status: MembershipStatus
    requested_at: datetime
    joined_at: date | None
    left_at: date | None


class AdminMemberOut(MembershipOut):
    first_name: str
    last_name: str
    email: str
    address: str
    peak_kw: PeakKw | None


class ApproveRequest(BaseModel):
    """Date d'entrée dans l'opération, communiquée à Enedis."""

    joined_at: date
