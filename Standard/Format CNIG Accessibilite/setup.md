# Installation

### Prérequis

- Python 3.10+

### Dans un projet existant

```bash
pip install cnig-accessibilite
```
⚠️ Commande actuellement indisponible, utiliser l'installation ci-dessous

### Pour le développement

```bash
python3 -m venv venv
source venv/bin/activate   # Windows : venv\Scripts\activate
pip install -e .
```

**Dépendances** : `sqlalchemy`, `alembic`, `shapely`, `pyproj`, `click`

| Module | Version |
|:--------|:--------:|
| SQLAlchemy | >= 2.0 |
| alembic | >= 0.18.1 |
| shapely | >= 2.0 |
| pyproj | >= 3.0 |
| click | >= 8.3 |

<br>

---

# Utilisation

Le module est utilisable en Python et en ligne de commande (CLI), via la CLI `gpkg-cnig` ou directement via Alembic.

## 1. CLI gpkg-cnig

Après installation, la commande `gpkg-cnig` est disponible.

### Créer un nouveau GeoPackage

```bash
gpkg-cnig create cnig_accessibilite.gpkg
```

| Options | Défaut | Description |
|---|---|---|
| `--srid` / `-srid` | `2154` | Code EPSG de la projection |
| `--revision` / `-r` | `head` | Révision / version cible (`001`, `002`, `head`) |
| `--overwrite` / `-o` | — | Écrase le fichier s'il existe déjà |

```bash
# exemples
gpkg-cnig create cnig_accessibilite.gpkg --srid 3948
gpkg-cnig create cnig_accessibilite.gpkg --revision 001
gpkg-cnig create cnig_accessibilite.gpkg --revision head --overwrite
```

### Connaître la version du schéma

```bash
gpkg-cnig version cnig_accessibilite.gpkg
```

### Mettre à jour vers une version plus récente

```bash
gpkg-cnig upgrade cnig_accessibilite.gpkg
```

| Options | Défaut | Description |
|---|---|---|
| `--revision` / `-r` | `+1` | Révision cible (`+1` = révision suivante, `head` = dernière revision) |
| `--output` / `-o` | — | Chemin de la copie créée (auto-nommée si omis) |

Si l'option `--output` n'est pas spécifiée, crée une **copie** nommée `cnig_accessibilite_v{version}.gpkg`. L'original est conservé intact.

```bash
# exemples
gpkg-cnig upgrade cnig_accessibilite.gpkg --revision 002
gpkg-cnig upgrade cnig_accessibilite.gpkg --output ./cnig_accessibilite_v2.gpkg
```

### Rétrograder vers une version antérieure

```bash
gpkg-cnig downgrade cnig_accessibilite.gpkg
```

| Options | Défaut | Description |
|---|---|---|
| `--revision` / `-r` | `-1` | Révision cible (`-1` = révision précédente, `base` = schéma vide) |
| `--output` / `-o` | — | Chemin de la copie créée (auto-nommée si omis) |

Si l'option `--output` n'est pas spécifiée, crée une **copie** nommée `cnig_accessibilite_v{version}.gpkg`. L'original est conservé intact.

```bash
# exemples
gpkg-cnig downgrade cnig_accessibilite_v2.gpkg --revision 001
gpkg-cnig downgrade cnig_accessibilite_v2.gpkg --output ./cnig_accessibilite_v1.gpkg
```

---

## 2. API Python

Un exemple d'utilisation est donné dans [`tests/example.py`](tests/example.py).

### Créer un nouveau GeoPackage

```python
from cnig_accessibilite import create_gpkg
create_gpkg("cnig_accessibilite.gpkg")

## Exemples
# Avec une projection différente
create_gpkg("cnig_accessibilite.gpkg", srid=3948)

# Écraser un fichier existant
create_gpkg("cnig_accessibilite.gpkg", overwrite=True)

# Créer uniquement jusqu'à une révision donnée
create_gpkg("cnig_accessibilite.gpkg", revision="001")
```

| Paramètre | Type | Défaut | Description |
|---|---|---|---|
| `output_path` | `str` | — | Chemin du fichier `.gpkg` à créer |
| `srid` | `int` | `2154` | Code EPSG de la projection |
| `overwrite` | `bool` | `False` | Écraser le fichier s'il existe déjà |
| `revision` | `str` | `"head"` | Révision cible Alembic |

