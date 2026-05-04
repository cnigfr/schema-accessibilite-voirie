"""Alembic environment for the cnig_accessibilite module.

Uses the standard Alembic flow (context.configure + context.run_migrations)
to support autogenerate and relative upgrade/downgrade commands
(alembic upgrade +1, alembic downgrade -1, alembic revision --autogenerate…).

The current revision is stored in gpkg_metadata (OGC GeoPackage metadata
extension, §F.8) with md_standard_uri = 'https://alembic.sqlalchemy.org/'.

Mechanism: a SQLite TEMP table named gpkg_alembic_version is pre-seeded from
gpkg_metadata before each migration run. SQLite resolves unqualified table
names to the temp schema first, so Alembic reads and writes our temp table
transparently. After the migration, the final revision is synced back to
gpkg_metadata and the real (empty) table Alembic may have created is dropped.
"""

import logging
import os
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2]))

from alembic import context
from sqlalchemy import engine_from_config, pool, text

from cnig_accessibilite.gpkg_utils import GPKG_SYSTEM_TABLES
from cnig_accessibilite.schema import metadata

_log = logging.getLogger("alembic.env")

# ── Alembic configuration ────────────────────────────────────────────────────
config = context.config

if config.config_file_name is not None:
    from logging.config import fileConfig
    fileConfig(config.config_file_name, disable_existing_loggers=False)

gpkg_path = os.environ.get("GPKG_PATH")
if gpkg_path:
    config.set_main_option("sqlalchemy.url", f"sqlite:///{os.path.abspath(gpkg_path)}")

gpkg_srid = os.environ.get("GPKG_SRID")
if gpkg_srid:
    config.attributes.setdefault("srid", int(gpkg_srid))

target_metadata = metadata

_ALEMBIC_URI = "https://alembic.sqlalchemy.org/"

def _include_object(_obj, name, type_, _reflected, _compare_to):
    return not (type_ == "table" and name in GPKG_SYSTEM_TABLES)


_CONFIGURE = dict(
    target_metadata=target_metadata,
    render_as_batch=True,
    version_table="gpkg_alembic_version",
    include_object=_include_object,
)


# ── gpkg_metadata version helpers ────────────────────────────────────────────

def _read_revision(connection) -> str | None:
    """Read current revision from gpkg_metadata, with fallback to the legacy
    gpkg_alembic_version table for GPKGs created before this mechanism."""
    try:
        row = connection.execute(
            text("SELECT metadata FROM gpkg_metadata WHERE md_standard_uri = :uri"),
            {"uri": _ALEMBIC_URI},
        ).fetchone()
        if row:
            return row[0]
    except Exception:
        pass
    try:
        row = connection.execute(
            text("SELECT version_num FROM main.gpkg_alembic_version"),
        ).fetchone()
        return row[0] if row else None
    except Exception:
        return None


def _write_revision(connection, revision: str | None) -> None:
    """Persist revision to gpkg_metadata (upsert) or remove it (None)."""
    try:
        row = connection.execute(
            text("SELECT id FROM gpkg_metadata WHERE md_standard_uri = :uri"),
            {"uri": _ALEMBIC_URI},
        ).fetchone()
        if revision is None:
            if row:
                connection.execute(
                    text("DELETE FROM gpkg_metadata_reference WHERE md_file_id = :id"),
                    {"id": row[0]},
                )
                connection.execute(
                    text("DELETE FROM gpkg_metadata WHERE id = :id"),
                    {"id": row[0]},
                )
        elif row:
            connection.execute(
                text("UPDATE gpkg_metadata SET metadata = :v WHERE id = :id"),
                {"v": revision, "id": row[0]},
            )
        else:
            connection.execute(
                text("""
                    INSERT INTO gpkg_metadata
                        (md_scope, md_standard_uri, mime_type, metadata)
                    VALUES ('undefined', :uri, 'text/plain', :v)
                """),
                {"uri": _ALEMBIC_URI, "v": revision},
            )
            md_id = connection.execute(
                text("SELECT id FROM gpkg_metadata WHERE md_standard_uri = :uri"),
                {"uri": _ALEMBIC_URI},
            ).fetchone()[0]
            ref = connection.execute(
                text("SELECT 1 FROM gpkg_metadata_reference WHERE md_file_id = :id"),
                {"id": md_id},
            ).fetchone()
            if not ref:
                connection.execute(
                    text("""
                        INSERT INTO gpkg_metadata_reference
                            (reference_scope, table_name, column_name,
                             row_id_value, md_file_id)
                        VALUES ('geopackage', NULL, NULL, NULL, :id)
                    """),
                    {"id": md_id},
                )
    except Exception:
        pass  # gpkg_metadata may not exist after downgrade to base


# ── Offline mode ─────────────────────────────────────────────────────────────
def run_migrations_offline() -> None:
    url = config.get_main_option("sqlalchemy.url")
    context.configure(
        url=url,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
        **_CONFIGURE,
    )
    with context.begin_transaction():
        context.run_migrations()


# ── Online mode ──────────────────────────────────────────────────────────────
def run_migrations_online() -> None:
    connectable = engine_from_config(
        config.get_section(config.config_ini_section, {}),
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )

    with connectable.connect() as connection:
        # Read current revision and pre-seed a temp table.
        # SQLite resolves unqualified names to temp schema first, so Alembic's
        # SELECT/INSERT/DELETE on gpkg_alembic_version transparently hit our
        # temp table instead of the main-schema table it creates.
        with connection.begin():
            current_rev = _read_revision(connection)
            connection.execute(text("""
                CREATE TEMP TABLE IF NOT EXISTS gpkg_alembic_version
                (version_num VARCHAR(32) NOT NULL,
                CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num))
            """))
            if current_rev:
                connection.execute(text("""
                    INSERT OR IGNORE INTO temp.gpkg_alembic_version
                    (version_num) VALUES (:v)
                    """),
                    {"v": current_rev},
                )

        context.configure(connection=connection, **_CONFIGURE)
        with context.begin_transaction():
            context.run_migrations()

        # Sync final revision back to gpkg_metadata, then remove the empty
        # real table Alembic created (checkfirst looks in sqlite_master, not
        # sqlite_temp_master, so it always attempts to create a real table).
        # Use implicit autobegin + explicit commit to avoid conflicts with any
        # transaction SQLAlchemy left open after context.begin_transaction().
        row = connection.execute(
            text("SELECT version_num FROM temp.gpkg_alembic_version"),
        ).fetchone()
        _write_revision(connection, row[0] if row else None)
        connection.execute(text("DROP TABLE IF EXISTS main.gpkg_alembic_version"))
        connection.commit()


# ── Entry point ───────────────────────────────────────────────────────────────
if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
