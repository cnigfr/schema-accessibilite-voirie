"""
SQLAlchemy schema – CNIG Accessibility standard v2021-10 rev.2026-04

"""

from sqlalchemy import Boolean, CheckConstraint, Column, Float, Integer, LargeBinary, MetaData, Table, Text

metadata = MetaData()

# Spatial layer registry (populated as tables are defined)
# name -> (geom_type, identifier, description)
SPATIAL_LAYERS: dict[str, tuple[str, str, str]] = {}


def _spatial(name: str, geom_type: str, identifier: str, description: str = "") -> None:
    SPATIAL_LAYERS[name] = (geom_type, identifier, description)


# 1. CIRCULATION  –  linear geometry
CIRCULATION = Table(
    "circulation", metadata,
    Column("fid",           Integer, primary_key=True),
    Column("idCirculation", Text,    unique=True),    # set by trigger if NULL
    Column("from",          Text),                    # start node
    Column("to",            Text),                    # end node
    Column("longueur",        Integer),     # metre, rounded to the metre
    Column("typeTroncon",     Text),        # enum: segment type
    Column("statutVoie",      Text),        # enum: road status
    Column("pente",           Integer),     # % (signed integer)
    Column("devers",          Integer),     # % (signed integer)
    Column("urlMedia",        Text),
    Column("typeSol",         Text),        # enum: surface type
    Column("largeurUtile",    Float),       # metre, cm precision
    Column("etatRevetement",  Text),        # enum: surface condition
    Column("eclairage",       Text),        # enum: lighting
    Column("transition",      Text),        # enum: transition
    Column("typePassage",     Text),        # enum: passage type
    Column("repereLineaire",  Text),        # enum: linear reference
    Column("couvert",         Text),        # enum: covered
    Column("geom", LargeBinary),            # LINESTRING (GeoPackageBinary)
)
_spatial("circulation", "LINESTRING", "Circulation",
         "Tronçon de cheminement avec attributs de circulation intégrés")

# 2. NOEUD_CHEMINEMENT  –  point geometry
NOEUD_CHEMINEMENT = Table(
    "noeud_cheminement", metadata,
    Column("fid",                Integer, primary_key=True),
    Column("idNoeud",            Text,    unique=True),
    Column("altitude",           Float),  # metre NGF, cm resolution
    Column("bandeEveilVigilance", Text),   # enum: condition
    Column("hauteurRessaut",     Float),  # metre, cm resolution
    Column("abaissePente",       Integer),  # % as integer
    Column("abaisseLargeur",     Float),  # metre, cm resolution
    Column("masqueCovisibilite", Text),   # enum: visibility mask
    # enum: BEV control (multi-value, | separator)
    Column("controleBEV",        Text),
    Column("bandeInterception",  Boolean),  # boolean (0/1)
    Column("geom", LargeBinary),          # POINT
)
_spatial("noeud_cheminement", "POINT", "Noeud_Cheminement",
         "Noeud de cheminement – extrémité d'un tronçon")

# 3. OBSTACLE  –  point geometry
OBSTACLE = Table(
    "obstacle", metadata,
    Column("fid",                 Integer, primary_key=True),
    Column("idObstacle",          Text,    unique=True),
    Column("typeObstacle",        Text),   # enum: obstacle type
    Column("largeurUtile",        Float),  # metre, cm resolution
    Column("positionObstacle",    Text),   # enum: obstacle position
    Column("longueurObstacle",    Float),  # metre, dm resolution
    Column("rappelObstacle",      Text),   # enum: obstacle reminder
    Column("reperabiliteVisuelle", Boolean),  # boolean
    Column("urlMedia",            Text),
    Column("hauteurSousObs",      Float),  # metre, cm resolution
    Column("hauteurObsPoseSol",   Float),  # metre, cm resolution
    Column("geom", LargeBinary),           # POINT
)
_spatial("obstacle", "POINT", "Obstacle",
         "Obstacle sur le parcours du cheminement")

