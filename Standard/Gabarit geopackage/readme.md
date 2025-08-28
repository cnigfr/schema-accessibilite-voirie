# Gabarit géopackage

Le [gabarit CNIG Accessibilité au format Géopackage](https://github.com/cnigfr/schema-accessibilite-voirie/blob/main/Standard/Gabarit%20geopackage/gabarit_cnig_accessibilite.gpkg) est utilisable dans QGIS et tout SIG supportant le format Géopackage. 

Il est conforme au [Standard CNIG Accessibilité du cheminement en voirie](https://cnig.gouv.fr/ressources-accessibilite-a25335.html) et maintenu par le GT CNIG Accessibilité.

Il est utilisable dans le système de projection Lambert 93 (SRS 2154) pour la France Métropolitaine et la Corse. Les autres système de pojection peuvent être utilisés en modiiant le script

## Comment a-t-il été réalisé ?

Il a été réalisé avec :
- la [spécification](https://github.com/cnigfr/schema-accessibilite-voirie/blob/main/Standard/Gabarit%20geopackage/250828_sp%C3%A9cification_gabarit_CNIG_Accessibilit%C3%A9.md) du gabarit 
- le [script SQL](https://github.com/cnigfr/schema-accessibilite-voirie/blob/main/Standard/Gabarit%20geopackage/script_gabarit_CNIG_Accessibilit%C3%A9.sql), qui nécessite pour être exécuté :
  - le "[géopackage vide](https://github.com/cnigfr/schema-accessibilite-voirie/blob/main/Standard/Gabarit%20geopackage/gpkg_vide_from_QGIS.gpkg)" _(base SQL de départ qui va être complétée par le script SQL)_
  - l'installation préalable de [SQLite](https://www.sqlite.org/about.html), outil de gestion de base SQL. _(Solution alternative : [DBeaver](https://dbeaver.io/download/))_
- le [batch](https://github.com/cnigfr/schema-accessibilite-voirie/blob/main/Standard/Gabarit%20geopackage/batch.sh) permettant d'exécuter le script SQL
  - _Comment [utiliser Git Bash sous Windows](https://sps--lab-org.translate.goog/post/2024_windows_bash/?_x_tr_sl=en&_x_tr_tl=fr&_x_tr_hl=fr&_x_tr_pto=rq) pour exécuter des scripts Bash avec PowerShell_

## Commnent l'intégrer dans QGIS ?

- Lancer QGIS
- Dans Explorateur / Géopackage, choisir "Nouvelle connexion" avec le fichier [gabarit_cnig_accessibilite.gpkg](https://github.com/cnigfr/schema-accessibilite-voirie/blob/main/Standard/Gabarit%20geopackage/gabarit_cnig_accessibilite.gpkg) (download raw file)
 - Sélectionner les tables (par exemple celles portant de la géométrie) et les déplacer dans la liste des couches.
  - Alternative : on peut directement glisser/déposer le ficier dans la fenêtre QGIS, mais les noms des tables et couches sont alors préfixés par « gabarit_cnig_accessibilite -- »

























