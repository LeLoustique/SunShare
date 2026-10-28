import uuid
from typing import Annotated

from fastapi import APIRouter, HTTPException, Query, status
from sqlalchemy import select

from app import billing
from app.deps import AdminUser, CurrentUser, DbSession
from app.models import Statement, StatementStatus, UserRole
from app.schemas import AdminStatementOut, BillingRunOut, IssueOut, LoopBillingOut, StatementOut
from app.timesteps import month_days

admin_router = APIRouter(prefix="/admin/billing", tags=["admin"])
router = APIRouter(tags=["facturation"])

Month = Annotated[str, Query(pattern=r"^[0-9]{4}-(0[1-9]|1[0-2])$", description="Mois AAAA-MM")]
STATEMENT_NOT_FOUND = HTTPException(status.HTTP_404_NOT_FOUND, "Relevé introuvable")


def _out(statement: Statement) -> StatementOut:
    return StatementOut(
        id=statement.id,
        number=statement.number,
        loop_id=statement.loop_id,
        loop_name=statement.loop.name,
        period=statement.month.strftime("%Y-%m"),
        direction=statement.direction,
        status=statement.status,
        kwh=round(float(statement.kwh), 3),
        price_eur_kwh=statement.price_eur_kwh,
        commission_eur_kwh=statement.commission_eur_kwh,
        network_fee_eur_kwh=statement.network_fee_eur_kwh,
        gross_eur=statement.gross_eur,
        network_fee_eur=statement.network_fee_eur,
        commission_eur=statement.commission_eur,
        net_eur=statement.net_eur,
        issued_at=statement.issued_at,
    )


@admin_router.post("/run", response_model=BillingRunOut)
def admin_run_billing(month: Month, _admin: AdminUser, db: DbSession) -> BillingRunOut:
    """Calcule les relevés du mois en brouillon, sur les seules énergies Enedis (recalculable)."""
    report = billing.run(db, month)
    return BillingRunOut(
        period=report.period,
        loops=[LoopBillingOut(**vars(loop)) for loop in report.loops],
        skipped=report.skipped,
    )


@admin_router.post("/issue", response_model=IssueOut)
def admin_issue_statements(month: Month, _admin: AdminUser, db: DbSession) -> IssueOut:
    """Émet les brouillons du mois : numérotés, figés et visibles des participants."""
    try:
        issued = billing.issue(db, month)
    except billing.BillingError as error:
        raise HTTPException(status.HTTP_409_CONFLICT, str(error)) from None
    return IssueOut(
        period=month,
        issued=len(issued),
        first_number=issued[0].number,
        last_number=issued[-1].number,
    )


@admin_router.get("/statements", response_model=list[AdminStatementOut])
def admin_list_statements(
    month: Month, _admin: AdminUser, db: DbSession, loop_id: uuid.UUID | None = None
) -> list[AdminStatementOut]:
    query = select(Statement).where(Statement.month == month_days(month)[0])
    if loop_id:
        query = query.where(Statement.loop_id == loop_id)
    statements = db.scalars(query.order_by(Statement.number, Statement.created_at))
    return [
        AdminStatementOut(
            **_out(s).model_dump(),
            first_name=s.user.first_name,
            last_name=s.user.last_name,
            email=s.user.email,
        )
        for s in statements
    ]


@router.get("/me/statements", response_model=list[StatementOut])
def list_my_statements(user: CurrentUser, db: DbSession) -> list[StatementOut]:
    """Relevés émis de l'utilisateur, du plus récent au plus ancien (brouillons cachés)."""
    statements = db.scalars(
        select(Statement)
        .where(Statement.user_id == user.id, Statement.status == StatementStatus.issued)
        .order_by(Statement.month.desc(), Statement.direction)
    )
    return [_out(s) for s in statements]


@router.get("/statements/{statement_id}", response_model=StatementOut)
def read_statement(statement_id: uuid.UUID, user: CurrentUser, db: DbSession) -> StatementOut:
    statement = db.get(Statement, statement_id)
    if statement is None:
        raise STATEMENT_NOT_FOUND
    if user.role is not UserRole.admin and (
        statement.user_id != user.id or statement.status is not StatementStatus.issued
    ):
        raise STATEMENT_NOT_FOUND  # 404 : on ne confirme pas l'existence du relevé d'un autre
    return _out(statement)
