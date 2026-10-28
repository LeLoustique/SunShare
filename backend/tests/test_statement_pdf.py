"""Factures et relevés en PDF : contenu (texte relu avec pypdf), archivage à l'émission, accès."""

from dataclasses import replace
from datetime import date
from decimal import Decimal as D
from io import BytesIO

import pytest
from pypdf import PdfReader

from app.config import settings
from app.models import MeterDirection
from app.statement_pdf import StatementDocument, euros, kwh, render
from tests.helpers import admin_headers, client
from tests.test_billing import issue, mine, neighbourhood, run


def text_of(pdf: bytes) -> str:
    """Texte du PDF, espaces insécables ramenés à des espaces."""
    return PdfReader(BytesIO(pdf)).pages[0].extract_text().replace(" ", " ")


FACTURE = StatementDocument(
    number="SS-2026-000001",
    issued_on=date(2026, 11, 3),
    month=date(2026, 10, 1),
    loop_name="Saint-Leu",
    direction=MeterDirection.consumption,
    recipient="Camille Martin",
    email="camille@exemple.fr",
    addresses=["12 Rue des Trois-Cailloux 80000 Amiens"],
    prms=["12345678901234"],
    kwh=D("142.5"),
    price_eur_kwh=D("0.18"),
    commission_eur_kwh=D("0.02"),
    network_fee_eur_kwh=D(0),
    gross_eur=D("25.65"),
    network_fee_eur=D("0.00"),
    commission_eur=D("0.00"),
    net_eur=D("25.65"),
)


def document(**overrides) -> StatementDocument:
    return replace(FACTURE, **overrides)


@pytest.fixture(scope="module")
def admin():
    return admin_headers()


# --- Contenu ------------------------------------------------------------------------------------


def test_facture():
    text = text_of(render(document()))

    for expected in ("FACTURE", "N° SS-2026-000001", "Émis le 03/11/2026", "Période : octobre 2026",
                     "Camille Martin", "PRM : 12345678901234", "boucle « Saint-Leu »",
                     "Énergie locale reçue", "142,500 kWh", "0,1800 €/kWh", "Total à payer",
                     "25,65 €", settings.pmo_name, settings.pmo_vat_mention):
        assert expected in text, expected
    assert "TURPE" not in text  # 0 par défaut : pas de ligne vide


def test_turpe_eventuel():
    text = text_of(render(document(
        network_fee_eur_kwh=D("0.01"), network_fee_eur=D("1.43"), gross_eur=D("27.08"),
        net_eur=D("27.08"),
    )))
    assert "Acheminement (TURPE)" in text
    assert "1,43 €" in text and "27,08 €" in text


def test_releve_de_reversement():
    text = text_of(render(document(
        direction=MeterDirection.production, commission_eur=D("2.85"), net_eur=D("22.80"),
    )))
    for expected in ("RELEVÉ DE REVERSEMENT", "Énergie vendue dans la boucle", "Commission SunShare",
                     "-2,85 €", "Net reversé", "22,80 €"):
        assert expected in text, expected


def test_brouillon_filigrane():
    text = text_of(render(document(number=None, issued_on=None)))
    assert "BROUILLON" in text
    assert "Non émis" in text


def test_rendu_deterministe():
    assert render(document()) == render(document())


@pytest.mark.parametrize(
    ("amount", "expected"),
    [("1234567.5", "1 234 567,50 €"), ("25.65", "25,65 €"), ("-2.85", "-2,85 €"), ("0", "0,00 €")],
)
def test_montants_en_francais(amount, expected):
    assert euros(D(amount)).replace(" ", " ") == expected


def test_energie_en_francais():
    assert kwh(D("1234.5")).replace(" ", " ") == "1 234,500 kWh"


# --- Archivage et accès --------------------------------------------------------------------------


def pdf(statement_id, headers):
    return client.get(f"/api/v1/statements/{statement_id}/pdf", headers=headers)


def test_pdf_d_une_facture_emise(admin):
    loop = neighbourhood(admin, "2028-01")
    run(admin, "2028-01")
    issue(admin, "2028-01")
    (bill,) = mine(loop["a"])

    response = pdf(bill["id"], loop["a"])

    assert response.status_code == 200
    assert response.headers["content-type"] == "application/pdf"
    assert f'filename="{bill["number"]}.pdf"' in response.headers["content-disposition"]
    assert response.content.startswith(b"%PDF")
    text = text_of(response.content)
    assert bill["number"] in text and "25,65 €" in text and "janvier 2028" in text


def test_le_pdf_emis_est_archive_et_ne_change_plus(admin):
    loop = neighbourhood(admin, "2028-02")
    run(admin, "2028-02")
    issue(admin, "2028-02")
    (bill,) = mine(loop["a"])
    before = pdf(bill["id"], loop["a"]).content

    # La boucle est renommée après l'émission : la facture déjà émise garde son contenu
    client.patch(f"/api/v1/admin/loops/{loop['loop_id']}", json={"name": "Nouveau nom"}, headers=admin)

    after = pdf(bill["id"], loop["a"]).content
    assert after == before
    assert "Nouveau nom" not in text_of(after)


def test_acces_au_pdf(admin):
    loop = neighbourhood(admin, "2028-03")
    run(admin, "2028-03")
    statements = client.get(
        "/api/v1/admin/billing/statements",
        params={"month": "2028-03", "loop_id": loop["loop_id"]},
        headers=admin,
    ).json()
    draft = statements[0]

    # Brouillon : aperçu pour l'administrateur seulement
    preview = pdf(draft["id"], admin)
    assert preview.status_code == 200
    assert "BROUILLON" in text_of(preview.content)
    assert pdf(draft["id"], loop["a"]).status_code == 404

    issue(admin, "2028-03")
    (bill,) = mine(loop["a"])
    assert pdf(bill["id"], loop["b"]).status_code == 404  # la facture d'un voisin
    assert client.get(f"/api/v1/statements/{bill['id']}/pdf").status_code == 401