# 4. TRAVERSEE
TRAVERSEE = Table(
    "traversee", metadata,
    Column("fid",         Integer, primary_key=True),
    Column("idTraversee", Text,    unique=True),
    Column("from",            Text),   # start node
    Column("to",              Text),   # end node
    Column("longueur",        Integer),  # metre
    Column("statutVoie",      Text),   # enum: road status
    Column("pente",           Integer),  # % (signed integer)
    Column("devers",          Integer),  # % (signed integer)
    Column("urlMedia",        Text),
    Column("etatRevetement",  Text),   # enum: condition
    Column("typeMarquage",    Text),   # enum: marking
    Column("etatMarquage",    Text),   # enum: condition
    Column("eclairage",       Text),   # enum: lighting
    Column("feuPietons",      Boolean),  # boolean
    Column("aideSonore",      Text),   # enum: condition
    Column("repereLineaire",  Text),   # enum: linear reference
    Column("chausseeBombee",  Boolean),  # boolean
    Column("voiesTraversees", Text),   # road codes (B, C, T, V) concatenated
    CheckConstraint(
        "voiesTraversees GLOB '*[BCVT]*'", name="ck_traversee_voies_traversees"),
    Column("geom", LargeBinary),       # LINESTRING
)
_spatial("traversee", "LINESTRING", "Traversee", "Traversée piétonne")

# 5. RAMPE
RAMPE = Table(
    "rampe", metadata,
    Column("fid",     Integer, primary_key=True),
    Column("idRampe", Text,    unique=True),
    Column("from",            Text),
    Column("to",              Text),
    Column("longueur",        Integer),
    Column("statutVoie",      Text),
    Column("pente",           Integer),
    Column("devers",          Integer),
    Column("urlMedia",        Text),
    Column("etatRevetement",  Text),   # enum: condition
    Column("largeurUtile",    Float),  # metre, cm resolution
    Column("mainCourante",    Text),   # enum: side
    Column("distPalierRepos", Float),  # metre, cm resolution
    Column("chasseRoue",      Text),   # enum: side
    Column("aireRotation",    Text),   # enum: height position
    Column("poidsSupporte",   Integer),  # kg
    Column("geom", LargeBinary),       # LINESTRING
)
_spatial("rampe", "LINESTRING", "Rampe", "Rampe d'accès")

# 6. ESCALIER
ESCALIER = Table(
    "escalier", metadata,
    Column("fid",       Integer, primary_key=True),
    Column("idEscalier", Text,    unique=True),
    Column("from",                Text),
    Column("to",                  Text),
    Column("longueur",            Integer),
    Column("statutVoie",          Text),
    Column("pente",               Integer),
    Column("devers",              Integer),
    Column("urlMedia",            Text),
    Column("etatRevetement",       Text),   # enum: condition
    Column("mainCourante",         Text),   # enum: side
    Column("dispositifVigilance",  Text),   # enum: condition
    Column("contrasteVisuel",      Text),   # enum: condition
    Column("largeurUtile",         Float),  # metre, cm resolution
    Column("mainCouranteContinue", Text),   # enum: side
    Column("prolongMainCourante",  Text),   # enum: side
    Column("nbMarches",            Integer),
    Column("nbVoleeMarches",       Integer),
    Column("hauteurMarche",        Float),  # metre, cm resolution
    Column("giron",                Float),  # metre, cm resolution
    Column("regularite",           Text),   # enum: regularity (v2026)
    Column("rampeInterne",         Text),   # enum: internal ramp (v2026)
    Column("geom", LargeBinary),            # LINESTRING
)
_spatial("escalier", "LINESTRING", "Escalier", "Escalier")

