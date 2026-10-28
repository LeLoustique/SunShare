"""Factures et relevés de reversement en PDF (PAY-03).

Le document d'un relevé émis est généré une fois, à l'émission, puis archivé avec le relevé : il
reste identique même si cette mise en page évolue. Un brouillon est rendu à la volée, barré d'un
filigrane. Génération déterministe (`invariant=1`) : mêmes données, mêmes octets.
"""

from dataclasses import dataclass
from datetime import date
from decimal import Decimal
from io import BytesIO

from reportlab.lib.colors import Color, black
from reportlab.lib.pagesizes import A4
from reportlab.lib.units import mm
from reportlab.pdfgen.canvas import Canvas
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.config import settings
from app.models import LoopMember, Meter, MeterDirection, Statement, StatementStatus
from app.timesteps import PARIS

# Espace insécable : jamais de retour à la ligne entre un nombre et son unité
NBSP = "\u00a0"

MONTHS = [
    "janvier", "février", "mars", "avril", "mai", "juin",
    "juillet", "août", "septembre", "octobre", "novembre", "décembre",
]


def _french(value: Decimal, decimals: int) -> str:
    """« 1 234,56 » : milliers séparés par des espaces insécables, virgule décimale.

    Signe moins ASCII : le « − » typographique n'existe pas dans les polices standard du PDF.
    """
    units, fraction = f"{value:.{decimals}f}".split(".")
    sign = "-" if units.startswith("-") else ""
    units = units.lstrip("-")
    groups = []
    while units:
        groups.insert(0, units[-3:])
        units = units[:-3]
    return f"{sign}{NBSP.join(groups)},{fraction}"


def euros(amount: Decimal) -> str:
    return f"{_french(amount, 2)}{NBSP}€"


def kwh(value: Decimal) -> str:
    return f"{_french(value, 3)}{NBSP}kWh"


def rate(eur_per_kwh: Decimal) -> str:
    return f"{eur_per_kwh:.4f}".replace(".", ",") + f"{NBSP}€/kWh"


@dataclass(frozen=True)
class StatementDocument:
    """Tout ce qui est imprimé, préparé à partir du relevé (`document_for`)."""

    number: str | None
    issued_on: date | None
    month: date
    loop_name: str
    direction: MeterDirection
    recipient: str
    email: str
    addresses: list[str]
    prms: list[str]
    kwh: Decimal
    price_eur_kwh: Decimal
    commission_eur_kwh: Decimal
    network_fee_eur_kwh: Decimal
    gross_eur: Decimal
    network_fee_eur: Decimal
    commission_eur: Decimal
    net_eur: Decimal

    @property
    def is_invoice(self) -> bool:
        return self.direction is MeterDirection.consumption


def document_for(db: Session, statement: Statement) -> StatementDocument:
    meters = db.scalars(
        select(Meter)
        .join(LoopMember, LoopMember.meter_id == Meter.id)
        .where(
            LoopMember.loop_id == statement.loop_id,
            Meter.user_id == statement.user_id,
            Meter.direction == statement.direction,
        )
        .distinct()
        .order_by(Meter.prm)
    ).all()
    user = statement.user
    return StatementDocument(
        number=statement.number,
        issued_on=statement.issued_at.astimezone(PARIS).date() if statement.issued_at else None,
        month=statement.month,
        loop_name=statement.loop.name,
        direction=statement.direction,
        recipient=f"{user.first_name} {user.last_name}",
        email=user.email,
        addresses=sorted({meter.address for meter in meters}),
        prms=[meter.prm for meter in meters],
        kwh=statement.kwh,
        price_eur_kwh=statement.price_eur_kwh,
        commission_eur_kwh=statement.commission_eur_kwh,
        network_fee_eur_kwh=statement.network_fee_eur_kwh,
        gross_eur=statement.gross_eur,
        network_fee_eur=statement.network_fee_eur,
        commission_eur=statement.commission_eur,
        net_eur=statement.net_eur,
    )


def pdf_for(db: Session, statement: Statement) -> bytes:
    """PDF archivé d'un relevé émis, ou rendu à la volée d'un brouillon."""
    if statement.status is StatementStatus.issued and statement.pdf:
        return statement.pdf
    return render(document_for(db, statement))


GREY = Color(0.45, 0.45, 0.45)
LEFT, RIGHT = 20 * mm, A4[0] - 20 * mm