Le fichier est créé avec le schéma complet du standard, les métadonnées GeoPackage obligatoires, les triggers de génération automatique des identifiants CNIG (`CIR:1:LOC`, `STA:1:LOC`…) et les listes de valeurs CNIG.

---

### Connaître la version du schéma

```python
from cnig_accessibilite import get_schema_version

version = get_schema_version("cnig_accessibilite.gpkg")
```

| Revision (Alembic) | Version (Standard CNIG) |
|---|:---|
| `001` | `v2025-03` |
| `002` | `v2026-04` | 
| `base` | fichier vide |
| `head` | dernière version implémentée (`v2026-04`) |

---

### Mettre à jour un GeoPackage

```python
from cnig_accessibilite import upgrade_gpkg

upgraded_file_path = upgrade_gpkg("cnig_accessibilite.gpkg")
```

`upgrade_gpkg` crée une **copie** du fichier, applique toutes les migrations en attente jusqu'à la révision `head`, puis renomme la copie avec la version cible (`cnig_accessibilite_v{version}.gpkg`). L'original n'est jamais modifié.

Si un fichier du même nom existe déjà, un horodatage est ajouté : `cnig_accessibilite_v002_20260424_163000.gpkg`.

| Paramètre | Type | Défaut | Description |
|---|---|---|---|
| `gpkg_path` | `str` | — | Chemin du fichier `.gpkg` source |
| `revision` | `str` | `"+1"` | Révision cible (`+1` = révision suivante, `head` = dernière revision) |
| `output_path` | `str` | `None` | Chemin de la copie créée (auto-nommée si omis) |

Retourne le `Path` de la copie créée.

---

### Rétrograder un GeoPackage

```python
from cnig_accessibilite import downgrade_gpkg

downgraded_file_path = downgrade_gpkg("cnig_accessibilite.gpkg")
```

Même comportement qu'`upgrade_gpkg` : crée une copie versionnée, laisse l'original intact.

| Paramètre | Type | Défaut | Description |
|---|---|---|---|
| `gpkg_path` | `str` | — | Chemin du fichier `.gpkg` source |
| `revision` | `str` | `"-1"` | Révision cible (`-1` = révision précédente, `base` = schéma vide) |
| `output_path` | `str` | `None` | Chemin de la copie créée (auto-nommée si omis) |

> **Attention** — Les données des colonnes supprimées par suite à une mise à jour, par `upgrade` ou `downgrade`, sont perdues de manière irréversible.

---

### Accès aux listes de valeurs  

```python
from cnig_accessibilite import allowed_values

# Valeurs autorisées pour un champ
print(allowed_values("circulation", "typeTroncon"))
# -> ('trottoir', 'rue', ..., 'espace ouvert', 'NC', 'sans objet')
```

Les listes sont celles de la dernière version du standard.

---

## 3. Alembic — gestion avancée des versions

Pour utiliser la CLI Alembic directement (autogenerate, historique…), spécifiez le fichier de configuration embarqué dans le package et la variable `GPKG_PATH` :

```bash
export GPKG_PATH=cnig_accessibilite.gpkg
alembic -c cnig_accessibilite/alembic.ini current     # révision active
alembic -c cnig_accessibilite/alembic.ini history     # liste des migrations
```

### Montée de version

```bash
alembic -c cnig_accessibilite/alembic.ini upgrade +1      # révision suivante
alembic -c cnig_accessibilite/alembic.ini upgrade head    # dernière version
alembic -c cnig_accessibilite/alembic.ini upgrade 002     # révision précise
```

### Rétrogradation

```bash
alembic -c cnig_accessibilite/alembic.ini downgrade -1      # révision précédente
alembic -c cnig_accessibilite/alembic.ini downgrade base    # schéma vide
alembic -c cnig_accessibilite/alembic.ini downgrade 001     # révision précise
```

> **Note** — La CLI Alembic modifie le fichier **en place**, sans créer de copie. Utilisez `upgrade_gpkg` / `downgrade_gpkg` de l'API Python ou la CLI `gpkg-cnig` pour conserver l'original.

### Générer une migration pour une nouvelle version du standard

Pour générer une nouvelle migration, il est nécessaire d’implémenter la nouvelle version du standard (voir les scripts dans `cnig_accessibilite/cnig_versions`).

Afin de conserver l’historique des versions, il est recommandé de créer un nouveau dossier pour cette version, puis d’y copier et adapter les scripts `schema.py` et `enums.py`.

Le script `mappings.py` doit ensuite être complété avec les règles de conversion des valeurs entre l’ancienne et la nouvelle version.

