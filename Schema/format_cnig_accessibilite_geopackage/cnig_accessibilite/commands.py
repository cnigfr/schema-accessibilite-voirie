"""Generation and upgrade of CNIG Accessibility GeoPackage files."""

import logging
import os
import shutil
from datetime import datetime
from pathlib import Path
from typing import Optional

from alembic import command
from alembic.config import Config
from alembic.script import ScriptDirectory
from sqlalchemy import create_engine, text


_PACKAGE_DIR = Path(__file__).parent
_ALEMBIC_INI = _PACKAGE_DIR / "alembic.ini"

_log = logging.getLogger(__name__)
_log.setLevel(logging.INFO)
_log.propagate = False
_handler = logging.StreamHandler()
_handler.setFormatter(logging.Formatter(
    '%(asctime)s %(levelname)s: %(message)s'))
_log.addHandler(_handler)


def _alembic_config(gpkg_path: str, srid: Optional[int] = None) -> Config:
    """Returns an Alembic Config pointing to the given GPKG file."""
    cfg = Config(str(_ALEMBIC_INI))
    cfg.set_main_option(
        "sqlalchemy.url",
        f"sqlite:///{os.path.abspath(gpkg_path)}"
    )
    if srid is not None:
        cfg.attributes["srid"] = srid
    return cfg


def _versioned_copy_path(gpkg_path: str, version: str) -> Path:
    """Returns a versioned copy path next to the original file.

    Result: {stem}_v{version}.gpkg, or {stem}_v{version}_{ts}.gpkg if it already exists.
    """
    p = Path(gpkg_path)
    candidate = p.with_stem(f"{p.stem}_v{version}")
    if candidate.exists():
        ts = datetime.now().strftime("%Y%m%d_%H%M%S")
        candidate = p.with_stem(f"{p.stem}_v{version}_{ts}")
    return candidate


def create_gpkg(
    output_path: str,
    srid: int = 2154,
    overwrite: bool = False,
    revision: str = "head",
) -> None:
    """Creates an empty GeoPackage file conforming to the CNIG Accessibility standard.

    :param output_path: Path of the .gpkg file to create.
    :param srid:        EPSG projection code (default: 2154 RGF93/Lambert-93).
    :param overwrite:   Overwrite the file if it already exists (default: False).
    :param revision:    Target Alembic revision (default: "head"). Examples: "001", "002".
    :raises FileExistsError: If the file exists and overwrite is False.
    """
    if os.path.exists(output_path):
        if overwrite:
            os.remove(output_path)
        else:
            raise FileExistsError(
                f"File '{output_path}' already exists. "
                "Use overwrite=True to overwrite it."
            )

    cfg = _alembic_config(output_path, srid=srid)
    command.upgrade(cfg, revision)
    _log.info("GeoPackage created: %s", output_path)
    _log_summary()


def _remove_wal_companions(path: Path) -> None:
    """Delete SQLite WAL companion files (.gpkg-shm, .gpkg-wal) if they exist."""
    for ext in ("-shm", "-wal"):
        companion = path.parent / (path.name + ext)
        if companion.exists():
            companion.unlink()


