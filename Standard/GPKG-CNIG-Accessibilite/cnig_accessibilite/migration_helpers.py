"""Utility functions for writing CNIG Alembic migrations.

Usage in a migration script:
    from cnig_accessibilite.migration_helpers import (
        create_id_trigger, drop_id_trigger,
        upsert_enum_constraint, insert_enum_constraint, delete_enum_constraint,
        register_all_enum_constraints,
        register_all_column_constraints,
        add_column_constraint, update_column_constraint, remove_column_constraint,
        rename_column_constraint,
        remap_column_values, remap_constraint_values,
    )

All functions import `alembic.op` lazily and can only be called from within
an upgrade() / downgrade() migration context.
"""
from __future__ import annotations

import sqlalchemy as sa


# CNIG class ID triggers helpers

def create_id_trigger(table: str, id_col: str, prefix: str) -> None:
    """Create the AFTER INSERT trigger that generates the CNIG business identifier.

    Generates '{PREFIX}:{fid}:LOC' when the id column is NULL on insert.
    ':LOC' is split as ':' || 'LOC' to prevent SQLAlchemy from treating it
    as a bind parameter.
    """
    from alembic import op
    op.execute(f"""
        CREATE TRIGGER trg_{table}_set_id
        AFTER INSERT ON {table}
        WHEN NEW.{id_col} IS NULL
        BEGIN
            UPDATE {table}
            SET {id_col} = '{prefix}:' || CAST(NEW.fid AS TEXT) || ':' || 'LOC'
            WHERE fid = NEW.fid;
        END
    """)


def drop_id_trigger(table: str) -> None:
    """Drop the business-ID auto-generation trigger (IF EXISTS).

    Must be called before any batch_alter_table that renames the id column,
    since SQLite batch mode recreates the table and loses triggers.
    """
    from alembic import op
    op.execute(f"DROP TRIGGER IF EXISTS trg_{table}_set_id")


# CNIG value lists (enum) helpers, insert into table gpkg_data_column_constraints

def insert_enum_constraint(constraint_name: str, values: tuple[str, ...]) -> None:
    """Insert enum values for a constraint (no prior deletion)."""
    from alembic import op
    bind = op.get_bind()
    for value in values:
        bind.execute(
            sa.text("""
                INSERT INTO gpkg_data_column_constraints
                    (constraint_name, constraint_type, value)
                VALUES (:n, 'enum', :v)
            """),
            {"n": constraint_name, "v": value},
        )


def upsert_enum_constraint(constraint_name: str, values: tuple[str, ...]) -> None:
    """Delete then re-insert all values for an existing enum constraint.

    Use this to update a list that already exists in the database (upgrade/downgrade).
    Use insert_enum_constraint for brand-new constraints.
    """
    delete_enum_constraint(constraint_name)
    insert_enum_constraint(constraint_name, values)


def delete_enum_constraint(constraint_name: str) -> None:
    """Delete all values for an enum constraint."""
    from alembic import op
    op.get_bind().execute(
        sa.text("""
            DELETE FROM gpkg_data_column_constraints
            WHERE constraint_name = :n
        """),
        {"n": constraint_name},
    )


def register_all_enum_constraints(
    enum_constraints: dict[str, tuple[str, ...]],
) -> None:
    """Bulk-insert all constraints from a complete ENUM_CONSTRAINTS dict.

    Intended for the initial schema creation migration only.
    """
    for constraint_name, values in enum_constraints.items():
        insert_enum_constraint(constraint_name, values)


# GPKG data columns helpers, add, drop, update, rename ...

def register_all_column_specs(
    column_specs: dict[tuple[str, str], tuple[str | None, str]],
) -> None:
    """Bulk-insert all (table, column) -> (constraint, description) mappings.

    Intended for the initial schema creation migration only.
    """
    from alembic import op
    bind = op.get_bind()
    for (table_name, column_name), (constraint_name, desc) in column_specs.items():
        bind.execute(
            sa.text("""
                INSERT INTO gpkg_data_columns
                    (table_name, column_name, constraint_name, description)
                VALUES (:t, :c, :n, :d)
            """),
            {"t": table_name, "c": column_name, "n": constraint_name, "d": desc},
        )