# 7. ESCALATOR
ESCALATOR = Table(
    "escalator", metadata,
    Column("fid",        Integer, primary_key=True),
    Column("idEscalator", Text,    unique=True),
    Column("from",                Text),
    Column("to",                  Text),
    Column("longueur",            Integer),
    Column("statutVoie",          Text),
    Column("pente",               Integer),
    Column("devers",              Integer),
    Column("urlMedia",            Text),
    Column("transition",          Text),   # up / down / variable
    Column("dispositifVigilance", Text),   # enum: condition
    Column("largeurUtile",        Float),  # metre, cm resolution
    Column("detecteur",           Boolean),  # boolean
    Column("supervision",         Boolean),  # boolean
    Column("geom", LargeBinary),           # LINESTRING
)
_spatial("escalator", "LINESTRING", "Escalator", "Escalier mécanique")

# 8. TAPIS_ROULANT
TAPIS_ROULANT = Table(
    "tapis_roulant", metadata,
    Column("fid",          Integer, primary_key=True),
    Column("idTapisRoulant", Text,   unique=True),
    Column("from",                Text),
    Column("to",                  Text),
    Column("longueur",            Integer),
    Column("statutVoie",          Text),
    Column("pente",               Integer),
    Column("devers",              Integer),
    Column("urlMedia",            Text),
    Column("sens",                Text),   # direct / indirect / variable
    Column("dispositifVigilance", Text),   # enum: condition
    Column("largeurUtile",        Float),  # metre, cm resolution
    Column("detecteur",           Boolean),  # boolean
    Column("geom", LargeBinary),           # LINESTRING
)
_spatial("tapis_roulant", "LINESTRING", "Tapis_Roulant", "Tapis roulant")

# 9. QUAI
QUAI = Table(
    "quai", metadata,
    Column("fid",    Integer, primary_key=True),
    Column("idQuai", Text,    unique=True),
    Column("from",                Text),
    Column("to",                  Text),
    Column("longueur",            Integer),
    Column("statutVoie",          Text),
    Column("pente",               Integer),
    Column("devers",              Integer),
    Column("urlMedia",            Text),
    Column("etatRevetement",      Text),   # enum: condition
    Column("hauteur",             Float),  # metre, cm resolution
    Column("largeurPassage",      Float),  # metre, cm resolution
    Column("signalisationPorte",  Text),   # enum: signalling device
    Column("dispositifVigilance", Text),   # enum: condition
    Column("diamZoneManoeuvre",   Float),  # metre, cm resolution
    Column("geom", LargeBinary),           # LINESTRING
)
_spatial("quai", "LINESTRING", "Quai", "Quai d'arrêt de transport en commun")

# 10. ASCENSEUR
ASCENSEUR = Table(
    "ascenseur", metadata,
    Column("fid",                Integer, primary_key=True),
    Column("idAscenseur",        Text,    unique=True),
    Column("largeurUtile",       Float),  # metre, cm resolution
    Column("diamManoeuvFauteuil", Float),  # metre, cm resolution
    Column("largeurCabine",      Float),  # metre, cm resolution
    Column("longueurCabine",     Float),  # metre, cm resolution
    Column("boutonsEnRelief",    Text),   # enum: button relief
    Column("annonceSonore",      Boolean),  # boolean
    Column("signalEtage",        Text),   # enum: signalling device
    Column("boucleInducMagnet",  Boolean),  # boolean (BIM)
    Column("miroir",             Boolean),  # boolean
    Column("eclairage",          Integer),  # lux
    Column("voyantAlerte",       Text),   # enum: lift indicator
    Column("typeOuverture",      Text),   # enum: opening type
    Column("mainCourante",       Text),   # enum: side
    Column("hauteurMainCourante", Float),  # metre, cm resolution
    Column("etatRevetement",     Text),   # enum: condition
    Column("supervision",        Boolean),  # boolean
    Column("autrePorteSortie",   Text),   # enum: side
    Column("opaciteParois",      Boolean),  # boolean – opaque walls (v2026)
    Column("geom", LargeBinary),          # POINT
)
_spatial("ascenseur", "POINT", "Ascenseur", "Ascenseur")