def render(doc: StatementDocument) -> bytes:
    buffer = BytesIO()
    pdf = Canvas(buffer, pagesize=A4, invariant=1)
    title = "Facture" if doc.is_invoice else "Relevé de reversement"
    period = f"{MONTHS[doc.month.month - 1]} {doc.month.year}"
    pdf.setTitle(f"{title} {doc.number or 'brouillon'} — {period}")
    pdf.setAuthor(settings.pmo_name)

    def text(x, y, value, size=10, bold=False, color=black, align="left"):
        pdf.setFont("Helvetica-Bold" if bold else "Helvetica", size)
        pdf.setFillColor(color)
        draw = {"left": pdf.drawString, "right": pdf.drawRightString}[align]
        draw(x, y, value)

    # Émetteur et identification du document
    top = A4[1] - 25 * mm
    text(LEFT, top, settings.pmo_name, 13, bold=True)
    text(LEFT, top - 6 * mm, settings.pmo_address, 9, color=GREY)
    text(LEFT, top - 11 * mm, settings.pmo_siren, 9, color=GREY)
    text(RIGHT, top, title.upper(), 16, bold=True, align="right")
    text(RIGHT, top - 7 * mm, f"N° {doc.number}" if doc.number else "Non émis", 10, align="right")
    if doc.issued_on:
        text(RIGHT, top - 12 * mm, f"Émis le {doc.issued_on:%d/%m/%Y}", 10, align="right")
    text(RIGHT, top - 17 * mm, f"Période : {period}", 10, align="right")

    # Destinataire
    y = top - 35 * mm
    text(LEFT, y, "Destinataire", 9, color=GREY)
    text(LEFT, y - 5 * mm, doc.recipient, 11, bold=True)
    text(LEFT, y - 10 * mm, doc.email, 9)
    line = y - 15 * mm
    for address in doc.addresses:
        text(LEFT, line, address, 9)
        line -= 4.5 * mm
    if doc.prms:
        text(LEFT, line, "PRM : " + ", ".join(doc.prms), 9)
        line -= 4.5 * mm
    text(LEFT, line - 4 * mm, f"Autoconsommation collective — boucle « {doc.loop_name} »", 10)

    # Détail
    y = line - 16 * mm
    columns = (LEFT, 115 * mm, 150 * mm, RIGHT)
    for x, header, align in zip(
        columns, ("Désignation", "Quantité", "Prix unitaire", "Montant"),
        ("left", "right", "right", "right"), strict=True,
    ):
        text(x, y, header, 9, bold=True, align=align)
    pdf.setStrokeColor(GREY)
    pdf.line(LEFT, y - 2 * mm, RIGHT, y - 2 * mm)

    rows = []
    if doc.is_invoice:
        # Libellés courts : la colonne Désignation fait ~70 mm (la période est dans l'en-tête)
        rows.append(("Énergie locale reçue", kwh(doc.kwh), rate(doc.price_eur_kwh),
                     euros(doc.gross_eur - doc.network_fee_eur)))
        if doc.network_fee_eur:
            rows.append(("Acheminement (TURPE)", kwh(doc.kwh),
                         rate(doc.network_fee_eur_kwh), euros(doc.network_fee_eur)))
        totals = [("Total à payer", euros(doc.net_eur))]
    else:
        rows.append(("Énergie vendue dans la boucle", kwh(doc.kwh),
                     rate(doc.price_eur_kwh), euros(doc.gross_eur)))
        rows.append(("Commission SunShare", kwh(doc.kwh), rate(doc.commission_eur_kwh),
                     euros(-doc.commission_eur)))
        totals = [("Net reversé", euros(doc.net_eur))]

    y -= 8 * mm
    for designation, quantity, unit_price, amount in rows:
        text(LEFT, y, designation, 10)
        text(115 * mm, y, quantity, 10, align="right")
        text(150 * mm, y, unit_price, 10, align="right")
        text(RIGHT, y, amount, 10, align="right")
        y -= 7 * mm
    pdf.line(115 * mm, y + 3 * mm, RIGHT, y + 3 * mm)
    for label, amount in totals:
        text(150 * mm, y - 3 * mm, label, 11, bold=True, align="right")
        text(RIGHT, y - 3 * mm, amount, 11, bold=True, align="right")

    # Pied de page
    footer = 30 * mm
    text(LEFT, footer, "Montants calculés à partir des énergies réparties publiées par Enedis.", 8,
         color=GREY)
    text(LEFT, footer - 4.5 * mm, settings.pmo_vat_mention, 8, color=GREY)
    text(LEFT, footer - 9 * mm, f"Document émis par {settings.pmo_name} via SunShare.", 8, color=GREY)

    if not doc.number:
        pdf.saveState()
        pdf.setFillColor(Color(0.85, 0.2, 0.2, alpha=0.18))
        pdf.setFont("Helvetica-Bold", 90)
        pdf.translate(A4[0] / 2, A4[1] / 2)
        pdf.rotate(35)
        pdf.drawCentredString(0, 0, "BROUILLON")
        pdf.restoreState()

    pdf.showPage()
    pdf.save()
    return buffer.getvalue()