def add_column_constraint(
    table: str, column: str, constraint: str, description: str | None = None
) -> None:
    """Register a new column -> constraint mapping in gpkg_data_columns."""
    from alembic import op
    op.get_bind().execute(
        sa.text("""
            INSERT INTO gpkg_data_columns
                (table_name, column_name, constraint_name, description)
            VALUES (:t, :c, :n, :d)
        """),
        {"t": table, "c": column, "n": constraint, "d": description},
    )


def update_column_constraint(table: str, column: str, new_constraint: str) -> None:
    """Update the constraint name for an existing column in gpkg_data_columns."""
    from alembic import op
    op.get_bind().execute(
        sa.text("""
            UPDATE gpkg_data_columns
            SET constraint_name = :n
            WHERE table_name = :t AND column_name = :c
        """),
        {"n": new_constraint, "t": table, "c": column},
    )


def remove_column_constraint(table: str, column: str) -> None:
    """Remove a column -> constraint mapping from gpkg_data_columns."""
    from alembic import op
    op.get_bind().execute(
        sa.text("""
            DELETE FROM gpkg_data_columns
            WHERE table_name = :t AND column_name = :c
        """),
        {"t": table, "c": column},
    )


def rename_column_constraint(table: str, old_column: str, new_column: str) -> None:
    """Rename the column entry in gpkg_data_columns, preserving constraint and description.

    Since column_name is part of the primary key, a direct UPDATE is not possible
    in SQLite — this function deletes the old row and re-inserts it under the new name.
    """
    from alembic import op
    bind = op.get_bind()
    row = bind.execute(
        sa.text("""
            SELECT constraint_name, description
            FROM gpkg_data_columns
            WHERE table_name = :t AND column_name = :c
        """),
        {"t": table, "c": old_column},
    ).fetchone()
    if row is None:
        return
    bind.execute(
        sa.text("""
            DELETE FROM gpkg_data_columns
            WHERE table_name = :t AND column_name = :c
        """),
        {"t": table, "c": old_column},
    )
    bind.execute(
        sa.text("""
            INSERT INTO gpkg_data_columns
                (table_name, column_name, constraint_name, description)
            VALUES (:t, :c, :n, :d)
        """),
        {"t": table, "c": new_column, "n": row.constraint_name, "d": row.description},
    )


# Update data when modification in values lists

def remap_column_values(table: str, column: str, mapping: dict[str, str]) -> None:
    """Replace column values according to a mapping dict.

    Values not present in the mapping are left unchanged.
    Mappings are defined in versions/mappings.py.
    """
    from alembic import op
    bind = op.get_bind()
    for old_val, new_val in mapping.items():
        bind.execute(
            sa.text(
                f"UPDATE {table} SET {column} = :new WHERE {column} = :old"),
            {"new": new_val, "old": old_val},
        )


ColumnSpecs = dict[tuple[str, str], tuple[str | None, str]]

def remap_constraint_values(
    old_constraint: str,
    mapping: dict[str, str],
    old_specs: ColumnSpecs,
    new_specs: ColumnSpecs | None = None,
    new_constraint: str | None = None,
) -> None:
    """Remap values for every (table, column) that used a constraint in old_specs.

    When new_specs is provided, only columns whose new constraint equals
    new_constraint (defaults to old_constraint) are processed — this skips
    columns that changed to a different constraint between versions.
    """
    target = new_constraint if new_constraint is not None else old_constraint
    for (table, col), (cname, _) in old_specs.items():
        if cname != old_constraint:
            continue
        if new_specs is not None and new_specs.get((table, col), (None,))[0] != target:
            continue
        remap_column_values(table, col, mapping)
