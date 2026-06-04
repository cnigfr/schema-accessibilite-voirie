"""Initial schema – CNIG Accessibility standard v2021-10 rev.2025-03

Creates the full flat GeoPackage schema:
  - GPKG metadata tables (gpkg_spatial_ref_sys, gpkg_contents, …)
  - 15 spatial layers (pathway segments, nodes, obstacles, equipment, ERP, …)
  - fid INTEGER PRIMARY KEY (rowid alias, required by OGC GeoPackage Req.29)
  - AFTER INSERT triggers generating idXxx = '{CODE}:{fid}:LOC' when NULL
  - OGC gpkg_schema extension: gpkg_data_columns + gpkg_data_column_constraints

Revision ID: 001
Revises:
Create Date: 2025-03-14
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision: str = "001"
down_revision: Union[str, Sequence[str], None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    from alembic import context as alembic_context
    from cnig_accessibilite.cnig_versions.v2025.enums import COLUMN_SPECS, ENUM_CONSTRAINTS
    from cnig_accessibilite.cnig_versions.v2025.schema import SPATIAL_LAYERS, ID_TRIGGERS, ALL_USER_TABLES
    from cnig_accessibilite.gpkg_utils import get_srs_info, _SRS_WGS84, _SRS_LAMBERT93
    from cnig_accessibilite.migration_helpers import (
        create_id_trigger,
        register_all_enum_constraints, register_all_column_specs,
    )

    srid: int = alembic_context.config.attributes.get("srid", 2154)

    # 1. GPKG metadata
    op.execute("PRAGMA application_id = 0x47504B47")
    op.execute("PRAGMA user_version = 10300")

    op.execute("""
        CREATE TABLE gpkg_spatial_ref_sys (
            srs_name                 TEXT    NOT NULL,
            srs_id                   INTEGER NOT NULL PRIMARY KEY,
            organization             TEXT    NOT NULL,
            organization_coordsys_id INTEGER NOT NULL,
            definition               TEXT    NOT NULL,
            description              TEXT
        )
    """)
    op.execute("""
        INSERT INTO gpkg_spatial_ref_sys
        VALUES ('Undefined cartesian SRS', -1, 'NONE', -1, 'undefined', 'undefined cartesian coordinate reference system')
    """)
    op.execute("""
        INSERT INTO gpkg_spatial_ref_sys 
        VALUES ('Undefined geographic SRS', 0, 'NONE', 0, 'undefined', 'undefined geographic coordinate reference system')
    """)
    bind_srs = op.get_bind()
    bind_srs.execute(
        sa.text(
            "INSERT INTO gpkg_spatial_ref_sys VALUES "
            "('WGS 84 geodetic', 4326, 'EPSG', 4326, :wkt, "
            "'longitude/latitude coordinates in decimal degrees on the WGS 84 spheroid')"
        ),
        {"wkt": _SRS_WGS84},
    )
    bind_srs.execute(
        sa.text(
            "INSERT INTO gpkg_spatial_ref_sys VALUES "
            "('RGF93 / Lambert-93', 2154, 'EPSG', 2154, :wkt, "
            "'Système de coordonnées officiel de la France métropolitaine')"
        ),
        {"wkt": _SRS_LAMBERT93},
    )

    if srid not in (4326, 2154, -1, 0):
        bind_early = op.get_bind()
        srs_name, org, wkt = get_srs_info(srid)
        bind_early.execute(
            sa.text(
                "INSERT OR IGNORE INTO gpkg_spatial_ref_sys VALUES (:name, :id, :org, :id, :wkt, NULL)"),
            {"name": srs_name, "id": srid, "org": org, "wkt": wkt},
        )

    op.execute("""
        CREATE TABLE gpkg_contents (
            table_name  TEXT     NOT NULL PRIMARY KEY,
            identifier  TEXT     UNIQUE,
            data_type   TEXT     NOT NULL,
            description TEXT     DEFAULT '',
            last_change DATETIME NOT NULL
                        DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
            min_x REAL, min_y REAL, max_x REAL, max_y REAL,
            srs_id INTEGER
        )
    """)

    op.execute("""
        CREATE TABLE gpkg_geometry_columns (
            table_name         TEXT    NOT NULL,
            column_name        TEXT    NOT NULL,
            geometry_type_name TEXT    NOT NULL,
            srs_id             INTEGER NOT NULL,
            z                  TINYINT NOT NULL,
            m                  TINYINT NOT NULL,
            CONSTRAINT pk_geom_cols PRIMARY KEY (table_name, column_name)
        )
    """)

    op.execute("""
        CREATE TABLE gpkg_extensions (
            table_name     TEXT,
            column_name    TEXT,
            extension_name TEXT NOT NULL,
            definition     TEXT NOT NULL,
            scope          TEXT NOT NULL,
            CONSTRAINT ge_tce UNIQUE (table_name, column_name, extension_name)
        )
    """)

    # 2. User tables
    # CIRCULATION
    op.create_table(
        "circulation",
        sa.Column("fid",            sa.Integer(), nullable=False),
        sa.Column("idCirculation",  sa.Text()),
        sa.Column("from",           sa.Text()),
        sa.Column("to",             sa.Text()),
        sa.Column("longueur",       sa.Integer()),
        sa.Column("typeTroncon",    sa.Text()),
        sa.Column("statutVoie",     sa.Text()),
        sa.Column("pente",          sa.Integer()),
        sa.Column("devers",         sa.Integer()),
        sa.Column("urlMedia",       sa.Text()),
        sa.Column("typeSol",        sa.Text()),
        sa.Column("largeurUtile",   sa.Float()),
        sa.Column("etatRevetement", sa.Text()),
        sa.Column("eclairage",      sa.Text()),
        sa.Column("transition",     sa.Text()),
        sa.Column("typePassage",    sa.Text()),
        sa.Column("repereLineaire", sa.Text()),
        sa.Column("couvert",        sa.Text()),
        sa.Column("geom",           sa.LargeBinary()),
        sa.PrimaryKeyConstraint("fid"),
        sa.UniqueConstraint("idCirculation"),
    )

    # NOEUD_CHEMINEMENT
    op.create_table(
        "noeud_cheminement",
        sa.Column("fid",                 sa.Integer(), nullable=False),
        sa.Column("idNoeud",             sa.Text()),
        sa.Column("altitude",            sa.Float()),
        sa.Column("bandeEveilVigilance", sa.Text()),
        sa.Column("hauteurRessaut",      sa.Float()),
        sa.Column("abaissePente",        sa.Integer()),
        sa.Column("abaisseLargeur",      sa.Float()),
        sa.Column("masqueCovisibilite",  sa.Text()),
        sa.Column("controleBEV",         sa.Text()),
        sa.Column("bandeInterception",   sa.Boolean()),
        sa.Column("geom",                sa.LargeBinary()),
        sa.PrimaryKeyConstraint("fid"),
        sa.UniqueConstraint("idNoeud"),
    )

    # OBSTACLE
    op.create_table(
        "obstacle",
        sa.Column("fid",                  sa.Integer(), nullable=False),
        sa.Column("idObstacle",           sa.Text()),
        sa.Column("typeObstacle",         sa.Text()),
        sa.Column("largeurUtile",         sa.Float()),
        sa.Column("positionObstacle",     sa.Text()),
        sa.Column("longueurObstacle",     sa.Float()),
        sa.Column("rappelObstacle",       sa.Text()),
        sa.Column("reperabiliteVisuelle", sa.Boolean()),
        sa.Column("urlMedia",             sa.Text()),
        sa.Column("hauteurSousObs",       sa.Float()),
        sa.Column("hauteurObsPoseSol",    sa.Float()),
        sa.Column("geom",                 sa.LargeBinary()),
        sa.PrimaryKeyConstraint("fid"),
        sa.UniqueConstraint("idObstacle"),
    )

    # TRAVERSEE
    op.create_table(
        "traversee",
        sa.Column("fid",             sa.Integer(), nullable=False),
        sa.Column("idTraversee",     sa.Text()),
        sa.Column("from",            sa.Text()),
        sa.Column("to",              sa.Text()),
        sa.Column("longueur",        sa.Integer()),
        sa.Column("statutVoie",      sa.Text()),
        sa.Column("pente",           sa.Integer()),
        sa.Column("devers",          sa.Integer()),
        sa.Column("urlMedia",        sa.Text()),
        sa.Column("etatRevetement",  sa.Text()),
        sa.Column("typeMarquage",    sa.Text()),
        sa.Column("etatMarquage",    sa.Text()),
        sa.Column("eclairage",       sa.Text()),
        sa.Column("feuPietons",      sa.Boolean()),
        sa.Column("aideSonore",      sa.Text()),
        sa.Column("repereLineaire",  sa.Text()),
        sa.Column("chausseeBombee",  sa.Boolean()),
        sa.Column("voiesTraversees", sa.Text()),
        sa.Column("geom",            sa.LargeBinary()),
        sa.PrimaryKeyConstraint("fid"),
        sa.UniqueConstraint("idTraversee"),
        sa.CheckConstraint(
            "voiesTraversees GLOB '*[BCVT]*'", name="ck_traversee_voies_traversees"),
    )

    # RAMPE
    op.create_table(
        "rampe",
        sa.Column("fid",             sa.Integer(), nullable=False),
        sa.Column("idRampe",         sa.Text()),
        sa.Column("from",            sa.Text()),
        sa.Column("to",              sa.Text()),
        sa.Column("longueur",        sa.Integer()),
        sa.Column("statutVoie",      sa.Text()),
        sa.Column("pente",           sa.Integer()),
        sa.Column("devers",          sa.Integer()),
        sa.Column("urlMedia",        sa.Text()),
        sa.Column("etatRevetement",  sa.Text()),
        sa.Column("largeurUtile",    sa.Float()),
        sa.Column("mainCourante",    sa.Text()),
        sa.Column("distPalierRepos", sa.Float()),
        sa.Column("chasseRoue",      sa.Text()),
        sa.Column("aireRotation",    sa.Text()),
        sa.Column("poidsSupporte",   sa.Integer()),
        sa.Column("geom",            sa.LargeBinary()),
        sa.PrimaryKeyConstraint("fid"),
        sa.UniqueConstraint("idRampe"),
    )

    # ESCALIER
    op.create_table(
        "escalier",
        sa.Column("fid",                  sa.Integer(), nullable=False),
        sa.Column("idEscalier",           sa.Text()),
        sa.Column("from",                 sa.Text()),
        sa.Column("to",                   sa.Text()),
        sa.Column("longueur",             sa.Integer()),
        sa.Column("statutVoie",           sa.Text()),
        sa.Column("pente",                sa.Integer()),
        sa.Column("devers",               sa.Integer()),
        sa.Column("urlMedia",             sa.Text()),
        sa.Column("etatRevetement",       sa.Text()),
        sa.Column("mainCourante",         sa.Text()),
        sa.Column("dispositifVigilance",  sa.Text()),
        sa.Column("contrasteVisuel",      sa.Text()),
        sa.Column("largeurUtile",         sa.Float()),
        sa.Column("mainCouranteContinue", sa.Text()),
        sa.Column("prolongMainCourante",  sa.Text()),
        sa.Column("nbMarches",            sa.Integer()),
        sa.Column("nbVoleeMarches",       sa.Integer()),
        sa.Column("hauteurMarche",        sa.Float()),
        sa.Column("giron",                sa.Float()),
        sa.Column("geom",                 sa.LargeBinary()),
        sa.PrimaryKeyConstraint("fid"),
        sa.UniqueConstraint("idEscalier"),
    )

    # ESCALATOR
    op.create_table(
        "escalator",
        sa.Column("fid",                 sa.Integer(), nullable=False),
        sa.Column("idEscalator",         sa.Text()),
        sa.Column("from",                sa.Text()),
        sa.Column("to",                  sa.Text()),
        sa.Column("longueur",            sa.Integer()),
        sa.Column("statutVoie",          sa.Text()),
        sa.Column("pente",               sa.Integer()),
        sa.Column("devers",              sa.Integer()),
        sa.Column("urlMedia",            sa.Text()),
        sa.Column("transition",          sa.Text()),
        sa.Column("dispositifVigilance", sa.Text()),
        sa.Column("largeurUtile",        sa.Float()),
        sa.Column("detecteur",           sa.Boolean()),
        sa.Column("supervision",         sa.Boolean()),
        sa.Column("geom",                sa.LargeBinary()),
        sa.PrimaryKeyConstraint("fid"),
        sa.UniqueConstraint("idEscalator"),
    )

    # TAPIS_ROULANT
    op.create_table(
        "tapis_roulant",
        sa.Column("fid",                 sa.Integer(), nullable=False),
        sa.Column("idTapisRoulant",      sa.Text()),
        sa.Column("from",                sa.Text()),
        sa.Column("to",                  sa.Text()),
        sa.Column("longueur",            sa.Integer()),
        sa.Column("statutVoie",          sa.Text()),
        sa.Column("pente",               sa.Integer()),
        sa.Column("devers",              sa.Integer()),
        sa.Column("urlMedia",            sa.Text()),
        sa.Column("sens",                sa.Text()),
        sa.Column("dispositifVigilance", sa.Text()),
        sa.Column("largeurUtile",        sa.Float()),
        sa.Column("detecteur",           sa.Boolean()),
        sa.Column("geom",                sa.LargeBinary()),
        sa.PrimaryKeyConstraint("fid"),
        sa.UniqueConstraint("idTapisRoulant"),
    )

    # QUAI
    op.create_table(
        "quai",
        sa.Column("fid",                 sa.Integer(), nullable=False),
        sa.Column("idQuai",              sa.Text()),
        sa.Column("from",                sa.Text()),
        sa.Column("to",                  sa.Text()),
        sa.Column("longueur",            sa.Integer()),
        sa.Column("statutVoie",          sa.Text()),
        sa.Column("pente",               sa.Integer()),
        sa.Column("devers",              sa.Integer()),
        sa.Column("urlMedia",            sa.Text()),
        sa.Column("etatRevetement",      sa.Text()),
        sa.Column("hauteur",             sa.Float()),
        sa.Column("largeurPassage",      sa.Float()),
        sa.Column("signalisationPorte",  sa.Text()),
        sa.Column("dispositifVigilance", sa.Text()),
        sa.Column("diamZoneManoeuvre",   sa.Float()),
        sa.Column("geom",                sa.LargeBinary()),
        sa.PrimaryKeyConstraint("fid"),
        sa.UniqueConstraint("idQuai"),
    )

    # ASCENSEUR
    op.create_table(
        "ascenseur",
        sa.Column("fid",                 sa.Integer(), nullable=False),
        sa.Column("idAscenseur",         sa.Text()),
        sa.Column("altitude",            sa.Float()),
        sa.Column("bandeEveilVigilance", sa.Text()),
        sa.Column("hauteurRessaut",      sa.Float()),
        sa.Column("abaissePente",        sa.Integer()),
        sa.Column("abaisseLargeur",      sa.Float()),
        sa.Column("masqueCovisibilite",  sa.Text()),
        sa.Column("controleBEV",         sa.Text()),
        sa.Column("bandeInterception",   sa.Boolean()),
        sa.Column("largeurUtile",        sa.Float()),
        sa.Column("diamManoeuvFauteuil", sa.Float()),
        sa.Column("largeurCabine",       sa.Float()),
        sa.Column("longueurCabine",      sa.Float()),
        sa.Column("boutonsEnRelief",     sa.Text()),
        sa.Column("annonceSonore",       sa.Boolean()),
        sa.Column("signalEtage",         sa.Text()),
        sa.Column("boucleInducMagnet",   sa.Boolean()),
        sa.Column("miroir",              sa.Boolean()),
        sa.Column("eclairage",           sa.Integer()),
        sa.Column("voyantAlerte",        sa.Text()),
        sa.Column("typeOuverture",       sa.Text()),
        sa.Column("mainCourante",        sa.Text()),
        sa.Column("hauteurMainCourante", sa.Float()),
        sa.Column("etatRevetement",      sa.Text()),
        sa.Column("supervision",         sa.Boolean()),
        sa.Column("autrePorteSortie",    sa.Text()),
        sa.Column("geom",                sa.LargeBinary()),
        sa.PrimaryKeyConstraint("fid"),
        sa.UniqueConstraint("idAscenseur"),
    )

    # ELEVATEUR
    op.create_table(
        "elevateur",
        sa.Column("fid",                  sa.Integer(), nullable=False),
        sa.Column("idElevateur",          sa.Text()),
        sa.Column("altitude",            sa.Float()),
        sa.Column("bandeEveilVigilance", sa.Text()),
        sa.Column("hauteurRessaut",      sa.Float()),
        sa.Column("abaissePente",        sa.Integer()),
        sa.Column("abaisseLargeur",      sa.Float()),
        sa.Column("masqueCovisibilite",  sa.Text()),
        sa.Column("controleBEV",         sa.Text()),
        sa.Column("bandeInterception",   sa.Boolean()),
        sa.Column("largeurUtile",         sa.Float()),
        sa.Column("boutonsEnRelief",      sa.Text()),
        sa.Column("typeOuverture",        sa.Text()),
        sa.Column("largeurPlateforme",    sa.Float()),
        sa.Column("longueurPlateforme",   sa.Float()),
        sa.Column("utilisableAutonomie",  sa.Boolean()),
        sa.Column("etatRevetement",       sa.Text()),
        sa.Column("supervision",          sa.Boolean()),
        sa.Column("autrePorteSortie",     sa.Text()),
        sa.Column("chargeMaximum",        sa.Integer()),
        sa.Column("accompagnateur",       sa.Text()),
        sa.Column("geom",                 sa.LargeBinary()),
        sa.PrimaryKeyConstraint("fid"),
        sa.UniqueConstraint("idElevateur"),
    )

    # ENTREE
    op.create_table(
        "entree",
        sa.Column("fid",                  sa.Integer(), nullable=False),
        sa.Column("idEntree",             sa.Text()),
        sa.Column("altitude",            sa.Float()),
        sa.Column("bandeEveilVigilance", sa.Text()),
        sa.Column("hauteurRessaut",      sa.Float()),
        sa.Column("abaissePente",        sa.Integer()),
        sa.Column("abaisseLargeur",      sa.Float()),
        sa.Column("masqueCovisibilite",  sa.Text()),
        sa.Column("controleBEV",         sa.Text()),
        sa.Column("bandeInterception",   sa.Boolean()),
        sa.Column("adresse",              sa.Text()),
        sa.Column("typeEntree",           sa.Text()),
        sa.Column("rampe",                sa.Text()),
        sa.Column("rampeSonnette",        sa.Boolean()),
        sa.Column("ascenseur",            sa.Boolean()),
        sa.Column("escalierNbMarche",     sa.Integer()),
        sa.Column("escalierMainCourante", sa.Text()),
        sa.Column("reperabilite",         sa.Boolean()),
        sa.Column("reperageEltsVitres",   sa.Boolean()),
        sa.Column("signaletique",         sa.Boolean()),
        sa.Column("largeurPassage",       sa.Float()),
        sa.Column("controleAcces",        sa.Text()),
        sa.Column("entreeAccueilVisible", sa.Boolean()),
        sa.Column("eclairage",            sa.Integer()),
        sa.Column("typePorte",            sa.Text()),
        sa.Column("typeOuverture",        sa.Text()),
        sa.Column("espaceManoeuvre",      sa.Text()),
        sa.Column("largManoeuvreExt",     sa.Float()),
        sa.Column("longManoeuvreExt",     sa.Float()),
        sa.Column("largManoeuvreInt",     sa.Float()),
        sa.Column("longManoeuvreInt",     sa.Float()),
        sa.Column("typePoignee",          sa.Text()),
        sa.Column("effortOuverture",      sa.Integer()),
        sa.Column("geom",                 sa.LargeBinary()),
        sa.PrimaryKeyConstraint("fid"),
        sa.UniqueConstraint("idEntree"),
    )

    # PASSAGE_SELECTIF
    op.create_table(
        "passage_selectif",
        sa.Column("fid",                sa.Integer(), nullable=False),
        sa.Column("idPassageSelectif",  sa.Text()),
        sa.Column("altitude",            sa.Float()),
        sa.Column("bandeEveilVigilance", sa.Text()),
        sa.Column("hauteurRessaut",      sa.Float()),
        sa.Column("abaissePente",        sa.Integer()),
        sa.Column("abaisseLargeur",      sa.Float()),
        sa.Column("masqueCovisibilite",  sa.Text()),
        sa.Column("controleBEV",         sa.Text()),
        sa.Column("bandeInterception",   sa.Boolean()),
        sa.Column("passageMecanique",   sa.Boolean()),
        sa.Column("largeurUtile",       sa.Float()),
        sa.Column("profondeur",         sa.Float()),
        sa.Column("contrasteVisuel",    sa.Boolean()),
        sa.Column("geom",               sa.LargeBinary()),
        sa.PrimaryKeyConstraint("fid"),
        sa.UniqueConstraint("idPassageSelectif"),
    )

    # STATIONNEMENT_PMR
    op.create_table(
        "stationnement_pmr",
        sa.Column("fid",               sa.Integer(), nullable=False),
        sa.Column("idStationnement",   sa.Text()),
        sa.Column("typeStationnement", sa.Text()),
        sa.Column("etatRevetement",    sa.Text()),
        sa.Column("largeurStat",       sa.Float()),
        sa.Column("longueurStat",      sa.Float()),
        sa.Column("bandLatSecurite",   sa.Boolean()),
        sa.Column("surLongueur",       sa.Float()),
        sa.Column("signalPMR",         sa.Boolean()),
        sa.Column("marquageSol",       sa.Boolean()),
        sa.Column("pente",             sa.Integer()),
        sa.Column("devers",            sa.Integer()),
        sa.Column("typeSol",           sa.Text()),
        sa.Column("geom",              sa.LargeBinary()),
        sa.PrimaryKeyConstraint("fid"),
        sa.UniqueConstraint("idStationnement"),
    )

    # ERP
    op.create_table(
        "erp",
        sa.Column("fid",                 sa.Integer(), nullable=False),
        sa.Column("idERP",               sa.Text()),
        sa.Column("nom",                 sa.Text()),
        sa.Column("adresse",             sa.Text()),
        sa.Column("codePostal",          sa.Text()),
        sa.Column("erpCategorie",        sa.Text()),
        sa.Column("erpType",             sa.Text()),
        sa.Column("dateMiseAJour",       sa.Text()),
        sa.Column("sourceMiseAJour",     sa.Text()),
        sa.Column("stationnementERP",    sa.Boolean()),
        sa.Column("stationnementPMR",    sa.Integer()),
        sa.Column("accueilPersonnel",    sa.Text()),
        sa.Column("accueilBIM",          sa.Boolean()),
        sa.Column("accueilBIMPortative", sa.Boolean()),
        sa.Column("accueilLSF",          sa.Boolean()),
        sa.Column("accueilST",           sa.Boolean()),
        sa.Column("accueilAideAudition", sa.Boolean()),
        sa.Column("accueilPrestations",  sa.Text()),
        sa.Column("sanitairesERP",       sa.Boolean()),
        sa.Column("sanitairesAdaptes",   sa.Integer()),
        sa.Column("telephone",           sa.Text()),
        sa.Column("siteWeb",             sa.Text()),
        sa.Column("siret",               sa.Text()),
        sa.Column("latitude",            sa.Float()),
        sa.Column("longitude",           sa.Float()),
        sa.Column("erpActivite",         sa.Text()),
        sa.Column("geom",                sa.LargeBinary()),
        sa.PrimaryKeyConstraint("fid"),
        sa.UniqueConstraint("idERP"),
    )

    # 3. Registration in gpkg_contents and gpkg_geometry_columns
    bind = op.get_bind()

    for table_name, (geom_type, identifier, description) in SPATIAL_LAYERS.items():
        bind.execute(
            sa.text("""
                INSERT INTO gpkg_contents
                (table_name, data_type, identifier, description, srs_id)
                VALUES (:t, 'features', :id, :desc, :srid)
            """),
            {"t": table_name, "id": identifier, "desc": description, "srid": srid},
        )
        bind.execute(
            sa.text("""
                INSERT INTO gpkg_geometry_columns
                (table_name, column_name, geometry_type_name, srs_id, z, m)
                VALUES (:t, 'geom', :geom, :srid, 0, 0)
            """),
            {"t": table_name, "geom": geom_type, "srid": srid},
        )

    # 4. GPKG extension tables and registration
    op.execute("""
        CREATE TABLE gpkg_metadata (
            id              INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            md_scope        TEXT    NOT NULL DEFAULT 'dataset',
            md_standard_uri TEXT    NOT NULL,
            mime_type       TEXT    NOT NULL DEFAULT 'text/xml',
            metadata        TEXT    NOT NULL DEFAULT ''
        )
    """)
    op.execute("""
        CREATE TABLE gpkg_metadata_reference (
            reference_scope TEXT     NOT NULL,
            table_name      TEXT,
            column_name     TEXT,
            row_id_value    INTEGER,
            timestamp       DATETIME NOT NULL
                            DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
            md_file_id      INTEGER  NOT NULL REFERENCES gpkg_metadata(id),
            md_parent_id    INTEGER  REFERENCES gpkg_metadata(id)
        )
    """)

    for ext_table, ext_name, ext_def in [
        ("gpkg_metadata",           "gpkg_metadata",
         "http://www.geopackage.org/spec120/#extension_metadata"),
        ("gpkg_metadata_reference", "gpkg_metadata",
         "http://www.geopackage.org/spec120/#extension_metadata"),
        (None,                      "gpkg_schema",
         "http://www.geopackage.org/spec/#extension_schema"),
    ]:
        bind.execute(
            sa.text("""
                INSERT INTO gpkg_extensions
                (table_name, column_name, extension_name, definition, scope)
                VALUES (:t, NULL, :name, :def, 'read-write')
            """),
            {"t": ext_table, "name": ext_name, "def": ext_def},
        )

    # 5. class identifier auto-generation triggers
    for table, id_col, prefix in ID_TRIGGERS:
        create_id_trigger(table, id_col, prefix)

    # 6. OGC gpkg_schema extension: set value lists
    op.execute("""
        CREATE TABLE gpkg_data_columns (
            table_name      TEXT NOT NULL,
            column_name     TEXT NOT NULL,
            name            TEXT,
            title           TEXT,
            description     TEXT,
            mime_type       TEXT,
            constraint_name TEXT,
            CONSTRAINT pk_gdc PRIMARY KEY (table_name, column_name)
        )
    """)

    op.execute("""
        CREATE TABLE gpkg_data_column_constraints (
            constraint_name  TEXT    NOT NULL,
            constraint_type  TEXT    NOT NULL,
            value            TEXT,
            min              NUMERIC,
            min_is_inclusive BOOLEAN,
            max              NUMERIC,
            max_is_inclusive BOOLEAN,
            description      TEXT,
            CONSTRAINT gdcc_ntv UNIQUE (constraint_name, constraint_type, value)
        )
    """)

    register_all_enum_constraints(ENUM_CONSTRAINTS)
    register_all_column_specs(COLUMN_SPECS)


def downgrade() -> None:
    from cnig_accessibilite.cnig_versions.v2025.schema import ID_TRIGGERS, ALL_USER_TABLES
    from cnig_accessibilite.migration_helpers import drop_id_trigger

    for table, *_ in ID_TRIGGERS:
        drop_id_trigger(table)

    for table_name in ALL_USER_TABLES:
        op.drop_table(table_name)

    for gpkg_table in (
        "gpkg_data_columns",
        "gpkg_data_column_constraints",
        "gpkg_metadata_reference",
        "gpkg_metadata",
        "gpkg_extensions",
        "gpkg_geometry_columns",
        "gpkg_contents",
        "gpkg_spatial_ref_sys",
    ):
        op.execute(f"DROP TABLE IF EXISTS {gpkg_table}")
