"""Semantic mappings between CNIG Accessibility standard revisions.

For each migration N -> N+1, the dictionaries define values that have
a direct equivalent in the new version. Values absent from a dict
are preserved as-is during migration.

Naming convention:
    <LIST>_<SOURCE_REVISION>_TO_<LIST>_<TARGET_REVISION>
    + automatic inverse (reverse source)
"""


def _inverse(mapping: dict[str, str]) -> dict[str, str]:
    return {v: k for k, v in mapping.items()}


### Migration 001 -> 002 (rev.2025-03 -> rev.2026-04)

# Mappings ETAT <-> ETAT_REVETEMENT - change values
ETAT_V001_TO_ETAT_REVETEMENT_V002: dict[str, str] = {
    "bon état": "roulant", 
    # "dégradation entraînant une difficulté d'usage ou d'inconfort": "dégradation entraînant un problème de sécurité immédiat",      #TODO confirm ??
    }
ETAT_REVETEMENT_V002_TO_ETAT_V001 = _inverse(ETAT_V001_TO_ETAT_REVETEMENT_V002)
ETAT_REVETEMENT_V002_TO_ETAT_V001.update({
    "meuble": "dégradation entraînant une difficulté d'usage ou d'inconfort",
    "secouant": "dégradation entraînant une difficulté d'usage ou d'inconfort",
    "glissant": "dégradation entraînant une difficulté d'usage ou d'inconfort",
})

# Mappings ETAT <-> ETAT - rename values
ETAT_V001_TO_ETAT_V002: dict[str, str] = {
    "dégradation entraînant une difficulté d'usage ou d'inconfort": "dégradation forte", 
    "dégradation entraînant un problème de sécurité immédiat": "dégradation très forte",
    }
ETAT_V002_TO_ETAT_V001 = _inverse(ETAT_V001_TO_ETAT_V002)

# Mappings TYPE_TRONCON <-> TYPE_TRONCON - rename values
TYPE_TRONCON_V001_TO_TYPE_TRONCON_V002: dict[str, str] = {
    "monte-charge / monte personne": "monte-charge ou monte personne", }
TYPE_TRONCON_V002_TO_TYPE_TRONCON_V001 = _inverse(
    TYPE_TRONCON_V001_TO_TYPE_TRONCON_V002)
