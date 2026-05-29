"""add case type metadata

Revision ID: 0002_case_type_metadata
Revises: 0001_init
Create Date: 2026-05-29 00:00:00.000000
"""

from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


revision: str = "0002_case_type_metadata"
down_revision: Union[str, None] = "0001_init"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.add_column("case_types", sa.Column("icon", sa.String(length=64), nullable=True))
    op.add_column("case_types", sa.Column("color", sa.String(length=32), nullable=True))


def downgrade() -> None:
    op.drop_column("case_types", "color")
    op.drop_column("case_types", "icon")