def upgrade_gpkg(gpkg_path: str, revision: str = "+1", output_path: Optional[str] = None,
) -> Path:
    """Upgrades a copy of an existing GeoPackage to a newer schema version.

    The original file is left untouched. The upgraded copy is written next
    to the original, named {stem}_v{version}.gpkg, unless output_path is given.

    :param gpkg_path:   Path of the .gpkg file to upgrade.
    :param revision:    Target Alembic revision (default: "head"). Examples: "001", "002".
    :param output_path: Explicit path for the upgraded copy. Auto-named if omitted.
    :return:            Path of the upgraded copy.
    :raises FileNotFoundError: If the file does not exist.
    """
    if not os.path.exists(gpkg_path):
        raise FileNotFoundError(f"File not found: '{gpkg_path}'")

    before = get_schema_version(gpkg_path)
    cfg = _alembic_config(gpkg_path)
    heads = ScriptDirectory.from_config(cfg).get_heads()
    target = heads[0] if (revision == "head" and heads) else revision
    if before == target or (revision == "head" and before in heads):
        _log.info("GeoPackage already at the latest version (%s): %s",
                  before, gpkg_path)
        return Path(gpkg_path)

    p = Path(gpkg_path)
    ts = datetime.now().strftime("%Y%m%d_%H%M%S")
    tmp = p.with_stem(f"{p.stem}_{ts}_tmp")
    shutil.copy2(gpkg_path, tmp)

    cfg = _alembic_config(str(tmp))
    command.upgrade(cfg, revision)
    after = get_schema_version(str(tmp))

    copy = Path(output_path) if output_path else _versioned_copy_path(gpkg_path, after or "base")
    tmp.rename(copy)
    _remove_wal_companions(tmp)

    if before == after:
        _log.info("GeoPackage already up to date (revision: %s): %s", after, copy)
    else:
        _log.info("GeoPackage upgraded: %s -> %s: %s", before, after, copy)

    return copy


def downgrade_gpkg(gpkg_path: str, revision: str = "-1", output_path: Optional[str] = None,
) -> Path:
    """Downgrades a copy of an existing GeoPackage to an older schema version.

    The original file is left untouched. The downgraded copy is written next
    to the original, named {stem}_v{version}.gpkg, unless output_path is given.

    :param gpkg_path:   Path of the .gpkg file to downgrade.
    :param revision:    Target Alembic revision (default: "-1", previous version). Examples: "001", "002".
    :param output_path: Explicit path for the downgraded copy. Auto-named if omitted.
    :return:            Path of the downgraded copy.
    :raises FileNotFoundError: If the file does not exist.
    """
    if not os.path.exists(gpkg_path):
        raise FileNotFoundError(f"File not found: '{gpkg_path}'")

    before = get_schema_version(gpkg_path)
    if before is None:
        _log.info("GeoPackage already at base (no revision): %s", gpkg_path)
        return Path(gpkg_path)

    p = Path(gpkg_path)
    ts = datetime.now().strftime("%Y%m%d_%H%M%S")
    tmp = p.with_stem(f"{p.stem}_{ts}_tmp")
    shutil.copy2(gpkg_path, tmp)

    cfg = _alembic_config(str(tmp))
    command.downgrade(cfg, revision)
    after = get_schema_version(str(tmp))

    copy = Path(output_path) if output_path else _versioned_copy_path(gpkg_path, after or "base")
    tmp.rename(copy)
    _remove_wal_companions(tmp)

    if before == after:
        _log.info("GeoPackage already up to date (revision: %s): %s", after, copy)
    else:
        _log.info("GeoPackage downgraded: %s -> %s: %s", before, after, copy)

    return copy


def get_schema_version(gpkg_path: str) -> Optional[str]:
    """Returns the current Alembic revision of a GeoPackage file.

    The version is stored in gpkg_metadata (md_standard_uri =
    'https://alembic.sqlalchemy.org/'), conforming to the OGC GeoPackage
    metadata extension.

    :param gpkg_path: Path of the .gpkg file.
    :return: Revision identifier, or None if not initialised.
    :raises FileNotFoundError: If the file does not exist.
    """
    if not os.path.exists(gpkg_path):
        raise FileNotFoundError(f"File not found: '{gpkg_path}'")

    engine = create_engine(f"sqlite:///{os.path.abspath(gpkg_path)}")
    with engine.connect() as conn:
        try:
            rev = conn.execute(
                text("""
                     SELECT metadata FROM gpkg_metadata
                     WHERE md_standard_uri = 'https://alembic.sqlalchemy.org/'
                """)
            ).scalar()
            return rev if rev else None
        except Exception:
            return None


def _log_summary() -> None:
    from .schema import SPATIAL_LAYERS
    _log.info("Spatial layers: %d", len(SPATIAL_LAYERS))
    for name, (geom, ident, _) in SPATIAL_LAYERS.items():
        _log.info("  - %-30s [%s]  (%s)", ident, geom, name)
