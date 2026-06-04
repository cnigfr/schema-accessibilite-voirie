# Format CNIG Accessibilité

Le **Format CNIG Accessibilité** est un format d’échange de données conforme au [standard CNIG Accessibilité du cheminement en voirie](https://cnig.gouv.fr/IMG/pdf/250314_standard_cnig_accessibilite_v2021-10_rev2025-03-2.pdf) implémenté dans une version SIG au format [GeoPackage](https://www.geopackage.org/spec131/index.html).

Ce module Python permet :

- de générer une implémentation du modèle de données CNIG Accessibilité au format [**GeoPackage**](https://www.geopackage.org/spec131/index.html)
- de migrer des données vers des versions plus récentes du standard CNIG.

Le GeoPackage généré est directement exploitable dans [**QGIS**](https://qgis.org/) ainsi que dans tout autre SIG compatible avec ce format.

### Fichier d’exemple

Un fichier GeoPackage CNIG Accessibilité vide, basé sur la version courante du standard (**v2021-10_rev2025-03**), est disponible [ici](./cnig_accessibilite_v2025.gpkg).

Ce fichier a été généré avec ce module en utilisant la projection par défaut **EPSG:2154**.

### Philosophie du format

Ce format a pour objectif de servir de support d’échange de données conformes au standard CNIG Accessibilité, tout en assurant l’interopérabilité entre les différents outils qui exploitent, créent ou éditent ces données.

Dans cette optique, le format se veut volontairement peu contraignant concernant la vérification et la complétude des données.
En effet, puisqu'il a vocation à faciliter la collecte de données, il autorise les erreurs et le manque de complétude durant la phase de collecte des données.

En conséquence, ni ce module ni les fichiers générés **n’effectuent de contrôle des données, validant à 100% leur conformité**. Aucune vérification de complétude n’est réalisée.

Seules les fonctionnalités suivantes permettent de limiter certaines erreurs de saisie :

- l’intégration des listes de valeurs autorisées
- la génération automatique des identifiants

La validation et le contrôle de conformité des données relèvent d’un validateur dédié, et non du fichier lui-même.

---

## I - Contenu du GeoPackage

### A. Couches spatiales (15)

| Couche | Géométrie | Description |
|---|---|---|
| `noeud_cheminement` | Point | Nœud de cheminement — extrémité d'un tronçon |
| `obstacle` | Point | Obstacle sur le parcours du cheminement |
| `circulation` | LineString | Circulation "normale" "standard", sur une surface régulière |
| `traversee` | LineString | Traversée piétonne |
| `rampe` | LineString | Rampe d'accès |
| `escalier` | LineString | Escalier |
| `escalator` | LineString | Escalier mécanique |
| `tapis_roulant` | LineString | Tapis roulant |
| `ascenseur` | Point | Ascenseur |
| `elevateur` | Point | Élévateur / plate-forme élévatrice |
| `entree` | Point | Entrée de site ou de bâtiment ERP |
| `passage_selectif` | Point | Passage sélectif ou chicane |
| `quai` | LineString | Quai d'arrêt de transport en commun |
| `stationnement_pmr` | Point | Place de stationnement réservée PMR en voirie |
| `erp` | MultiPolygon | Établissement recevant du public |

**Choix "à plat"** :

Dans le modèle conceptuel du standard, les équipements d’accès linéaires (traversée, rampe, escalier, etc.) sont modélisés comme des spécialisations de `TRONCON_CHEMINEMENT`, reliées par une relation 1:1. Idem pour les équipements d'accès ponctuels (entree, passage sélectif, etc.).

Afin d’éviter les jointures dans les SIG et de limiter les risques susceptibles de compromettre l’intégrité de la base de données, leurs attributs sont directement intégrés dans chaque couche, qui dispose également de sa propre géométrie.

### B. Automatismes

Ce GeoPackage embarque des automatismes pour remplir et contraindre certains attributs.

**1. Identifiants de classe** :

Les identifiants CNIG prennent la forme `[CODESPACE]:[CodeClasse]:[IdentifiantTechnique]:LOC`.
Toutefois, dans ce format d’échange, la partie `[CODESPACE]`, correspondant au code INSEE de la commune associée à la donnée, devient optionnelle afin de permettre la génération automatique des identifiants, quel que soit le territoire dans un même fichier.

Le format d’identifiant généré est alors le suivant : `[CodeClasse]:[IdentifiantTechnique]:LOC`
- *CodeClasse* : code dépendant de la classe d'objet (ex : nœud de cheminement → *NOD*)
- *fid* : identifiant interne de l'objet généré par le GeoPackage

Ce mécanisme de génération automatique s’active lors de l’insertion d’un objet, si aucun identifiant n’est déjà renseigné.

Aucun contrôle n’est effectué sur le format des identifiants CNIG.
Il est donc possible de modifier ultérieurement un identifiant, notamment en ajoutant la partie `[CODESPACE]`.


**2. Listes de valeurs** :

Les listes de valeurs (types énumérés) sont décrites dans le GeoPackage (`gpkg_data_columns`, `gpkg_data_column_constraints`).

Chaque liste intègre les valeurs *NC* et *sans objet*.

**3. Valeurs contraintes** :

Les attributs non énumérés peuvent être contraints par une expression régulière. L'insertion d'une valeur ne respectant pas la contrainte définie est rejetée.

Exemple :
- L'attribut *voiesTraversees* est limité aux codes *B*, *C*, *V*, *T*. Une valeur contenant un autre caractère ne peut pas être enregistrée.

---

## II - Actualisations et contributions

| Versions du standard supportées |
|:---|
| version courante `v2025-03` |
| version en discussion `v2026-04` |


Nous vous invitons à partager tous les problèmes rencontrés et vos idées d'améliorations en ouvrant un nouveau ticket.

---

## III - Installation et utilisation

L'installation et la documentation technique du module est décrite [ici](./setup.md).
