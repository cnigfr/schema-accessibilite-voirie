# **Format d’échange des données**

## **1. Généralités**
Le modèle conceptuel de données, le catalogue d’objets, les règles de saisie des données et des métadonnées présentés dans les parties précédentes sont traduits en un format d’échange des données basé sur le format standardisé [GeoPackage.](https://fr.wikipedia.org/wiki/Geopackage)

Le format d’échange des données d‘accessibilité du cheminement en voirie et espace public défini à la fois :
- la forme et les exigences d’échange et/ou livraison des données collectées et produites conformément au standard CNIG Accessibilité ;
- le point d’entrée de la chaîne de conversion et de diffusion des données de cheminement suivant la norme NeTEx en se conformant au [profil NeTEx accessibilité France](https://normes.transport.data.gouv.fr/normes/netex/accessibilite/).

### 1.1 **Format GeoPackage**
GeoPackage est un format standard défini par l'[OGC](https://www.ogc.org/standards/geopackage/) (Open Geospatial Consortium).

Il s’agit d’un format ouvert, indépendant de toute plateforme et autodescriptif pour échanger de l'information géographique.

Il est largement adopté par les outils SIG libres et commerciaux et définit à ce titre un format « pivot » entre les SIG et autres systèmes d’informations.

Il s'appuie sur le format de fichier de base de données [SQLite](https://sqlite.org/fileformat2.html) pour décrire des tables de données et de métadonnées pour lesquelles il définit un ensemble de conventions.

### 1.2 **Versions de GeoPackage supportées**
À la date de rédaction de ce document, la version la plus récente du standard GeoPackage est la v1.3.1 datant de 2021. Les versions précédentes sont maintenues et reposent sur la version 3 du format SQLite. Elles sont toutes compatibles avec les exigences définies ci-dessous pour l’échange des données conformes au standard CNIG Accessibilité.

Les échanges des données conformes au standard CNIG Accessibilité se font au format GeoPackage dans les versions supérieures ou égales à 1.1

## 2. **Contenu de la livraison**
Le modèle physique implémenté avec GeoPackage est un modèle de données relationnel à l'instar de SQLite sur lequel il s'appuie. De ce fait, l'implémentation des données proposées pour la livraison se fera sous forme de tables :
- les tables intrinsèques au format GeoPackage, décrites ci-dessous ;
- les tables implémentant les données du standard CNIG Accessibilité.
  
La granularité d'un lot de données correspond à une campagne de collecte et de production de données du cheminement accessible en voirie.

Une livraison comprend l'ensemble des tables définies dans le standard CNIG Accessibilité et listées dans ce document.

Des gabarits au format GeoPackage implémentant la stucture des tables décrites par ce standard seront disponibles sur le dépôt [Github du standard CNIG Accessibilité](https://github.com/cnigfr/schema-accessibilite-voirie) et sur [le site du CNIG](https://cnig.gouv.fr/ressources-accessibilite-a25335.html).

### 2.1 **Nom du fichier de livraison**
Afin de normaliser et d'identifier les fichiers de livraisons entre eux, le nommage de fichiers de livraison s'appuie sur la désignation du territoire concerné et la date de production ou livraison.

La livraison des données conformes au standard et au format GeoPackage se fait sous la forme d'un unique fichier comprenant les données et les métadonnées.

Le nom du fichier GeoPackage est composé en lettres minuscules sans accent selon le modèle :

**<INSEE/SIREN>\_accessibilite\_voirie\_AAAAMMJJ.gpkg**
- INSEE correspond au code INSEE de la commune concernée.\
  Il est remplacé par le code SIREN de l’EPCI dans le cas d’une emprise intercommunale.
- AAAAMMJJ correspond à la date de production du fichier géopackage. Par exemple : 20250507 pour le 7 mai 2025
- l'extension de fichier est celle du format GeoPackage : .gpkg

Exemple : **44300\_accessibilite\_voirie\_20250507.gpkg**

## 3. **Tables intrinsèques à GeoPackage**
Le format GeoPackage définit un certain nombre de tables "système" qui lui permettent d'organiser les données de façon structurée et dont le caractère obligatoire ou non de leur implémentation dépend du type de données échangées et de leur utilisation.

Ce schéma, issu de GeoPackage v1.3.1, illustre la structure des tables intrinsèques à ce format :
<img width="873" height="783" alt="schema_classes_gpkg" src="https://github.com/user-attachments/assets/cf0bdedf-e20d-4602-abaa-874ddf893710" />

Les trois tables `gpkg\_contents`, `gpkg\_geometry\_columns` et `gpkg\_spatial\_ref\_sys` permettent de décrire les tables de données « accessibilité » du GeoPackage et d'en gérer l'aspect géographique.

Les deux tables `gpkg\_metadata` et `gpkg\_metadata\_reference` permettent d'associer des informations de métadonnées.

Les métadonnées décrites au §4.5 Métadonnées du Standard CNIG Accessibilité peuvent ainsi intégrer le fichier GeoPackage.

### 3.1 **Table gpkg\_contents**
La table gpkg\_contents est définie dans [les spécifications du format GeoPackage](https://www.geopackage.org/spec131/#_contents).

Il s’agit de la table dictionnaire des tables de données (hors tables "systèmes") présentes dans l’échange de données. Elle liste l'ensemble de ces tables en indiquant pour chacune :
- son nom (table\_name) ;
- son type de données (data\_type), à savoir vecteur (features), raster (tiles) ou tabulaire sans géométrie (attributes) ;
- un identifiant (identifier) ;
- sa description optionnelle (description) ;
- la date de dernière modification (last\_change) ;
- l'emprise géographique de la table (si elle est de type vecteur ou raster) : min\_x, min\_y, max\_x, max\_y ;
- l'identifiant du système de coordonnées pour la géométrie s'il y en a une (srs\_id) indiqué dans la table [gpkg_spatial_ref_sys.srs_id](#table-gpkg_spatial_ref_sys).

L’échange des données au format GeoPackage contient obligatoirement la table gpkg\_contents conforme à la structure du format GeoPackage qui liste l'ensemble des tables du standard CNIG Accessibilité présentes dans la livraison.

### 3.2 **Table gpkg\_geometry\_columns**
La table gpkg\_geometry\_columns est une table définie dans [les spécifications du format GeoPackage](https://www.geopackage.org/spec131/#_gpkg_geometry_columns) qui identifie les colonnes portant la géométrie ainsi que leur type dans les tables de données de type features du GeoPackage.

Pour chacune d'elle, elle permet de préciser :
- son nom (table\_name) ;
- le nom de la colonne portant la géométrie pour cette table (column\_name) ;
- le type de géométrie porté par cette colonne (geometry\_type\_name) ;
- l'identifiant du système de coordonnées pour cette géométrie (srs\_id) indiqué dans la table [gpkg_spatial_ref_sys.srs_id](#table-gpkg_spatial_ref_sys) ;
- une valeur entière indiquant si la géométrie peut comporter une composante altimétrique (z) ;
- une valeur entière indiquant si la géométrie peut comporter une composante temporelle (m).

Remarque : Les tables de la livraison listées dans la table gpkg\_geometry\_columns conformes au standard CNIG Accessibilité n'ont pas de composante altimétrique (car l’altitude des nœuds de cheminement n’est pas portée par leur géométrie mais par l’attribut « altitude »), ni de composante temporelle. Les valeurs de z et m pour ces tables sont donc égales à 0.

### 3.3 **Table gpkg\_spatial\_ref\_sys**
La table gpkg\_spatial\_ref\_sys est une table définie dans [les spécifications du format GeoPackage](https://www.geopackage.org/spec131/).

Elle liste l'ensemble des systèmes de coordonnées et leurs définitions sur lesquels s'appuient les géométries des tables de données de type features du GeoPackage.

Pour chacun des systèmes de coordonnées déclarés et décrits au § 3.1 Système de référence spatial, elle permet de préciser :

- un nom lisible par une personne (srs\_name) ;
- un identifiant unique pour de ce système de coordonnées (clef primaire) dans le GeoPackage (srs\_id) ;
- le nom de l'organisation qui définit ce système de coordonnées (organization) ;
- l'identifiant numérique de ce système de coordonnées pour cette organisation (organization\_coordsys\_id) ;
- la définition au format WKT de ce système de coordonnées (definition) ;
- Une description textuelle lisible par un être humain de ce système de coordonnées (description).

La présence de cette table dans un fichier GeoPackage est obligatoire.

### 3.4 **Table gpkg\_metadata**
La table gpkg\_metadata est une table définie dans [les spécifications du format GeoPackage](https://www.geopackage.org/spec131/#metadata_table_table_definition) qui permet d'associer un ensemble d'éléments de métadonnées à différents éléments du fichier GeoPackage. Pour chaque ensemble d'éléments de métadonnées elle permet de préciser :
- un identifiant unique (clef primaire) de cet ensemble d'éléments (id) ;
- le niveau hiérarchique de cet ensemble d'éléments (md\_scope) ;
- l'URI correspondant au formalisme de métadonnées utilisé pour ces éléments (md\_standard\_uri) ;
- le type MIME correspondant à l'encodage de ces ensembles d'éléments de métadonnées (mime\_type) ;
- l'implémentation de cet ensemble d'éléments de métadonnées (metadata).

La livraison en GeoPackage des données conformes au standard CNIG Accessibilité doit contenir une table gpkg\_metadata qui contient à minima une ligne correspondant aux éléments de métadonnées du jeu de données constituant la livraison telle que décrite au §4.5 Métadonnées.

### 3.5 **Table gpkg\_metadata\_reference**
La table gpkg\_metadata\_reference est une table définie dans [les spécifications du format GeoPackage](https://www.geopackage.org/spec131/#metadata_table_table_definition) qui permet de lier les éléments de métadonnées présents dans la table gpkg\_metadata avec les données de la livraison qu'ils décrivent en fonction de leur niveau de granularité (ou domaine d'application) et d'établir une hiérarchie entre eux.
Pour chacun de ces éléments, elle permet de préciser :
- le domaine d'application de l'ensemble des éléments de métadonnées (reference\_scope) ;
- éventuellement le nom de la table qui est référencée par ces métadonnées (table\_name) ;
- éventuellement le nom de la colonne de la table mentionnée précédemment qui est référencée par ces métadonnées (column\_name) ;
- éventuellement la valeur de l'identifiant d'un objet (ligne) de la table mentionnée précédemment qui est référencée par ces métadonnées (row\_id\_value) ;
- l’horodatage de cet élément (timestamp) ;
- l'identifiant de l'ensemble des éléments de métadonnées dans la table gpkg\_metadata (clef étrangère) auquel s'applique cet élément (md\_file\_id) ;
- l'identifiant de l'ensemble des éléments de métadonnées parent (clef étrangère) dans la table gpkg\_metadata (md\_file\_id).

La présence de cette table dans un fichier GeoPackage est facultative mais devient obligatoire lorsqu’une une table gpkg\_metadata est présente.

La livraison en GeoPackage des données conformes au standard CNIG Accessibilité doit contenir une table gpkg\_metadata\_reference qui contient à minima une ligne correspondant aux éléments de métadonnées du jeu de données constituant la livraison telle que décrite au §4.5 Métadonnées.

## 4. **Tables des données d’accessibilité**
La livraison en GeoPackage implique une implémentation du §3.2 Modèle conceptuel de données et du §3.3 Catalogue d’objets en modèle relationnel sous forme de tables.

Cette partie les décrit en s'appuyant sur le formalisme et les types définis par le format GeoPackage.

### 4.1 **Nomenclature des tables**
Les noms des tables intègrent des éléments d'identification du lot des données.
Ces noms sont écrits intégralement en minuscules, ce qui évite d’avoir à les mettre entre quotes ( " ) lorsqu'on les manipule dans des systèmes comme PostgreSQL.

### 4.2 **Dictionnaire des tables**
Le tableau suivant liste l'ensemble des tables faisant partie de la livraison en précisant :
- le nom de la table : valeur de table\_name dans la table **gpkg\_contents** ;
- le type de table selon la nomenclature de GeoPackage (valeur de l’attribut data\_type dans la table **gpkg\_contents**) ;
- le type de Géométrie de la table dans la nomenclature de GeoPackage (valeur de l’attribut geometry\_type\_name dans la table **gpkg\_geometry\_columns**) ;
- les références aux entités du modèle conceptuel implémentées par la table.
Les tables du standard présentes dans la livraison doivent être déclarées dans la table **gpkg\_contents** avec le type de table indiqué dans le tableau suivant.
Les tables ayant pour type features doivent également être déclarées dans la table **gpkg\_geometry\_columns** avec le type de géométrie indiqué dans le tableau suivant.
Remarque : Toutes les tables sont obligatires. Un lot de données ne comprenant pas de passages sélectifs comprendra bien la table **passage\_selectif** mais vide (aucun enregistrement à l’intérieur de la table)

|**Nom de la table**|<p>**Type de table**</p><p>**(GPKG)**</p>|<p>**Type de**</p><p>**géométrie**</p>|**Classes d’objets implémentées**|
| :- | :- | :- | :- |
|**gpkg\_contents**|Tables ‘systèmes’ propres au format GPKG|aucune|table dictionnaire des tables (hors tables "systèmes")|
|**gpkg\_geometry\_columns**||aucune|table identifiant les attributs de type géométrie|
|**gpkg\_spatial\_ref\_sys**||aucune|table des systèmes de coordonnées pour les géométries|
|**gpkg\_metadata**||aucune|table des éléments de métadonnées|
|**gpkg\_metadata\_reference**||aucune|table référençant la table des éléments de métadonnées|

### 4.3 **Tables correspondant aux classes d’objets**

|**cheminement**|attributes|aucune|
| :- | :- | :- |
|**troncon\_cheminement**|features|LINESTRING|
|**nœud\_cheminement**|features|POINT|
|**obstacle**|features|POINT|
|**circulation**|attributes|aucune|
|**traversee**|attributes|aucune|
|**rampe\_acces**|attributes|aucune|
|**escalier**|attributes|aucune|
|**escalator**|attributes|aucune|
|**tapis\_roulant**|attributes|aucune|
|**ascenseur**|attributes|aucune|
|**elevateur**|attributes|aucune|
|**entree**|attributes|aucune|
|**passage\_selectif**|attributes|aucune|
|**quai**|attributes|aucune|
|**stationnement\_pmr**|features|POINT|
|**erp**|features|POLYGON|
|**cheminement\_erp**|attributes|aucune|

### 4.4 **Description des tables**
Chaque table correspondant à une classe d’objets reprend la structure définie au §3.3 Catalogue d’objets.

### 4.5 **Noms des attributs**
Les noms des attributs sont identiques à ceux du catalogue d’objet.
Leur graphie est en minuscules et sans caractère accentué ni cédille.

### 4.6 **Couches géométriques**
L’attribut « geom » est ajouté en dernière position aux classes porteuses de géométrie (features) listées ci-dessus.
Exemple sur la classe troncon_cheminement :

|idtroncon|
| :- |
|from|
|to|
|longueur|
|typetroncon|
|statutvoie|
|pente|
|devers|
|geom|

l’attribut « geom » est ajouté en dernière position.

### 4.7 **Type des attributs**
Le type Géopackage des attributs respecte la nomenclature GeoPackage et est établi en suivant ce tableau de correspondance :

|Type dans le catalogue d’objet|Type Géopackage|
| :- | :- |
|identifiant|TEXT|
|string|TEXT|
|string(n)|TEXT(n)|
|entier|INTEGER|
|entier relatif|TYNYINT|
|décimal(n)|REAL|
|booléen|BOOLEAN|
|url|TEXT|
|date|DATE|
|*(geom) géométrie linéaire*|LINESTRING|
|*(geom) géométrie ponctuelle*|POINT|
|*(geom) géométrie surfacique*|POLYGON|

### 4.8 **Admission de la valeur “NULL”**
Le §3.3 Catalogue d’objets présente trois niveaux d’attributs :

1. Les attributs obligatoirement présents dont le renseignement est obligatoire. Ces attributs sont désignés **en gras**. Pour ces attributs :
   - la valeur NULL n’est pas admise. Ces attributs sont désignés NOT NULL
   - s’il s’agit d’un attribut à liste de valeurs (ou énumération), la valeur conventionnelle NC exprimant « inconnu, non renseigné » n’est pas admise.
1. Les attributs obligatoirement présents mais dont le renseignement est facultatif. Ces attributs sont désignés en style normal. Ils portent la mention "valeur vide autorisée".
   - s’il ne s’agit pas d’un attribut à liste de valeurs, la valeur NULL est admise
   - s’il s’agit d’un attribut à liste de valeurs, la valeur NULL n’est pas admise et remplacée par la valeur conventionnelle NC exprimant « inconnu, non renseigné », sauf si le Catalogie d’objets indique « valeur NC non autorisée ». Dans ce cas une valeur « signifiante » doit être choisie parmi les autres valeurs de la liste de valeurs.
1. Les attributs optionnels. Leur présence et leur renseignement sont facultatifs. Ces attributs sont désignés *en italique*.
   - ces attributs peuvent être absents de la table concernée
   - s’ils sont présents, la valeur NULL est admise

### 4.9 **Contraintes ou restrictions sur les valeurs d’attributs**
On respectera les contraintes définies pour chaque attribut dans le §3.3 Catalogie d’objet.
Il s’agit notamment des mentions :
- « valeur NC non autorisée » (dans le cas d’une liste de valeurs),
- « valeur vide autorisée » (comprendre : valeur null autorisée, cf. ci-dessus)
- des valeurs d’attributs conditionnées par la valeur d’un autre attribut de la même table

### 4.10 **Clés primaires**
Le premier attribut de chaque table est son identifiant : id<classe>. Cet attribut correspond à la clé primaire de la table relationnelle :

|**Classe**|**Clé primaire**|
| :- | :- |
|**cheminement**|idcheminement|
|**troncon\_cheminement**|idtroncon|
|**noeud\_cheminement**|idnoeud|
|**obstacle**|idobstacle|
|**circulation**|idcirculation|
|**traversee**|idtraversee|
|**rampe\_acces**|idrampe|
|**escalier**|idescalier|
|**escalator**|idescalator|
|**tapis\_roulant**|idtapisroulant|
|**ascenseur**|idascenseur|
|**elevateur**|idelevateur|
|**entree**|identree|
|**passage\_sélectif**|idpassageselectif|
|**quai**|idquai|
|**stationnement\_pmr**|idstationnement|
|**erp**|iderp|
|**cheminement\_erp**|idcheminementerp|

### 4.11 **Tables correspondant aux listes de valeurs énumérées**

|**enum\_categorie\_erp**|attributes|aucune|
| :- | :- | :- |
|**enum\_controle\_acces**|attributes|aucune|
|**enum\_controle\_bev**|attributes|aucune|
|**enum\_cote**|attributes|aucune|
|**enum\_couvert**|attributes|aucune|
|**enum\_dispositif\_signalisation**|attributes|aucune|
|**enum\_eclairage**|attributes|aucune|
|**enum\_etat**|attributes|aucune|
|**enum\_etat\_revetement**|attributes|aucune|
|**enum\_marquage**|attributes|aucune|
|**enum\_masque\_covisibilite**|attributes|aucune|
|**enum\_personnel\_erp**|attributes|aucune|
|**enum\_position\_espace**|attributes|aucune|
|**enum\_position\_hauteur**|attributes|aucune|
|**enum\_position\_obstacle**|attributes|aucune|
|**enum\_rampe\_erp**|attributes|aucune|
|**enum\_rappel\_obstacle**|attributes|aucune|
|**enum\_relief\_boutons**|attributes|aucune|
|**enum\_repere\_lineaire**|attributes|aucune|
|**enum\_sens**|attributes|aucune|
|**enum\_statut\_voie**|attributes|aucune|
|**enum\_temporalite**|attributes|aucune|
|**enum\_transition**|attributes|aucune|
|**enum\_type\_passage**|attributes|aucune|
|**enum\_type\_poignee**|attributes|aucune|
|**enum\_type\_porte**|attributes|aucune|
|**enum\_type\_troncon**|attributes|aucune|
|**enum\_type\_entree**|attributes|aucune|
|**enum\_type\_erp**|attributes|aucune|
|**enum\_type\_obstacle**|attributes|aucune|
|**enum\_type\_ouverture**|attributes|aucune|
|**enum\_type\_stationnement**|attributes|aucune|
|**enum\_type\_sol**|attributes|aucune|
|**enum\_voyant\_ascenseur**|attributes|aucune|

### 4.12 **Tables correspondant aux relations entre les classes d’objets**
Les relations entre les classes d'objets, décrites au §3.4 Relations entre les classes d’objets, se traduisent pour les relations de cardinalité [1..n] (soit : 1 à plusieurs) par l’intégration d’attributs désignant des [clés étrangères](https://fr.wikipedia.org/wiki/Clé_étrangère) (fk pour « foreign key ») dans les tables.

#### 4.12.1 **Relation entre troncon\_cheminement et nœud\_cheminement**
La relation topologique *« est nœud initial / final »* se traduit par la présence des attributs from et to comme clé étrangères dans la table troncon\_cheminement.

|**troncon\_cheminement**||
| :- | :- |
|idtroncon|clé primaire de la table  troncon\_cheminement|
|from|clé étrangère issue de la table nœud\_cheminement|
|to|clé étrangère issue de la table nœud\_cheminement|
|*<attributs suivants de la table troncon\_cheminement...>*||
|geom|géométrie linéaire du troncon\_cheminement|

#### 4.12.2 **Relations « 1 à (0 ou 1) »**
Il s’agit des relations de correspondance entre :
a) un tronçon de cheminement et une circulation
b) ou (ou exclusif) un tronçon de cheminement et un équipement d’accès linéaire
c) un nœud de cheminement et un équipement d’accès ponctuel ou un stationnement\_pmr
Ces relations se traduisent par :
a-b) la présence de l’attribut idtroncon comme clé étrangère et les attributs  de la table troncon\_cheminement dans la table circulation et dans les tables correspondant à des équipements d’accès linéaires : traversee ; rampe\_acces ; escalier ; escalator ; tapis\_roulant ; quai

|**traversee**||
| :- | :- |
|idtraversee|clé primaire de la table|
|idtroncon|clé étrangère issue de la table troncon\_cheminement|
|*<attributs  de la table troncon\_cheminement...>*||
|*\<attributs de la table traversee...\>*||
|*geom*|géométrie du tronçon de cheminement|

c) le même principe est adopté dans les tables correspondant à des équipements d’accès ponctuels ou un stationnement\_pmr :

|**ascenseur**||
| :- | :- |
|idascenseur|clé primaire de la table|
|idnoeud|clé étrangère issue de la table noeud\_cheminement|
|*<attributs de la table noeud\_cheminement...>*||
|*\<attributs de la table ascenseur...\>*||
|*geom*|géométrie du noeud de cheminement|

#### 4.12.3 **Relations « 1 à n »**
Il s’agit des relations « 1 à plusieurs », par exemple la relation : [troncon_cheminement (1,1) comporte obstacle (0,n)](#tableau45|table), que l’on peut traduire par : *« un tronçon de cheminement comporte aucun, un ou plusieurs obstacles, et un obstacle se situe sur un tronçon de cheminement et un seul »*
Dans ce cas, l’identifiant de la classe mettant en relation 1 élément au maximum devient clé étrangère de la classe mettant en relation potentiellement plusieurs éléments.
Dans cet exemple : idtroncon devient clé étrangère dans la table obstacle :

|**obstacle**||
| :- | :- |
|idobstacle|clé primaire de la table|
|idtroncon|clé étrangère issue de la table troncon\_cheminement|
|*<attributs suivants de la table obstacle...>*||
|geom|géométrie ponctuelle de l’obstacle|

On adoptera le même principe pour les relations de cardinalité « 1 à plusieurs » :
\- troncon\_cheminement (1,1) comporte obstacle (0,n),
\- ERP (1,1) dispose de CHEMINEMENT\_ERP (0,n)
etc.

#### 4.12.4 **Relations « n à m »**
Il s’agit des relations « plusieurs à plusieurs », que l’on retrouve dans :
- la relation d’association entre les cheminements et les tronçons qui les composent : « Un cheminement est composé de plusieurs tronçons de cheminement, mais un tronçon de cheminement peut également appartenir à plusieurs cheminements. »
- la relation d’association entre nœud de cheminement et stationnement PMR
- la relation d’association entre une entrée et un ERP
Ces relations impliquent la création de trois tables relationnelles spécifiques :

|**relation\_cheminement\_troncon**||
| :- | :- |
|idcheminement|clé étrangère issue de la table cheminement|
|idtroncon|clé étrangère issue de la table troncon\_cheminement|


|**relation\_noeud\_stationnement**||
| :- | :- |
|idnoeud|clé étrangère issue de la table noeud\_cheminement|
|idstationnement|clé étrangère issue de la table stationnement|


|**relation\_entree\_erp**||
| :- | :- |
|identree|clé étrangère issue de la table noeud\_cheminement|
|iderp|clé étrangère issue de la table stationnement|

## 5. **Tables de métadonnées**
Les éléments de métadonnées du lot de données formatées en GeoPackage sont à renseigner par une ligne dans la table gpkg\_metadata et une ligne dans la table gpkg\_metadata\_reference, de la manière suivante :

### 5.1 **Table gpkg\_metadata**

|**gpkg\_metadata**||
| :- | :- |
|id|1|
|md\_scope|dataset|
|md\_standard\_uri|http://www.isotc211.org/2005/gmd|
|mime\_type|text/xml|
|metadata|Contenu des métadonnées implémenté en XML suivant le §4.5 Métadonnées|

### 5.2 **Table gpkg\_metadata\_reference**

|**gpkg\_metadata\_reference**||
| :- | :- |
|reference\_scope|'geopackage'|
|table\_name|NULL|
|column\_name|NULL|
|row\_id\_value|NULL|
|timestamp|< date AAAAMMJJ de production des métadonnées >|
|md\_file\_id|1 (identifiant des métadonnées dans la table gpkg\_metadata)|
|md\_parent\_id|NULL|
