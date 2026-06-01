"""remove case status restriction

Revision ID: 0003_remove_case_status_restriction
Revises: 0002_case_type_metadata
Create Date: 2026-06-01 00:00:00.000000
"""

from typing import Sequence, Union

from alembic import op


revision: str = "0003_remove_case_status_restriction"
down_revision: Union[str, None] = "0002_case_type_metadata"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.execute("UPDATE case_entries SET status = 'SUBMITTED' WHERE status <> 'SUBMITTED' AND status <> 'APPROVED' AND status <> 'REJECTED'")
    op.execute("ALTER TABLE case_entries MODIFY status ENUM('SUBMITTED', 'APPROVED', 'REJECTED') NOT NULL DEFAULT 'SUBMITTED'")


def downgrade() -> None:
    raise NotImplementedError("Downgrade not supported for case status restriction")
