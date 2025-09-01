# Gabarit géopackage

Le [gabarit CNIG Accessibilité au format Géopackage](https://github.com/cnigfr/schema-accessibilite-voirie/blob/main/Standard/Gabarit%20geopackage/gabarit_cnig_accessibilite.gpkg) est utilisable dans QGIS et tout SIG supportant le format Géopackage. 

Il est conforme au [Standard CNIG Accessibilité du cheminement en voirie](https://cnig.gouv.fr/ressources-accessibilite-a25335.html) et maintenu par le GT CNIG Accessibilité.

Il est utilisable dans le système de projection Lambert 93 (SRS 2154) pour la France Métropolitaine et la Corse. D'autres systèmes de pojection peuvent aisément être utilisés en modifiant le script SQL.

## Comment a-t-il été réalisé ?

Il a été réalisé avec :
- la [spécification](https://github.com/cnigfr/schema-accessibilite-voirie/blob/main/Standard/Gabarit%20geopackage/sp%C3%A9cification_gabarit_CNIG_Accessibilit%C3%A9.md) du gabarit 
- le [script SQL](https://github.com/cnigfr/schema-accessibilite-voirie/blob/main/Standard/Gabarit%20geopackage/script_gabarit_CNIG_Accessibilit%C3%A9.sql) qui requiert l'installation préalable de [SQLite](https://www.sqlite.org/about.html), outil de gestion de base SQL. _(Solution alternative : [DBeaver](https://dbeaver.io/download/))_
- le [batch](https://github.com/cnigfr/schema-accessibilite-voirie/blob/main/Standard/Gabarit%20geopackage/batch.sh) permettant d'exécuter le script SQL
  - _Comment [utiliser Git Bash sous Windows](https://sps--lab-org.translate.goog/post/2024_windows_bash/?_x_tr_sl=en&_x_tr_tl=fr&_x_tr_hl=fr&_x_tr_pto=rq) pour exécuter des scripts Bash avec PowerShell_
  - Pour lancer le batch :
    > - Win+X Terminal (administrateur)   _(ou : WIN+X puis tapez a)_
    > - cd  <votre répertoire de travail>   , _(par exemple :   cd D:\ATELIER_SQL)_
    > - Set-Alias -Name bash -Value "<votre répertoire de travail>\GIT\PortableGit\git-bash.exe"
    > - Set-Alias -Name sqlite3 -Value "<votre répertoire de travail>\SQLITE\sqlite3.exe"
    > - bash -c "./batch.sh" 

## Commnent l'intégrer dans QGIS ?

- Lancer QGIS
- Dans Explorateur / Géopackage, choisir "Nouvelle connexion" avec le fichier [gabarit_cnig_accessibilite.gpkg](https://github.com/cnigfr/schema-accessibilite-voirie/blob/main/Standard/Gabarit%20geopackage/gabarit_cnig_accessibilite.gpkg) _(download raw file)_
 - Sélectionner les tables (par exemple celles portant de la géométrie) et les déplacer dans la liste des couches.
   - Alternative : on peut directement glisser/déposer le fichier dans la fenêtre QGIS, mais les noms des tables et couches sont alors préfixés par « gabarit_cnig_accessibilite -- »

## Commnent l'ouvrir dans DBeaver ?
- Lancer DBeaver
- Nouvelle connexion (CTRL+MAJ+N), choisir SQLite, puis ouvrir le fichier [gabarit_cnig_accessibilite.gpkg](https://github.com/cnigfr/schema-accessibilite-voirie/blob/main/Standard/Gabarit%20geopackage/gabarit_cnig_accessibilite.gpkg) _(download raw file)_
- Vous pouvez ensuite déplier l'arborescence du Géopackage et cliquer-droit sur chaque table pour vérifier sa structure, son contenu, les clés étrangères, etc.

