# 11. ELEVATEUR
ELEVATEUR = Table(
    "elevateur", metadata,
    Column("fid",                 Integer, primary_key=True),
    Column("idElevateur",         Text,    unique=True),
    Column("largeurUtile",        Float),  # metre, cm resolution
    Column("boutonsEnRelief",     Text),   # enum: button relief
    Column("typeOuverture",       Text),   # enum: opening type
    Column("largeurPlateforme",   Float),  # metre, cm resolution
    Column("longueurPlateforme",  Float),  # metre, cm resolution
    Column("utilisableAutonomie", Boolean),  # boolean
    Column("etatRevetement",      Text),   # enum: condition
    Column("supervision",         Boolean),  # boolean
    Column("autrePorteSortie",    Text),   # enum: side
    Column("chargeMaximum",       Integer),  # kg
    Column("accompagnateur",      Text),   # enum: temporality
    Column("geom", LargeBinary),           # POINT
)
_spatial("elevateur", "POINT", "Elevateur",
         "Élévateur / plate-forme élévatrice")

# 12. ENTREE
ENTREE = Table(
    "entree", metadata,
    Column("fid",                 Integer, primary_key=True),
    Column("idEntree",            Text,    unique=True),
    Column("idERP",               Text),   # ERP this entrance belongs to
    Column("adresse",             Text),
    Column("typeEntree",          Text),   # enum: entrance type
    Column("rampe",               Text),   # enum: ERP ramp
    Column("rampeSonnette",       Boolean),  # boolean
    Column("ascenseur",           Boolean),  # boolean
    Column("escalierNbMarche",    Integer),  # 0 if no step
    Column("escalierMainCourante", Text),   # enum: side
    Column("reperabilite",        Boolean),  # boolean
    Column("reperageEltsVitres",  Boolean),  # boolean
    Column("signaletique",        Boolean),  # boolean
    Column("largeurPassage",      Float),  # metre, cm resolution
    Column("controleAcces",       Text),   # enum: access control
    Column("entreeAccueilVisible", Boolean),  # boolean
    Column("eclairage",           Integer),  # lux
    Column("typePorte",           Text),   # enum: door type
    Column("typeOuverture",       Text),   # enum: opening type
    Column("espaceManoeuvre",     Text),   # enum: space position
    Column("largManoeuvreExt",    Float),  # metre, cm resolution
    Column("longManoeuvreExt",    Float),  # metre, cm resolution
    Column("largManoeuvreInt",    Float),  # metre, cm resolution
    Column("longManoeuvreInt",    Float),  # metre, cm resolution
    Column("typePoignee",         Text),   # enum: handle type
    Column("effortOuverture",     Integer),  # newton
    Column("geom", LargeBinary),           # POINT
)
_spatial("entree", "POINT", "Entree", "Entrée de site ou de bâtiment ERP")

# 13. PASSAGE_SELECTIF
PASSAGE_SELECTIF = Table(
    "passage_selectif", metadata,
    Column("fid",                Integer, primary_key=True),
    Column("idPassageSelectif",  Text,    unique=True),
    Column("passageMecanique",   Boolean),  # boolean
    Column("largeurUtile",       Float),  # metre, cm resolution
    Column("profondeur",         Float),  # metre, cm resolution
    Column("contrasteVisuel",    Boolean),  # boolean
    Column("geom", LargeBinary),          # POINT
)
_spatial("passage_selectif", "POINT", "Passage_Selectif",
         "Passage sélectif (chicane)")

