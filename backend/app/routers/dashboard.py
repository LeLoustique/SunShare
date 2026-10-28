from datetime import date
from typing import Annotated

from fastapi import APIRouter, Query

from app import dashboard
from app.deps import CurrentUser, DbSession
from app.schemas import Dashboard, DayCurves

router = APIRouter(prefix="/me", tags=["tableau de bord"])


@router.get("/curves", response_model=DayCurves)
def read_my_curves(
    user: CurrentUser,
    db: DbSession,
    day: Annotated[
        date | None, Query(alias="date", description="Journée française (défaut : hier)")
    ] = None,
) -> DayCurves:
    """Pas de 30 min de la journée : consommation, production et énergie locale de l'utilisateur."""
    return dashboard.day_curves(db, user, day or dashboard.yesterday())


@router.get("/dashboard", response_model=Dashboard)
def read_my_dashboard(
    user: CurrentUser,
    db: DbSession,
    period: Annotated[
        str | None,
        Query(pattern=r"^[0-9]{4}-(0[1-9]|1[0-2])$", description="Mois AAAA-MM (défaut : en cours)"),
    ] = None,
) -> Dashboard:
    """Chiffres du mois : énergie locale, montant estimé, CO2 évité, taux d'autoconsommation."""
    return dashboard.month_dashboard(db, user, period or dashboard.current_month())
