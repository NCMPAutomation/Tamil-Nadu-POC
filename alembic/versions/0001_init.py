"""init schema

Revision ID: 0001_init
Revises:
Create Date: 2026-04-28 00:00:00.000000
"""

from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


revision: str = "0001_init"
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


field_type_enum = sa.Enum("TEXT", "NUMBER", "DATE", "PHONE", "TEXTAREA", "DROPDOWN", name="fieldtype")
case_status_enum = sa.Enum("DRAFT", "SUBMITTED", "APPROVED", "REJECTED", name="casestatus")


def upgrade() -> None:
    op.create_table(
        "case_types",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("name", sa.String(length=255), nullable=False),
        sa.Column("code", sa.String(length=100), nullable=False, unique=True),
        sa.Column("is_active", sa.Boolean(), nullable=False, server_default=sa.true()),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.text("CURRENT_TIMESTAMP")),
    )
    op.create_index("ix_case_types_id", "case_types", ["id"])
    op.create_index("ix_case_types_code", "case_types", ["code"], unique=True)

    op.create_table(
        "form_fields",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("case_type_id", sa.Integer(), sa.ForeignKey("case_types.id", ondelete="CASCADE"), nullable=False),
        sa.Column("field_name", sa.String(length=128), nullable=False),
        sa.Column("label", sa.String(length=255), nullable=False),
        sa.Column("field_type", field_type_enum, nullable=False),
        sa.Column("is_required", sa.Boolean(), nullable=False, server_default=sa.false()),
        sa.Column("options", sa.JSON(), nullable=True),
        sa.Column("order_index", sa.Integer(), nullable=False, server_default="0"),
    )
    op.create_index("ix_form_fields_id", "form_fields", ["id"])
    op.create_index("ix_form_fields_case_type_id", "form_fields", ["case_type_id"])

    op.create_table(
        "case_entries",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("case_type_id", sa.Integer(), sa.ForeignKey("case_types.id"), nullable=False),
        sa.Column("status", case_status_enum, nullable=False, server_default="DRAFT"),
        sa.Column("created_by", sa.String(length=100), nullable=False),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.text("CURRENT_TIMESTAMP")),
    )
    op.create_index("ix_case_entries_id", "case_entries", ["id"])
    op.create_index("ix_case_entries_case_type_id", "case_entries", ["case_type_id"])

    op.create_table(
        "case_field_values",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("case_entry_id", sa.Integer(), sa.ForeignKey("case_entries.id", ondelete="CASCADE"), nullable=False),
        sa.Column("field_id", sa.Integer(), sa.ForeignKey("form_fields.id"), nullable=False),
        sa.Column("value", sa.Text(), nullable=False),
    )
    op.create_index("ix_case_field_values_id", "case_field_values", ["id"])
    op.create_index("ix_case_field_values_case_entry_id", "case_field_values", ["case_entry_id"])
    op.create_index("ix_case_field_values_field_id", "case_field_values", ["field_id"])


def downgrade() -> None:
    op.drop_index("ix_case_field_values_field_id", table_name="case_field_values")
    op.drop_index("ix_case_field_values_case_entry_id", table_name="case_field_values")
    op.drop_index("ix_case_field_values_id", table_name="case_field_values")
    op.drop_table("case_field_values")

    op.drop_index("ix_case_entries_case_type_id", table_name="case_entries")
    op.drop_index("ix_case_entries_id", table_name="case_entries")
    op.drop_table("case_entries")

    op.drop_index("ix_form_fields_case_type_id", table_name="form_fields")
    op.drop_index("ix_form_fields_id", table_name="form_fields")
    op.drop_table("form_fields")

    op.drop_index("ix_case_types_code", table_name="case_types")
    op.drop_index("ix_case_types_id", table_name="case_types")
    op.drop_table("case_types")

    case_status_enum.drop(op.get_bind(), checkfirst=False)
    field_type_enum.drop(op.get_bind(), checkfirst=False)
