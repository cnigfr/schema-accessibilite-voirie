"""
cnig_accessibilite
=======================
Generate and upgrade GeoPackage files conforming to the
CNIG Accessibility standard for pedestrian pathways
(v2021-10 rev.2026-04).

Quick start:
    from cnig_accessibilite import create_gpkg, upgrade_gpkg

    create_gpkg("cnig_accessibilite.gpkg")
    upgrade_gpkg("cnig_accessibilite.gpkg")   # after a new standard revision
"""

__version__ = "2.0.0"
__standard__ = "CNIG Accessibilité v2021-10 rev.2026-04"

from .commands import create_gpkg, get_schema_version, upgrade_gpkg, downgrade_gpkg
from .enums import (
    allowed_values, validate,
    ENUM_CONSTRAINTS, COLUMN_SPECS, COLUMN_CONSTRAINTS, COLUMN_DESCRIPTIONS,
)

__all__ = [
    "create_gpkg",
    "upgrade_gpkg",
    "downgrade_gpkg",
    "get_schema_version",
    "allowed_values",
    "validate",
    "ENUM_CONSTRAINTS",
    "COLUMN_SPECS",
    "COLUMN_CONSTRAINTS",
    "COLUMN_DESCRIPTIONS",
]
