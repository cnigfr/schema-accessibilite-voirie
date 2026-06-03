"""GeoPackage utilities: geometry encoding and metadata tables."""
import struct
from typing import Optional

import shapely

# GPKG constants for blob geometry
_GPKG_MAGIC = b"GP"
_GPKG_VERSION = 0

# Minimal WKT for built-in SRS
_SRS_WGS84 = (
    'GEOGCS["WGS 84",DATUM["WGS_1984",'
    'SPHEROID["WGS 84",6378137,298.257223563,AUTHORITY["EPSG","7030"]],'
    'AUTHORITY["EPSG","6326"]],'
    'PRIMEM["Greenwich",0,AUTHORITY["EPSG","8901"]],'
    'UNIT["degree",0.0174532925199433,AUTHORITY["EPSG","9122"]],'
    'AUTHORITY["EPSG","4326"]]'
)

_SRS_LAMBERT93 = (
    'PROJCS["RGF93 / Lambert-93",'
    'GEOGCS["RGF93",DATUM["Reseau_Geodesique_Francais_1993",'
    'SPHEROID["GRS 1980",6378137,298.257222101,AUTHORITY["EPSG","7019"]],'
    'AUTHORITY["EPSG","6171"]],'
    'PRIMEM["Greenwich",0,AUTHORITY["EPSG","8901"]],'
    'UNIT["degree",0.0174532925199433,AUTHORITY["EPSG","9122"]],'
    'AUTHORITY["EPSG","4171"]],'
    'PROJECTION["Lambert_Conformal_Conic_2SP"],'
    'PARAMETER["standard_parallel_1",49],'
    'PARAMETER["standard_parallel_2",44],'
    'PARAMETER["latitude_of_origin",46.5],'
    'PARAMETER["central_meridian",3],'
    'PARAMETER["false_easting",700000],'
    'PARAMETER["false_northing",6600000],'
    'UNIT["metre",1,AUTHORITY["EPSG","9001"]],'
    'AUTHORITY["EPSG","2154"]]'
)


# GeoPackage geometry encoding / decoding
def encode_gpkg_geometry(geom, srid: int = 4326) -> Optional[bytes]:
    """Encodes a Shapely geometry to GeoPackage binary format (GeoPackageBinary).

    Format: magic(2) + version(1) + flags(1) + srs_id(4) + WKB
    flags = 0x01 (little-endian, no envelope, non-empty)
    flags = 0x11 (little-endian, no envelope, empty)
    """
    if geom is None:
        return None
    flags = 0x11 if geom.is_empty else 0x01
    # Shapely 2.x: byte_order=1 for little-endian
    wkb = shapely.to_wkb(geom, byte_order=1, include_srid=False)
    header = struct.pack("<2sBBi", _GPKG_MAGIC, _GPKG_VERSION, flags, srid)
    return header + wkb


def decode_gpkg_geometry(data: bytes):
    """Decodes a GeoPackage blob into a Shapely geometry."""
    if data is None:
        return None
    magic, _version, flags, _srs_id = struct.unpack_from("<2sBBi", data, 0)
    if magic != _GPKG_MAGIC:
        raise ValueError(f"Invalid GeoPackage magic: {magic!r}")
    is_empty = (flags >> 4) & 0x01
    if is_empty:
        return None
    envelope_type = (flags >> 1) & 0x07
    # number of float64 values depending on envelope type (0->0, 1->4, 2->6, 3->6, 4->8)
    envelope_counts = {0: 0, 1: 4, 2: 6, 3: 6, 4: 8}
    wkb_offset = 8 + envelope_counts.get(envelope_type, 0) * 8
    return shapely.from_wkb(data[wkb_offset:])


def get_srs_info(srid: int) -> tuple[str, str, str]:
    """Returns (srs_name, organization, wkt) for an EPSG code.

    For 4326 and 2154, returns built-in WKTs (no external dependency).
    For any other EPSG, uses pyproj (pip install pyproj).
    """
    if srid == 4326:
        return ("WGS 84 geodetic", "EPSG", _SRS_WGS84)
    if srid == 2154:
        return ("RGF93 / Lambert-93", "EPSG", _SRS_LAMBERT93)
    try:
        from pyproj import CRS
        crs = CRS.from_epsg(srid)
        return (crs.name, "EPSG", crs.to_wkt())
    except ImportError:
        raise ImportError(
            f"pyproj is required to use EPSG:{srid}. "
            "Install it with: pip install pyproj"
        ) from None


# GPKG tables to exclude from Alembic autogenerate
GPKG_SYSTEM_TABLES = frozenset({
    "gpkg_spatial_ref_sys",
    "gpkg_contents",
    "gpkg_geometry_columns",
    "gpkg_extensions",
    "gpkg_tile_matrix_set",
    "gpkg_tile_matrix",
    "gpkg_metadata",
    "gpkg_metadata_reference",
    "gpkg_data_columns",
    "gpkg_data_column_constraints",
    # Alembic version table — gpkg_ prefix hides it from classic DB Manager
    "gpkg_alembic_version",
})
