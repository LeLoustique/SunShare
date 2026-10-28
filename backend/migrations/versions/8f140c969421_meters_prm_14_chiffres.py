"""meters : PRM à 14 chiffres

Revision ID: 8f140c969421
Revises: f2f4e107bc25
Create Date: 2026-10-28 09:55:52.617919

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '8f140c969421'
down_revision: Union[str, Sequence[str], None] = 'f2f4e107bc25'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    # Écrite à la main : l'autogénération d'Alembic ne détecte pas les contraintes CHECK
    op.create_check_constraint("ck_meters_prm_digits", "meters", "prm ~ '^[0-9]{14}$'")


def downgrade() -> None:
    """Downgrade schema."""
    op.drop_constraint("ck_meters_prm_digits", "meters", type_="check")