Enfin, il faut définir la version courante du standard dans les scripts `cnig_accessibilite/schema.py` et `cnig_accessibilite/enums.py`.

#### Générer automatiquement le script de migration

```bash
export GPKG_PATH=cnig_accessibilite.gpkg
alembic -c cnig_accessibilite/alembic.ini revision --autogenerate -m "CNIG Accessibilite v2021-10 rev.202X-XX"
```

Alembic détecte automatiquement les colonnes ajoutées, supprimées ou renommées. Complétez ensuite le script généré dans `cnig_accessibilite/migrations/versions/` pour les éléments non détectés par l'autogenerate (triggers, listes de valeurs `gpkg_schema`, migrations de données).

Des fonctions utilitaires sont prévues pour faciliter la complétion du script.

### Fonctions utilitaires pour les migrations

Le module `cnig_accessibilite.migration_helpers` fournit des fonctions prêtes à l'emploi pour les trois parties récurrentes de toute migration. Elles utilisent `alembic.op` en import différé et ne peuvent être appelées que depuis le contexte `upgrade()` / `downgrade()`.

```python
from cnig_accessibilite.migration_helpers import (
    create_id_trigger, drop_id_trigger,
    upsert_enum_constraint, insert_enum_constraint, delete_enum_constraint,
    register_all_enum_constraints,
    register_all_column_specs,
    add_column_constraint, update_column_constraint, remove_column_constraint,
    rename_column_constraint,
    remap_column_values, remap_constraint_values,
)
```

#### Triggers identifiants CNIG

| Fonction | Description |
|---|---|
| `create_id_trigger(table, id_col, prefix)` | Crée le trigger `AFTER INSERT` qui génère `{PREFIX}:{fid}:LOC` si la colonne est `NULL` |
| `drop_id_trigger(table)` | Supprime le trigger (`IF EXISTS`) — à appeler avant un `batch_alter_table` qui renomme la colonne d'identifiant |

```python
# Upgrade : renommage de colonne d'identifiant
drop_id_trigger("stationnement_pmr")
with op.batch_alter_table("stationnement_pmr") as batch_op:
    batch_op.alter_column("idStationnement", new_column_name="idStationnementPmr")
create_id_trigger("stationnement_pmr", "idStationnementPmr", "STA")

# Downgrade : inverse
drop_id_trigger("stationnement_pmr")
with op.batch_alter_table("stationnement_pmr") as batch_op:
    batch_op.alter_column("idStationnementPmr", new_column_name="idStationnement")
create_id_trigger("stationnement_pmr", "idStationnement", "STA")
```

#### `gpkg_data_column_constraints` — listes de valeurs

| Fonction | Description |
|---|---|
| `register_all_enum_constraints(enum_constraints)` | Insertion initiale depuis un `ENUM_CONSTRAINTS` complet (migration de base) |
| `insert_enum_constraint(name, values)` | Insère les valeurs d'une **nouvelle** contrainte |
| `upsert_enum_constraint(name, values)` | Supprime puis réinsère les valeurs d'une contrainte **existante** (modification) |
| `delete_enum_constraint(name)` | Supprime toutes les valeurs d'une contrainte |

```python
# Upgrade : liste existante modifiée, nouvelle liste ajoutée
upsert_enum_constraint("etat",         ETAT)        # +2 valeurs
insert_enum_constraint("regularite",   REGULARITE)  # nouvelle liste

# Downgrade : inverse
delete_enum_constraint("regularite")
upsert_enum_constraint("etat", ETAT_V25)
```

#### `gpkg_data_columns` — mappages colonne -> contrainte

| Fonction | Description |
|---|---|
| `register_all_column_specs(column_specs)` | Insertion initiale depuis un `COLUMN_SPECS` complet (migration de base) |
| `add_column_constraint(table, column, constraint, description=None)` | Enregistre le mapping d'une nouvelle colonne |
| `update_column_constraint(table, column, new_constraint)` | Modifie la contrainte d'une colonne existante |
| `rename_column_constraint(table, old_column, new_column)` | Renomme l'entrée colonne en préservant contrainte et description |
| `remove_column_constraint(table, column)` | Supprime le mapping d'une colonne |

```python
# Upgrade : nouvelle colonne, changement de contrainte
add_column_constraint("escalier", "regularite", "regularite")
update_column_constraint("quai", "etatRevetement", "etat_revetement")

# Downgrade : inverse
remove_column_constraint("escalier", "regularite")
update_column_constraint("quai", "etatRevetement", "etat")
```

