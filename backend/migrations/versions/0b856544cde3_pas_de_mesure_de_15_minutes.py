"""pas de mesure de 15 minutes

Revision ID: 0b856544cde3
Revises: 262739bd2032
Create Date: 2026-10-28 13:41:55.800144

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '0b856544cde3'
down_revision: Union[str, Sequence[str], None] = '262739bd2032'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Passage au pas de 15 min d'Enedis (au lieu de 30) : le schéma ne change pas.

    Les courbes et répartitions simulées au pas de 30 min deviendraient incohérentes ; elles sont
    supprimées et se régénèrent avec scripts/simulate.py. Les données Enedis ne sont pas touchées.
    """
    op.execute("DELETE FROM allocations WHERE source = 'simulated'")
    op.execute("DELETE FROM load_curves WHERE source = 'simulated'")


def downgrade() -> None:
    """Rien à restaurer : les données simulées se régénèrent."""
