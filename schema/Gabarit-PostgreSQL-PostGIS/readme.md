# Script de création des tables du standard sous PostgreSQL/PostGIS
Le [script_CNIG_accessibilite_PostgreSQL_PostGIS](https://github.com/cnigfr/schema-accessibilite-voirie/blob/main/Standard/PostgresSQL_PostGIS/script_CNIG_accessibilite_PostgreSQL_PostGIS.sql) est utilisable pour créer, dans un environnement PostgreSQL/PostGIS, un schéma contenant les tables objets du [Standard CNIG Accessibilité du cheminement en voirie](https://cnig.gouv.fr/ressources-accessibilite-a25335.html). Il est conforme à la version 2021 révision 2025-03.

## Schema et gestion des droits
Le schéma est l'emplacement de la base de données dédié au déploiement de la structure du standard. Le nom par défaut utilisé est "cnig_accessibilite" mais celui-ci peut être modifié dans le script.

Les groupes ou rôles administrateurs, utilisateurs en mode édition, utilisateurs en lecture seule sont définis respectivement par 'usr_admin', 'usr_edit' et 'usr_read'. Ils peuvent être remplacés par ceux utilisés dans la base PostgreSQL dans laquelle le schéma est déployé.

## Fonctions PL/pgSQL
PL/pgSQL est un langage procédural géré par PostgreSQL. Il est ici utilisé pour créer des fonctions d'automatisation de valeurs et de création d'identifiants selon la structure dictée par le standard.

Ces fonctions sont activées par des triggers lors de certains événements (par exemple, l'insertions ou mises-à-jour d'objets).

## Enumerations
Tables contenant les valeurs et les descriptions des types énumérés, elles sont préfixées par 'enum_%'

## Tables objets
Les tables des objets décrits dans le standard sont accompagnées de séquences (utilisées pour la génération des identifiants objets) et d'index sur ces derniers.

### Identifiants objets
Selon la codification retenue pour la compatibité avec NeTEx, les identifants sont structurés comme suit :
[CODESPACE]:[CodeClasse]:[IdentifiantTechnique]:LOC

- [CODESPACE] correspond au code INSEE de la commune, cette valeur doit être modifiée en fonction de la localisation du relevé de terrain. ;
- [CodeClasse] renseigne la classe d’objet concernée. Par exemple : TRC pour tronçon de cheminement, NOD pour nœud, etc. selon les informations fournies dans le catalogue d’objet ;
- [IdentifiantTechnique] correspond à l’identifiant unique de l’objet dans la base de données source de la collectivité, la valuer 'CNIG' a été utilisée par défaut ;
- Le suffixe LOC est obligatoire. Il indique qu’il s’agit de données locales.

### Champs attributaires du standard
Les champs attributaires sont suivi d'annotations Niveau 1, 2 ou 3 selon la règle décrite dans le standard:
- Attributs de niveau 1: présence et saisie obligatoires (valeur "inconnu, non renseigné" non autorisée)
- Attributs de niveau 2: présence obligatoire mais saisie factultative
- Attributs de niveau 3: présence et saisie optionnelles

### Champs attributaires hors standard
Des champs supplémentaires sont proposés. Ils ont été annotés car ils ne font pas partie du standard :
- gid: indentifiant système, incrément INTEGER suivant la séquence de la table
- photo: champ textuel pour recevoir des chemins pour le stockage de photos
- commentaire: champ textuel libre
- usr_cre: utilisateur de création de l'objet, remplissage automatique (fonction et trigger)
- usr_mod: utilisateur de modification de l'objet, remplissage automatique (fonction et trigger)
- dat_cre: date de création de l'objet, remplissage automatique (fonction et trigger)
- dat_mod: date de modification de l'objet, remplissage automatique (fonction et trigger)

### Systèmes de projection
Le système de projection par défaut RGF93 v1 / Lambert-93 - France  (SCR EPSG:2154) pour la France hexagonale et la Corse. D'autres systèmes de projection peuvent aisément être utilisés en modifiant le script pour les champs "the_geom" par la valeur EPSG appropriée.

|**Territoire**|<p>**Système de référence géodésique**</p>|<p>**Ellipsoïde associé**</p>|<p>**Représentation plane**</p>|<p>**Système de référence verticale**</p>|<p>**EPSG**</p>|
| :- | :- | :- | :- | :- | :- |
|France hexagonale et Corse|RGF93|IAG GRS 1980|Lambert 93|IGN 1969 (Corse: IGN1978)|2154|
|Guadeloupe|RGAF09|IAG GRS 1980|UTM Nord fuseau 20|IGN 1988|5490|
|Martinique|RGAF09|IAG GRS 1980|UTM Nord fuseau 20|IGN 1987|5490|
|Guyane|RGFG95|IAG GRS 1980|UTM Nord fuseau 22|NGG 1977|2972|
|La Réunion|RGR92|IAG GRS 1980|UTM Sud fuseau 40|IGN 1989|2975|
|Mayotte|RGM04 (compatible WGS84)|IAG GRS 1980|UTM Sud fuseau 38|IGN 1950 / Shom 1953|4471|
|Saint-Pierre-et-Miquelon|RGSPM06 (ITRF2000)|IAG GRS 1980|UTM Nord fuseau 21|Danger 1950|4467|
