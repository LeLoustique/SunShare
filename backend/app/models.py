import enum
import uuid
from datetime import date, datetime
from decimal import Decimal

from geoalchemy2 import Geography
from sqlalchemy import (
    CheckConstraint,
    Date,
    DateTime,
    Enum,
    ForeignKey,
    Index,
    Numeric,
    String,
    UniqueConstraint,
    func,
    text,
)
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column, relationship


class Base(DeclarativeBase):
    pass


class UserRole(str, enum.Enum):
    producer = "producer"
    consumer = "consumer"
    mixed = "mixed"
    admin = "admin"


class MeterDirection(str, enum.Enum):
    consumption = "consumption"
    production = "production"


class LoopStatus(str, enum.Enum):
    open = "open"  # accepte les demandes d'adhésion
    closed = "closed"


class AllocationMode(str, enum.Enum):
    """Clé de répartition transmise à Enedis (cahier des charges §8.2)."""

    static = "static"
    dynamic_default = "dynamic_default"
    dynamic_custom = "dynamic_custom"


class MembershipStatus(str, enum.Enum):
    pending = "pending"  # demande en attente de validation par la PMO
    active = "active"
    rejected = "rejected"
    left = "left"


class DataSource(str, enum.Enum):
    """Origine d'une mesure ou d'une répartition : seules les données Enedis servent à facturer."""

    enedis = "enedis"
    simulated = "simulated"


class User(Base):
    __tablename__ = "users"

    id: Mapped[uuid.UUID] = mapped_column(primary_key=True, server_default=func.gen_random_uuid())
    email: Mapped[str] = mapped_column(String(320), unique=True, index=True)
    password_hash: Mapped[str] = mapped_column(String(255))
    role: Mapped[UserRole] = mapped_column(Enum(UserRole, name="user_role"))
    first_name: Mapped[str] = mapped_column(String(100))
    last_name: Mapped[str] = mapped_column(String(100))
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

    meters: Mapped[list["Meter"]] = relationship(back_populates="user", cascade="all, delete-orphan")


class Meter(Base):
    __tablename__ = "meters"
    # Un même PRM peut exister deux fois : en soutirage et en injection (utilisateur mixte)
    __table_args__ = (
        UniqueConstraint("prm", "direction", name="uq_meters_prm_direction"),
        CheckConstraint("prm ~ '^[0-9]{14}$'", name="ck_meters_prm_digits"),
    )

    id: Mapped[uuid.UUID] = mapped_column(primary_key=True, server_default=func.gen_random_uuid())
    user_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("users.id", ondelete="CASCADE"), index=True)
    prm: Mapped[str] = mapped_column(String(14))
    direction: Mapped[MeterDirection] = mapped_column(Enum(MeterDirection, name="meter_direction"))
    address: Mapped[str] = mapped_column(String(255))
    # Point GPS (longitude, latitude) ; les distances se calculent en mètres
    location: Mapped[str] = mapped_column(Geography(geometry_type="POINT", srid=4326))
    peak_kw: Mapped[Decimal | None] = mapped_column(Numeric(6, 2))
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

    user: Mapped[User] = relationship(back_populates="meters")


class Loop(Base):
    """Boucle d'autoconsommation collective (une « opération » pour Enedis)."""

    __tablename__ = "loops"
    __table_args__ = (
        CheckConstraint("perimeter_km > 0", name="ck_loops_perimeter_positive"),
        CheckConstraint(
            "commission_eur_kwh >= 0 AND commission_eur_kwh < price_eur_kwh",
            name="ck_loops_commission_below_price",
        ),
    )

    id: Mapped[uuid.UUID] = mapped_column(primary_key=True, server_default=func.gen_random_uuid())
    name: Mapped[str] = mapped_column(String(100))
    # Distance maximale entre les deux sites les plus éloignés (un diamètre, pas un rayon)
    perimeter_km: Mapped[Decimal] = mapped_column(Numeric(5, 2), server_default="2")
    price_eur_kwh: Mapped[Decimal] = mapped_column(Numeric(6, 4))
    commission_eur_kwh: Mapped[Decimal] = mapped_column(Numeric(6, 4))
    allocation_mode: Mapped[AllocationMode] = mapped_column(
        Enum(AllocationMode, name="allocation_mode"), server_default=AllocationMode.dynamic_default.value
    )
    status: Mapped[LoopStatus] = mapped_column(
        Enum(LoopStatus, name="loop_status"), server_default=LoopStatus.open.value
    )
    enedis_operation_id: Mapped[str | None] = mapped_column(String(50))
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

    members: Mapped[list["LoopMember"]] = relationship(back_populates="loop")


# Statuts qui engagent un compteur : ils comptent dans le périmètre et dans l'unicité
ENGAGED_STATUSES = (MembershipStatus.pending, MembershipStatus.active)


class LoopMember(Base):
    __tablename__ = "loop_members"
    __table_args__ = (
        # Un point de livraison ne participe qu'à une seule opération à la fois
        Index(
            "uq_loop_members_engaged_meter",
            "meter_id",
            unique=True,
            postgresql_where=text("status IN ('pending', 'active')"),
        ),
    )

    id: Mapped[uuid.UUID] = mapped_column(primary_key=True, server_default=func.gen_random_uuid())
    loop_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("loops.id"), index=True)
    # Pas de suppression en cascade : l'historique de participation sert à la facturation
    meter_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("meters.id"), index=True)
    status: Mapped[MembershipStatus] = mapped_column(
        Enum(MembershipStatus, name="membership_status"), server_default=MembershipStatus.pending.value
    )
    static_key: Mapped[Decimal | None] = mapped_column(Numeric(7, 6))
    requested_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    # Date d'entrée dans l'opération, fixée par la PMO à la validation
    joined_at: Mapped[date | None] = mapped_column(Date)
    left_at: Mapped[date | None] = mapped_column(Date)

    loop: Mapped[Loop] = relationship(back_populates="members")
    meter: Mapped[Meter] = relationship()


class LoadCurve(Base):
    """Courbe de charge : puissance moyenne d'un compteur sur un pas de 15 min.

    Hypertable TimescaleDB (35 040 points par compteur et par an). Données personnelles
    sensibles : elles révèlent la présence au domicile.
    """

    __tablename__ = "load_curves"

    meter_id: Mapped[uuid.UUID] = mapped_column(
        ForeignKey("meters.id", ondelete="CASCADE"), primary_key=True
    )
    # Début du pas de 15 min, en UTC
    ts: Mapped[datetime] = mapped_column(DateTime(timezone=True), primary_key=True)
    # Puissance moyenne en kW sur le pas (énergie : kWh = kW × 0,25)
    kw_avg: Mapped[Decimal] = mapped_column(Numeric(8, 3))
    source: Mapped[DataSource] = mapped_column(Enum(DataSource, name="data_source"))


class Allocation(Base):
    """Énergie affectée d'un producteur à un consommateur sur un pas de 15 min (hypertable).

    6 décimales : les sommes mensuelles restent exactes, l'arrondi au centime se fait une seule
    fois, sur le montant mensuel.
    """

    __tablename__ = "allocations"

    loop_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("loops.id"), primary_key=True)
    ts: Mapped[datetime] = mapped_column(DateTime(timezone=True), primary_key=True)
    producer_meter_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("meters.id"), primary_key=True)
    consumer_meter_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("meters.id"), primary_key=True)
    source: Mapped[DataSource] = mapped_column(Enum(DataSource, name="data_source"), primary_key=True)
    kwh: Mapped[Decimal] = mapped_column(Numeric(14, 6))