# 14. STATIONNEMENT_PMR  –  point geometry
STATIONNEMENT_PMR = Table(
    "stationnement_pmr", metadata,
    Column("fid",                 Integer, primary_key=True),
    Column("idStationnementPmr",  Text,    unique=True),
    Column("typeStationnement",   Text),   # enum: parking type
    Column("etatRevetement",      Text),   # enum: condition
    Column("largeurStat",         Float),  # metre, cm resolution
    Column("longueurStat",        Float),  # metre, cm resolution
    Column("bandLatSecurite",     Boolean),  # boolean
    Column("surLongueur",         Float),  # metre, cm resolution
    Column("signalPMR",           Boolean),  # boolean
    Column("marquageSol",         Boolean),  # boolean
    Column("pente",               Integer),  # % as integer
    Column("devers",              Integer),  # % as integer
    Column("typeSol",             Text),   # enum: surface type
    Column("geom", LargeBinary),           # POINT
)
_spatial("stationnement_pmr", "POINT", "Stationnement_PMR",
         "Place de stationnement réservée PMR en voirie")

# 15. ERP –  polygon geometry
ERP = Table(
    "erp", metadata,
    Column("fid",                Integer, primary_key=True),
    Column("idERP",              Text,    unique=True),
    Column("nom",                Text),
    Column("adresse",            Text),
    Column("codePostal",         Text),   # string(5)
    Column("erpCategorie",       Text),   # enum: ERP category (1 to 5)
    Column("erpType",            Text),   # enum: ERP type (J, L, M, …)
    Column("dateMiseAJour",      Text),   # ISO 8601 date (YYYY-MM-DD)
    Column("sourceMiseAJour",    Text),
    Column("stationnementERP",   Boolean),  # boolean
    Column("stationnementPMR",   Integer),  # number of PMR spaces
    Column("accueilPersonnel",   Text),   # enum: ERP staff
    Column("accueilBIM",         Boolean),  # boolean – hearing loop
    Column("accueilBIMPortative", Boolean),  # boolean – portable BIM
    Column("accueilLSF",         Boolean),  # boolean – French sign language
    Column("accueilST",          Boolean),  # boolean – subtitling
    Column("accueilAideAudition", Boolean),  # boolean
    Column("accueilPrestations", Text),
    Column("sanitairesERP",      Boolean),  # boolean
    Column("sanitairesAdaptes",  Integer),  # count
    Column("telephone",          Text),
    Column("siteWeb",            Text),
    Column("siret",              Text),   # string(14)
    Column("latitude",           Float),  # WGS84, decimal(4)
    Column("longitude",          Float),  # WGS84, decimal(4)
    Column("erpActivite",        Text),
    Column("geom", LargeBinary),          # MULTIPOLYGON
)
_spatial("erp", "MULTIPOLYGON", "ERP",
         "Établissement recevant du public (ERP)")

# Class identifier triggers
# (table, id_column, CNIG prefix) — used by migrations to create AFTER INSERT triggers
ID_TRIGGERS: list[tuple[str, str, str]] = [
    ("circulation",       "idCirculation",     "CIR"),
    ("noeud_cheminement", "idNoeud",           "NOD"),
    ("obstacle",          "idObstacle",        "OBS"),
    ("traversee",         "idTraversee",       "TRA"),
    ("rampe",             "idRampe",           "RAM"),
    ("escalier",          "idEscalier",        "ESC"),
    ("escalator",         "idEscalator",       "EST"),
    ("tapis_roulant",     "idTapisRoulant",    "TAP"),
    ("quai",              "idQuai",            "QUA"),
    ("ascenseur",         "idAscenseur",       "ASC"),
    ("elevateur",         "idElevateur",       "ELE"),
    ("entree",            "idEntree",          "ENT"),
    ("passage_selectif",  "idPassageSelectif", "PSE"),
    ("stationnement_pmr", "idStationnementPmr", "STA"),
    ("erp",               "idERP",             "ERP"),
]

# All user tables in reverse creation order (safe DROP sequence)
ALL_USER_TABLES: list[str] = [
    "erp", "stationnement_pmr", "passage_selectif",
    "entree", "elevateur", "ascenseur", "quai", "tapis_roulant",
    "escalator", "escalier", "rampe", "traversee", "obstacle",
    "noeud_cheminement", "circulation",
]
