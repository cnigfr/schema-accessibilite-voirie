# !/bin/bash
# Génère le gabarit gpkg à partir :
# - du fichier GPKG vide : gpkg_vide.gpkg
# - du fichier SQL template de génération des tables du standard : standard_cnig_accessibilite.sql

path='D:\Park\ATELIER_SQL'

echo "-------------------------------------------------"
echo "Genération du gabarit GPKG à partir du code SQL  "
echo "-------------------------------------------------"

cd "$path"

# PRODUCTION
# echo "Copie de gpkg_vide efffectuée"
# echo "Exécution du SQL de production"
# "$path\SQLITE\sqlite3.exe" gabarit_cnig_accessibilite.gpkg < script_gabarit_CNIG_Accessibilité.sql
# echo "Exécution du SQL de PRODUCTION : effectuée !"

# TEST
echo "Exécution du SQL de TEST"
"$path\SQLITE\sqlite3.exe" gabarit_cnig_accessibilite_TEST.gpkg < script_gabarit_CNIG_Accessibilité_TEST.sql
echo "Exécution du SQL de TEST : effectuée !"

echo "Appuyer sur Entrée pour continuer..."
read a

