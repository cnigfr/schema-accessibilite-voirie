# Gabarit géopackage

Le gabarit CNIG Accessibilité au format Géopackage est utilisable dans QGIS et tout SIG supportant le format Géopackage. 

Il est conforme au [Standard CNIG Accessibilité du cheminement en voirie](https://cnig.gouv.fr/ressources-accessibilite-a25335.html) et maintenu par le GT CNIG Accessibilité.

Il est utilisable dans le système de projection Lambert 93 (SRS 2154) pour la France Métropolitaine et la Corse.

Ce répertoire contient :
- la [spécification](https://github.com/cnigfr/schema-accessibilite-voirie/blob/main/Standard/Gabarit%20geopackage/250828_sp%C3%A9cification_gabarit_CNIG_Accessibilit%C3%A9.md) du gabarit 
- le [script SQL](https://github.com/cnigfr/schema-accessibilite-voirie/blob/main/Standard/Gabarit%20geopackage/script_gabarit_CNIG_Accessibilit%C3%A9.sql), qui nécessite :
  - le "[géopackage vide](https://github.com/cnigfr/schema-accessibilite-voirie/blob/main/Standard/Gabarit%20geopackage/gpkg_vide_from_QGIS.gpkg)" (base SQL de départ, complétée par le script SQL)
  - [SQLite](https://www.sqlite.org/about.html), outil permetant de gestion de base SQL
- le [batch](https://github.com/cnigfr/schema-accessibilite-voirie/blob/main/Standard/Gabarit%20geopackage/batch.sh) permettant d'exécuter le script SQL
  - Comment [utiliser Git Bash sous Windows](https://sps--lab-org.translate.goog/post/2024_windows_bash/?_x_tr_sl=en&_x_tr_tl=fr&_x_tr_hl=fr&_x_tr_pto=rq) pour exécuter des scripts Bash avec PowerShell 
- la page de téléchargement du [gabarit CNIG Accessibilité au format Géopackage](https://github.com/cnigfr/schema-accessibilite-voirie/blob/main/Standard/Gabarit%20geopackage/gabarit_cnig_accessibilite.gpkg)

