#### Migration de données

| Fonction | Description |
|---|---|
| `remap_column_values(table, column, mapping)` | Remplace les valeurs d'une colonne selon un dictionnaire. Les valeurs absentes du mapping sont conservées |
| `remap_constraint_values(old_constraint, mapping, old_specs, new_specs=None, new_constraint=None)` | Applique le mapping à **toutes** les colonnes qui utilisaient `old_constraint` dans `old_specs`, en filtrant optionnellement par la contrainte attendue dans `new_specs` |

Les correspondances sont centralisées dans `cnig_versions/mappings.py`. `remap_constraint_values` exploite les `COLUMN_SPECS` de chaque version pour auto-découvrir les `(table, colonne)` concernées, sans les lister à la main :

```python
from cnig_accessibilite.cnig_versions.v2025.enums import COLUMN_SPECS as OLD_SPECS
from cnig_accessibilite.cnig_versions.v2026.enums import COLUMN_SPECS as NEW_SPECS
from cnig_accessibilite.cnig_versions.mappings import (
    ETAT_V001_TO_ETAT_REVETEMENT_V002,
    ETAT_V001_TO_ETAT_V002,
)

# Colonnes passant de la contrainte "etat" à "etat_revetement"
# (ex. quai.etatRevetement, stationnement_pmr.etatRevetement)
remap_constraint_values("etat", ETAT_V001_TO_ETAT_REVETEMENT_V002,
                        old_specs=OLD_SPECS, new_specs=NEW_SPECS,
                        new_constraint="etat_revetement")

# Colonnes conservant la contrainte "etat" avec des valeurs renommées
remap_constraint_values("etat", ETAT_V001_TO_ETAT_V002,
                        old_specs=OLD_SPECS, new_specs=NEW_SPECS)
```

`remap_column_values` reste utile pour cibler une colonne précise sans passer par les specs :

```python
remap_column_values("quai", "etatRevetement", ETAT_V001_TO_ETAT_REVETEMENT_V002)
```

---

## Notes techniques

- **Format géométrie** : GeoPackageBinary (magic `GP` + WKB little-endian), conforme à la spécification OGC GeoPackage 1.3.
- **Systèmes de coordonnées** : EPSG:4326 (WGS84) et EPSG:2154 (Lambert-93) sont inclus par défaut dans `gpkg_spatial_ref_sys`. Tout autre EPSG est pris en charge via `pyproj` (`pip install pyproj`). Le SRID par défaut à la création est `2154`.
- **Identifiants métier CNIG** : générés automatiquement par trigger AFTER INSERT au format `{CODE}:{fid}:LOC` (ex. `CIR:1:LOC`) si le champ est laissé à `NULL`.
- **Listes de valeurs QGIS** : chargées dans l'extension OGC `gpkg_schema` (`gpkg_data_columns` + `gpkg_data_column_constraints`). QGIS les affiche comme menus déroulants dans le formulaire d'attributs.
- **Booléens** : stockés en `BOOL` acceptant la valeur NULL. Sous QGIS, le type `BOOL` est interprété nativement en checkbox et la valeur NULL devient False. Elle peut être modifiée après configuration du projet QGIS.
- **Valeurs multiples** : les attributs à valeurs multiples (ex. `controleBEV`) utilisent le séparateur `|` comme prescrit par le standard.
- **Versionnage Alembic** : la révision courante est stockée dans la table `gpkg_metadata` (custom helpers pour Alembic).
- **Migrations SQLite** : Alembic utilise `render_as_batch=True` pour contourner les limitations d'`ALTER TABLE` de SQLite (recréation de table transparente). Les opérations DDL SQLite ne sont pas transactionnelles : une migration partiellement appliquée après une erreur peut laisser le schéma dans un état intermédiaire. Recréez le fichier depuis `upgrade base` + `upgrade head` dans ce cas.
- **Copies de sécurité** : `upgrade_gpkg` et `downgrade_gpkg` ne modifient jamais le fichier source. La copie créée est nommée `{stem}_v{version}.gpkg` ; si ce nom existe déjà, un horodatage est ajouté (`{stem}_v{version}_{YYYYMMDD_HHMMSS}.gpkg`).


### Versions du standard supportés

| Version (Standard CNIG) | Revision (Alembic) |
|:---|:---:|
| `v2025-03` | `001` |
| `v2026-04` | `002` |
| dernière version implémentée (`v2026-04`) | `head` |
