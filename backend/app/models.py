import enum
import uuid
from datetime import datetime
from decimal import Decimal

from geoalchemy2 import Geography
from sqlalchemy import (
    CheckConstraint,
    DateTime,
    Enum,
    ForeignKey,
    Numeric,
    String,
    UniqueConstraint,
    func,
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
