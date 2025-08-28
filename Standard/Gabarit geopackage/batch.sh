# !/bin/bash
# Génère le gabarit gpkg à partir :
# - du fichier GPKG vide : gpkg_vide.gpkg
# - du fichier SQL template de génération des tables du standard : standard_cnig_accessibilite.sql

path=<votre répertoire de travail>
-- exemple : path='D:\Park\ATELIER_SQL'

echo "-------------------------------------------------"
echo "Genération du gabarit GPKG à partir du code SQL  "
echo "-------------------------------------------------"

cd "$path"
cp 'gpkg_vide\gpkg_vide.gpkg' gabarit_cnig_accessibilite.gpkg
echo "Copie de gpkg_vide efffectuée"

echo "Exécution du SQL"
"$path\SQLITE\sqlite3.exe" gabarit_cnig_accessibilite.gpkg < script_gabarit_CNIG_Accessibilité.sql
echo "Exécution du SQL : effectuée !"
echo "Appuyer sur Entrée pour continuer..."
read a


