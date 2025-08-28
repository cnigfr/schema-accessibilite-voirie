
--titre : Code SQL pour la création d'un gabarit geopackage du Standard CNIG Accessibilité
--auteur : Arnauld Gallais - GT CNIG Accessibilité (d'après GT CNIG Risques et GT CNIG DDU/SUP)
--version : Standard CNIG Accessibilité v2021 révision 2025-05
--date : 05/06/2025 au ...



-- CREATE TABLE gpkg_spatial_ref_sys (
--  srs_name TEXT NOT NULL,
--  srs_id INTEGER PRIMARY KEY,
--  organization TEXT NOT NULL,
--  organization_coordsys_id INTEGER NOT NULL,
--  definition  TEXT NOT NULL,
--  description TEXT
--);

-- CREATE TABLE gpkg_contents (
--  table_name TEXT NOT NULL PRIMARY KEY,
--  data_type TEXT NOT NULL,
--  identifier TEXT UNIQUE,
--  description TEXT DEFAULT '',
--  last_change DATETIME NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
--  min_x DOUBLE,
--  min_y DOUBLE,
--  max_x DOUBLE,
--  max_y DOUBLE,
--  srs_id INTEGER,
--  CONSTRAINT fk_gc_r_srs_id FOREIGN KEY (srs_id) REFERENCES gpkg_spatial_ref_sys(srs_id)
-- );

---------------------------------------------------------------
-- Insertion des systèmes de coordonnées dans la table gpkg_spatial_ref_sys
---------------------------------------------------------------

-- INSERT INTO gpkg_spatial_ref_sys VALUES 
--   /* Lambert-93 (RGF93LAMB93) - France métropolitaine */
--   ('Lambert-93 (RGF93LAMB93)',2154,'EPSG',2154, 'PROJCRS["RGF93 v1 / Lambert-93",BASEGEOGCRS["RGF93 v1",DATUM["Reseau Geodesique Francais 1993 v1",ELLIPSOID["GRS 1980",6378137,298.257222101,LENGTHUNIT["metre",1]]],PRIMEM["Greenwich",0,ANGLEUNIT["degree",0.0174532925199433]],ID["EPSG",4171]],CONVERSION["Lambert-93",METHOD["Lambert Conic Conformal (2SP)",ID["EPSG",9802]],PARAMETER["Latitude of false origin",46.5,ANGLEUNIT["degree",0.0174532925199433],ID["EPSG",8821]],PARAMETER["Longitude of false origin",3,ANGLEUNIT["degree",0.0174532925199433],ID["EPSG",8822]],PARAMETER["Latitude of 1st standard parallel",49,ANGLEUNIT["degree",0.0174532925199433],ID["EPSG",8823]],PARAMETER["Latitude of 2nd standard parallel",44,ANGLEUNIT["degree",0.0174532925199433],ID["EPSG",8824]],PARAMETER["Easting at false origin",700000,LENGTHUNIT["metre",1],ID["EPSG",8826]],PARAMETER["Northing at false origin",6600000,LENGTHUNIT["metre",1],ID["EPSG",8827]]],CS[Cartesian,2],AXIS["easting (X)",east,ORDER[1],LENGTHUNIT["metre",1]],AXIS["northing (Y)",north,ORDER[2],LENGTHUNIT["metre",1]],USAGE[SCOPE["Engineering survey, topographic mapping."],AREA["France - onshore and offshore, mainland and Corsica (France métropolitaine including Corsica)."],BBOX[41.15,-9.86,51.56,10.38]],ID["EPSG",2154]]','France métropolitaine'),
--   /* RGAF09UTM20 - Antilles françaises */
--   ('Universal transverse Mercator fuseau 20 nord (RGAF09UTM20)',5490,'EPSG',5490, 'PROJCRS["RGAF09 / UTM zone 20N",BASEGEOGCRS["RGAF09",DATUM["Reseau Geodesique des Antilles Francaises 2009",ELLIPSOID["GRS 1980",6378137,298.257222101,LENGTHUNIT["metre",1]]],PRIMEM["Greenwich",0,ANGLEUNIT["degree",0.0174532925199433]],ID["EPSG",5489]],CONVERSION["UTM zone 20N",METHOD["Transverse Mercator",ID["EPSG",9807]],PARAMETER["Latitude of natural origin",0,ANGLEUNIT["degree",0.0174532925199433],ID["EPSG",8801]],PARAMETER["Longitude of natural origin",-63,ANGLEUNIT["degree",0.0174532925199433],ID["EPSG",8802]],PARAMETER["Scale factor at natural origin",0.9996,SCALEUNIT["unity",1],ID["EPSG",8805]],PARAMETER["False easting",500000,LENGTHUNIT["metre",1],ID["EPSG",8806]],PARAMETER["False northing",0,LENGTHUNIT["metre",1],ID["EPSG",8807]]],CS[Cartesian,2],AXIS["(E)",east,ORDER[1],LENGTHUNIT["metre",1]],AXIS["(N)",north,ORDER[2],LENGTHUNIT["metre",1]],USAGE[SCOPE["Engineering survey, topographic mapping."],AREA["French Antilles onshore and offshore west of 60°W - Guadeloupe (including Grande Terre, Basse Terre, Marie Galante, Les Saintes, Iles de la Petite Terre, La Desirade); Martinique; St Barthélemy; northern St Martin."],BBOX[14.08,-63.66,18.31,-60]],ID["EPSG",5490]]','Antilles françaises (Guadeloupe,Saint-Martin,Saint-Barthélemy,Martinique)'),
--   /* RGFG95UTM22 - Guyane */
--   ('Universal transverse Mercator fuseau 22 nord (RGFG95UTM22)',2972,'EPSG',2972, 'PROJCRS["RGFG95 / UTM zone 22N",BASEGEOGCRS["RGFG95",DATUM["Reseau Geodesique Francais Guyane 1995",ELLIPSOID["GRS 1980",6378137,298.257222101,LENGTHUNIT["metre",1]]],PRIMEM["Greenwich",0,ANGLEUNIT["degree",0.0174532925199433]],ID["EPSG",4624]],CONVERSION["UTM zone 22N",METHOD["Transverse Mercator",ID["EPSG",9807]],PARAMETER["Latitude of natural origin",0,ANGLEUNIT["degree",0.0174532925199433],ID["EPSG",8801]],PARAMETER["Longitude of natural origin",-51,ANGLEUNIT["degree",0.0174532925199433],ID["EPSG",8802]],PARAMETER["Scale factor at natural origin",0.9996,SCALEUNIT["unity",1],ID["EPSG",8805]],PARAMETER["False easting",500000,LENGTHUNIT["metre",1],ID["EPSG",8806]],PARAMETER["False northing",0,LENGTHUNIT["metre",1],ID["EPSG",8807]]],CS[Cartesian,2],AXIS["(E)",east,ORDER[1],LENGTHUNIT["metre",1]],AXIS["(N)",north,ORDER[2],LENGTHUNIT["metre",1]],USAGE[SCOPE["Engineering survey, topographic mapping."],AREA["French Guiana - east of 54°W, onshore and offshore."],BBOX[2.17,-54,8.88,-49.45]],ID["EPSG",2972]]','Guyane'),
--   /* RGR92UTM40S - La Réunion */
--   ('Universal transverse Mercator fuseau 40 sud (RGR92UTM40S)',2975,'EPSG',2975, 'PROJCRS["RGR92 / UTM zone 40S",BASEGEOGCRS["RGR92",DATUM["Reseau Geodesique de la Reunion 1992",ELLIPSOID["GRS 1980",6378137,298.257222101,LENGTHUNIT["metre",1]]],PRIMEM["Greenwich",0,ANGLEUNIT["degree",0.0174532925199433]],ID["EPSG",4627]],CONVERSION["UTM zone 40S",METHOD["Transverse Mercator",ID["EPSG",9807]],PARAMETER["Latitude of natural origin",0,ANGLEUNIT["degree",0.0174532925199433],ID["EPSG",8801]],PARAMETER["Longitude of natural origin",57,ANGLEUNIT["degree",0.0174532925199433],ID["EPSG",8802]],PARAMETER["Scale factor at natural origin",0.9996,SCALEUNIT["unity",1],ID["EPSG",8805]],PARAMETER["False easting",500000,LENGTHUNIT["metre",1],ID["EPSG",8806]],PARAMETER["False northing",10000000,LENGTHUNIT["metre",1],ID["EPSG",8807]]],CS[Cartesian,2],AXIS["(E)",east,ORDER[1],LENGTHUNIT["metre",1]],AXIS["(N)",north,ORDER[2],LENGTHUNIT["metre",1]],USAGE[SCOPE["Engineering survey, topographic mapping."],AREA["Reunion - onshore and offshore - east of 54°E."],BBOX[-24.72,54,-18.28,58.24]],ID["EPSG",2975]]','La Réunion'),
--   /* RGM04UTM38S - Mayotte */
--   ('Universal transverse Mercator fuseau 38 sud (RGM04UTM38S)',4471,'EPSG',4471, 'PROJCRS["RGM04 / UTM zone 38S",BASEGEOGCRS["RGM04",DATUM["Reseau Geodesique de Mayotte 2004",ELLIPSOID["GRS 1980",6378137,298.257222101,LENGTHUNIT["metre",1]]],PRIMEM["Greenwich",0,ANGLEUNIT["degree",0.0174532925199433]],ID["EPSG",4470]],CONVERSION["UTM zone 38S",METHOD["Transverse Mercator",ID["EPSG",9807]],PARAMETER["Latitude of natural origin",0,ANGLEUNIT["degree",0.0174532925199433],ID["EPSG",8801]],PARAMETER["Longitude of natural origin",45,ANGLEUNIT["degree",0.0174532925199433],ID["EPSG",8802]],PARAMETER["Scale factor at natural origin",0.9996,SCALEUNIT["unity",1],ID["EPSG",8805]],PARAMETER["False easting",500000,LENGTHUNIT["metre",1],ID["EPSG",8806]],PARAMETER["False northing",10000000,LENGTHUNIT["metre",1],ID["EPSG",8807]]],CS[Cartesian,2],AXIS["(E)",east,ORDER[1],LENGTHUNIT["metre",1]],AXIS["(N)",north,ORDER[2],LENGTHUNIT["metre",1]],USAGE[SCOPE["Engineering survey, topographic mapping."],AREA["Mayotte - onshore and offshore."],BBOX[-14.49,43.68,-11.33,46.7]],ID["EPSG",4471]]','Mayotte'),
--   /* RGSPM06U21 - Saint-Pierre-et-Miquelon' */
--   ('Universal transverse Mercator fuseau 21 nord (RGSPM06U21)',4467,'EPSG',4467, 'PROJCRS["RGSPM06 / UTM zone 21N",BASEGEOGCRS["RGSPM06",DATUM["Reseau Geodesique de Saint Pierre et Miquelon 2006",ELLIPSOID["GRS 1980",6378137,298.257222101,LENGTHUNIT["metre",1]]],PRIMEM["Greenwich",0,ANGLEUNIT["degree",0.0174532925199433]],ID["EPSG",4463]],CONVERSION["UTM zone 21N",METHOD["Transverse Mercator",ID["EPSG",9807]],PARAMETER["Latitude of natural origin",0,ANGLEUNIT["degree",0.0174532925199433],ID["EPSG",8801]],PARAMETER["Longitude of natural origin",-57,ANGLEUNIT["degree",0.0174532925199433],ID["EPSG",8802]],PARAMETER["Scale factor at natural origin",0.9996,SCALEUNIT["unity",1],ID["EPSG",8805]],PARAMETER["False easting",500000,LENGTHUNIT["metre",1],ID["EPSG",8806]],PARAMETER["False northing",0,LENGTHUNIT["metre",1],ID["EPSG",8807]]],CS[Cartesian,2],AXIS["(E)",east,ORDER[1],LENGTHUNIT["metre",1]],AXIS["(N)",north,ORDER[2],LENGTHUNIT["metre",1]],USAGE[SCOPE["Engineering survey, topographic mapping."],AREA["St Pierre and Miquelon - onshore and offshore."],BBOX[43.41,-57.1,47.37,-55.9]],ID["EPSG",4467]]','Saint-Pierre-et-Miquelon')
--  ;

---------------------------------------------------------------
--  CREATION DES TABLES
---------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------
--  CREATION DES ENUMERATIONS
----------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------
-- Création table d'énumération enum_CATEGORIE_ERP
-----------------------------------------------------
DROP TABLE IF EXISTS enum_categorie_erp;
CREATE TABLE enum_categorie_erp (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_categorie_erp','attributes','enum_categorie_erp','table énumérant les catégories d''erp',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_categorie_erp VALUES 
('Catégorie 1',''),
('Catégorie 2',''),
('Catégorie 3',''),
('Catégorie 4',''),
-- ('NC','non renseigné'),
('sans objet','')
;

-----------------------------------------------------
-- Création table d'énumération enum_CONTROLE_ACCES
-----------------------------------------------------
DROP TABLE IF EXISTS enum_controle_acces;
CREATE TABLE enum_controle_acces (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_controle_acces','attributes','enum_controle_acces','table énumérant les controles d''accès',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_controle_acces VALUES 
('absence',''), 	
('bouton d''appel',''),
('interphone',''),	
('visiophone',''),	
('boucle à induction magnétique','BIM'),('',''),
('NC','non renseigné'),
('sans objet','')
;

-----------------------------------------------------
-- Création table d'énumération enum_CONTROLE_BEV
-----------------------------------------------------
DROP TABLE IF EXISTS enum_controle_bev;
CREATE TABLE enum_controle_bev (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_controle_bev','attributes','enum_controle_bev','table énumérant les controles de bande d''eveil à la vigilance',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_controle_bev VALUES 
('normale',''),
('implantée en travers',''),
('implantée en courbe',''),
('largeur insuffisante',''),
('largeur trop importante',''),
('profondeur insuffisante',''),
('non contrastée',''),
('NC','non renseigné'),
('sans objet','')
;


-----------------------------------------------------
-- Création table d'énumération enum_cote
-----------------------------------------------------
DROP TABLE IF EXISTS enum_cote;
CREATE TABLE enum_cote (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_cote','attributes','enum_cote','table énumérant les cotés',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_cote VALUES
('aucun',''),
('à droite','par rapport au sens direct du tronçon'),
('à gauche','par rapport au sens direct du tronçon'),
('des deux côtés',''),
('en face',''),
('au milieu',''),
-- ('NC','non renseigné'),
('sans objet','')
;

-----------------------------------------------------
-- Création table d'énumération enum_couvert
-----------------------------------------------------
DROP TABLE IF EXISTS enum_couvert;
CREATE TABLE enum_couvert (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_couvert','attributes','enum_couvert','table énumérant les types de couvertures',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_couvert VALUES
('intérieur',''),
('extérieur couvert',''),
('extérieur non couvert',''),
('NC','non renseigné'),
('sans objet','')
;

---------------------------------------------------------
-- Création table d'énumération enum_dispositif_signalisation
---------------------------------------------------------
DROP TABLE IF EXISTS enum_dispositif_signalisation;
CREATE TABLE enum_dispositif_signalisation (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_dispositif_signalisation','attributes','enum_dispositif_signalisation','table énumérant les dispositifs de signalisation',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_dispositif_signalisation VALUES
('aucun',''),
('visuel',''),
('tactile',''),
('sonore',''),
('visuel et tactile',''),
('visuel et sonore',''),
('tactile et sonore',''),
('visuel et tactile et sonore',''),
-- ('NC','non renseigné'),
('sans objet','')
;

-----------------------------------------------------
-- Création table d'énumération enum_eclairage
-----------------------------------------------------

DROP TABLE IF EXISTS enum_eclairage;
CREATE TABLE enum_eclairage (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_eclairage','attributes','enum_eclairage','table énumérant les types d''éclairage',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_eclairage VALUES 
('bon éclairage', 'éclairage régulièrement espacé, constamment alimenté et dirigé vers le trottoir'),
('éclairage insuffisant', 'éclairage irrégulièrement espacé ou à alimentation intermittente et/ou non dirigé vers le trottoir'),
('absence d''éclarage', 'absence de dispositif d’éclairage'),
('NC','non renseigné'),
('sans objet','')
;

-----------------------------------------------------
-- Création table d'énumération enum_etat
-----------------------------------------------------

DROP TABLE IF EXISTS enum_etat;
CREATE TABLE enum_etat (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_etat','attributes','enum_etat','table énumérant les états',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_etat VALUES 
('absence', 'absence de revêtement, de BEV, etc.'),
('bon état', ''),
('dégradation sans gravité', ''),
('dégradation entraînant une difficulté d''usage ou d''inconfort', ''),
('dégradation entraînant un problème de sécurité immédiat', ''),
-- ('NC','non renseigné'),
('sans objet','')
;



-----------------------------------------------------
-- Création table d'énumération enum_etat_revetement
-----------------------------------------------------

DROP TABLE IF EXISTS enum_etat_revetement;
CREATE TABLE enum_etat_revetement (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_etat_revetement','attributes','enum_etat_revetement','table énumérant les états de revêtement',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_etat_revetement VALUES
('roulant',''),
('dégradation sans gravité',''),
('dégradation entrainant un problème de sécurité immédiat',''),
('meuble','s''enfonce'),
('secouant','par exemple des pavés'),
('glissant',''),
-- ('NC','non renseigné'),
('sans objet','')
;



-----------------------------------------------------
-- Création table d'énumération enum_marquage
-----------------------------------------------------

DROP TABLE IF EXISTS enum_marquage;
CREATE TABLE enum_marquage (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_marquage','attributes','enum_marquage','table énumérant les types de marquage',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_marquage VALUES
('aucun',''),
('bandes blanches',''),
('marques d''animation',''),	
('clous métalliques',''),	
('revêtement différencié','par exemple : résine'),
('autre',''),
-- ('NC','non renseigné'),
('sans objet','')
;



-----------------------------------------------------
-- Création table d'énumération enum_masque_covisibilite
-----------------------------------------------------

DROP TABLE IF EXISTS enum_masque_covisibilite;
CREATE TABLE enum_masque_covisibilite (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_masque_covisibilite','attributes','enum_masque_covisibilite','table énumérant les masques de covisibilité',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_masque_covisibilite VALUES 
('aucun', ''),
('stationnement voiture', ''),
('végétation', ''),
('bâti', ''),
('mobilier urbain', ''),
('autre', ''),
-- ('NC','non renseigné'),
('sans objet','')
;



-----------------------------------------------------
-- Création table d'énumération enum_personnel_erp
-----------------------------------------------------

DROP TABLE IF EXISTS enum_personnel_erp;
CREATE TABLE enum_personnel_erp (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_personnel_erp','attributes','enum_personnel_erp','table énumérant la présence de personnel dans les erp',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_personnel_erp VALUES
('absence de personnel',''),
('personnel formé à l''accueil des publics spécifiques',''),
('personnel non-formé à l''accueil des publics spécifiques',''),
('NC','non renseigné'),
('sans objet','')
;


-----------------------------------------------------
-- Création table d'énumération enum_position_espace
-----------------------------------------------------

DROP TABLE IF EXISTS enum_position_espace;
CREATE TABLE enum_position_espace (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_position_espace','attributes','enum_position_espace','table énumérant les positios dans l''espace',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_position_espace VALUES
('absence',''),
('extérieur',''),
('intérieur',''),
('intérieur et extérieur',''),
-- ('NC','non renseigné'),
('sans objet','')
;


-----------------------------------------------------
-- Création table d'énumération enum_position_hauteur
-----------------------------------------------------

DROP TABLE IF EXISTS enum_position_hauteur;
CREATE TABLE enum_position_hauteur (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_position_hauteur','attributes','enum_position_hauteur','table énumérant les positions en hauteur',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_position_hauteur VALUES
('absence',''),
('en bas',''),
('en haut',''),
('en haut et en bas',''),
('NC','non renseigné'),
('sans objet','')
;


-----------------------------------------------------
-- Création table d'énumération enum_position_obstacle
-----------------------------------------------------

DROP TABLE IF EXISTS enum_position_obstacle;
CREATE TABLE enum_position_obstacle (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_position_obstacle','attributes','enum_position_obstacle','table énumérant les positions d''obstacles',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_position_obstacle VALUES
('obstacle en surface',''),
('obstacle posé au sol',''),
('obstacle en saillie',''),
-- ('NC','non renseigné'),
('sans objet','')
;


-----------------------------------------------------
-- Création table d'énumération enum_rappel_obstacle
-----------------------------------------------------

DROP TABLE IF EXISTS enum_rappel_obstacle;
CREATE TABLE enum_rappel_obstacle (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_rappel_obstacle','attributes','enum_rappel_obstacle','table énumérant les rappels d''obstacles',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_rappel_obstacle VALUES
('absence de rappel au sol',''),
('surépaisseur','hauteur inférieure à 3 cm'),
('élément bas','hauteur supérieure à 3 cm'),
('NC','non renseigné'),
('sans objet','')
;

-----------------------------------------------------
-- Création table d'énumération enum_rampe_erp
-----------------------------------------------------

DROP TABLE IF EXISTS enum_rampe_erp;
CREATE TABLE enum_rampe_erp (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_rampe_erp','attributes','enum_rampe_erp','table énumérant les types de rampes d''accès aux erp',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_rampe_erp VALUES
('fixe',''),
('amovible',''),
('absence',''),
('NC','non renseigné'),
('sans objet','')
;


-----------------------------------------------------
-- Création table d'énumération enum_relief_boutons
-----------------------------------------------------

DROP TABLE IF EXISTS enum_relief_boutons;
CREATE TABLE enum_relief_boutons (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_relief_boutons','attributes','enum_relief_boutons','table énumérant les types de touches d''ascenseur',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_relief_boutons VALUES
('aucune touche différenciée',''),
('touche 0 différenciée par relief supérieur',''),
('touche 0 de relief supérieur et autres touches en braille',''),
('NC','non renseigné'),
('sans objet','')
;


-----------------------------------------------------
-- Création table d'énumération enum_repere_lineaire
-----------------------------------------------------

DROP TABLE IF EXISTS enum_repere_lineaire;
CREATE TABLE enum_repere_lineaire (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_repere_lineaire','attributes','enum_repere_lineaire','table énumérant les repères linéaires',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_repere_lineaire VALUES
('aucun',''),
('façade ou mur',''),
('bordure ou muret',''),
('revêtement différencié',''),
('bande de guidage',''),
('autre',''),
-- ('NC','non renseigné'),
('sans objet','')
;



-----------------------------------------------------
-- Création table d'énumération enum_sens
-----------------------------------------------------

DROP TABLE IF EXISTS enum_sens;
CREATE TABLE enum_sens (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_sens','attributes','enum_sens','table énumérant les sens de circulation',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_sens VALUES
('direct','noeud initial vers noeud final du tronçon'),
('indirect','noeud final vers noeud initial du tronçon'),
('variable','valeur réservée aux tapis roulants'),
-- ('NC','non renseigné'),
('sans objet','')
;


-----------------------------------------------------
-- Création table d'énumération enum_statut_voie
-----------------------------------------------------

DROP TABLE IF EXISTS enum_statut_voie;
CREATE TABLE enum_statut_voie (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_statut_voie','attributes','enum_statut_voie','table énumérant les types de voies de circulation',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_statut_voie VALUES
('voie classique','rue - avenue - boulevard'),
('zone 30',''),
('zone de rencontre',''),	
('rue piétonne - aire piétonne - sente piétonne',''),	
('voie verte',''),
('autre type de voie inscrit au schéma directeur de la voirie',''),	
('NC','non renseigné'),
('sans objet','')
;


-----------------------------------------------------
-- Création table d'énumération enum_temporalite
-----------------------------------------------------

DROP TABLE IF EXISTS enum_temporalite;
CREATE TABLE enum_temporalite (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_temporalite','attributes','enum_temporalite','table énumérant les temporalités',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_temporalite VALUES
('permanent',''),
('temporaire',''),
('jamais',''),
('NC','non renseigné'),
('sans objet','')
;


-----------------------------------------------------
-- Création table d'énumération enum_transition
-----------------------------------------------------

DROP TABLE IF EXISTS enum_transition;
CREATE TABLE enum_transition (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_transition','attributes','enum_transition','table énumérant les transitions de hauteur',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_transition VALUES
('montée',''),	
('descente',''),
('pas de changement de niveau',''),
('variable','valeur réservée aux escalators'),
('NC','non renseigné'),
('sans objet','')
;


-----------------------------------------------------
-- Création table d'énumération enum_type_passage
-----------------------------------------------------

DROP TABLE IF EXISTS enum_type_passage;
CREATE TABLE enum_type_passage (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_type_passage','attributes','enum_type_passage','table énumérant les types de passage',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_type_passage VALUES
('en surface',''),	
('couloir',''),
('aérien','passerelle ou pont'),
('passage souterrain',''),
('tunnel',''),
('NC','non renseigné'),
('sans objet','')
;


-----------------------------------------------------
-- Création table d'énumération enum_type_poignee
-----------------------------------------------------

DROP TABLE IF EXISTS enum_type_poignee;
CREATE TABLE enum_type_poignee (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_type_poignee','attributes','enum_type_poignee','table énumérant les types de poignées de porte',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_type_poignee VALUES
('béquille',''),
('bouton',''),
('poignée palière',''),	
('poignée de tirage',''),	
('levier de fenêtre',''),	
('bâton maréchal','barre verticale'),
('NC','non renseigné'),
('sans objet','')
;


-----------------------------------------------------
-- Création table d'énumération enum_type_porte
-----------------------------------------------------

DROP TABLE IF EXISTS enum_type_porte;
CREATE TABLE enum_type_porte (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_type_porte','attributes','enum_type_porte','table énumérant les types de portes',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_type_porte VALUES
('porte normale',''),
('porte coulissant',''),
('tourniquet',''),
('portillon',''),
('portail',''),
('porte tambour',''),	
('porte battante','ouverture dans les deux sens'),
('NC','non renseigné'),
('sans objet','')
;


-----------------------------------------------------
-- Création table d'énumération enum_type_troncon
-----------------------------------------------------

DROP TABLE IF EXISTS enum_type_troncon;
CREATE TABLE enum_type_troncon (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_type_troncon','attributes','enum_type_troncon','table énumérant les types de tronçons de cheminement',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_type_troncon VALUES 
('ascenseur',''),
('escalator',''),
('monte-charge ou monte-personne',''),
('tapis roulant',''),
('rampe',''),
('escalier',''),
('série d’escaliers',''),
('navette',''),
('traversée piétonne',''),
('présence de barrière',''),
('passage étroit',''),
('îlot de traversée piétonne',''),
('hall',''),
('couloir intérieur',''),
('espace confiné',''),
('gestion de queue',''),
('espace ouvert',''),
('rue',''),
('trottoir',''),
('chemin piéton',''),
('passage',''),
('quai',''),
-- ('NC','non renseigné'),
('sans objet','')
;



-----------------------------------------------------
-- Création table d'énumération enum_type_entree
-----------------------------------------------------

DROP TABLE IF EXISTS enum_type_entree;
CREATE TABLE enum_type_entree (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_type_entree','attributes','enum_type_entree','table énumérant les types d''entrée',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_type_entree VALUES
('entrée principale de bâtiment',''),
('entrée secondaire de bâtiment',''),
('entrée de site',''),
('NC','non renseigné'),
('sans objet','')
;


-----------------------------------------------------
-- Création table d'énumération enum_type_erp
-----------------------------------------------------

DROP TABLE IF EXISTS enum_type_erp;
CREATE TABLE enum_type_erp (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_type_erp','attributes','enum_type_erp','table énumérant les types d''erp',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_type_erp VALUES
('J',''),
('L',''),
('M',''),
('N',''),
('O',''),
('P',''),
('R',''),
('S',''),
('T',''),
('U',''),
('V',''),
('W',''),
('X',''),
('Y',''),
('PA',''),
('SG',''),
('PS',''),
('GA',''),
('OA',''),
('REF',''),
-- ('NC','non renseigné'),
('sans objet','')
;


-----------------------------------------------------
-- Création table d'énumération enum_type_obstacle
-----------------------------------------------------

DROP TABLE IF EXISTS enum_type_obstacle;
CREATE TABLE enum_type_obstacle (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_type_obstacle','attributes','enum_type_obstacle','table énumérant les types d''obstacles',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_type_obstacle VALUES
('ressaut',''),
('pente ponctuelle forte',''),
('mobilier urbain',''),
('surface irrégulière',''),
('poteau non électrifié',''),
('grille',''),
('potelet',''),
('végétation',''),
('dévers ponctuel fort',''),
('débord de façade, mur, paroi',''),
('avaloir',''),
('boîte aux lettres',''),
('traversée de piste cyclable',''),
('poteau électrifié',''),
('autre',''),
-- ('NC','non renseigné'),
('sans objet','')
;



-----------------------------------------------------
-- Création table d'énumération enum_type_ouverture
-----------------------------------------------------

DROP TABLE IF EXISTS enum_type_ouverture;
CREATE TABLE enum_type_ouverture (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_type_ouverture','attributes','enum_type_ouverture','table énumérant les types d''ouverture de porte',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_type_ouverture VALUES
('manuelle',''),
('automatique',''),
('ouverture manuelle assistée mécaniquement',''),
-- ('NC','non renseigné'),
('sans objet','')
;


-----------------------------------------------------
-- Création table d'énumération enum_type_stationnementpmr
-----------------------------------------------------

DROP TABLE IF EXISTS enum_type_stationnementpmr;
CREATE TABLE enum_type_stationnementpmr (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_type_stationnementpmr','attributes','enum_type_stationnementpmr','table énumérant les types de stationnement',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_type_stationnementpmr VALUES
('longitudinal','créneau'),
('bataille',''),
('épi',''),
('NC','non renseigné'),
('sans objet','')
;

-----------------------------------------------------
-- Création table d'énumération enum_type_sol
-----------------------------------------------------

DROP TABLE IF EXISTS enum_type_sol;
CREATE TABLE enum_type_sol (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_type_sol','attributes','enum_type_sol','table énumérant les types de sols',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_type_sol VALUES
('carpet','tapis'),
('concrete','béton'),
('asphalt','asphalte ou enrobé'),
('cork','lège'),
('fibreglassGrating','caillebotis en fibre de verre'),
('glazedCeramicTiles','carreaux de céramique émaillés'),
('plasticMatting','matière plastique'),
('ceramicTiles','carrelage'),
('rubber','caoutchouc'),
('steelPlate','plaques métalique'),
('vinyl','vynil'),
('wood','bois'),
('stone','pierre ou pavé'),
('grass','gazon'),
('dirt','terre'),
('gravel','graviers'),
('uneven','matériau inégal par nature'),
('stabilisé','sable stabilisé'),
('autre',''),	
('NC','non renseigné'),
('sans objet','')
;


-----------------------------------------------------
-- Création table d'énumération enum_voyant_ascenseur
-----------------------------------------------------

DROP TABLE IF EXISTS enum_voyant_ascenseur;
CREATE TABLE enum_voyant_ascenseur (
valeur text not null primary key,
definition text
);

INSERT INTO gpkg_contents VALUES 
('enum_voyant_ascenseur','attributes','enum_voyant_ascenseur','table énumérant les types de voyants d''ascenseurs',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

INSERT INTO enum_voyant_ascenseur VALUES
('aucun',''),
('voyant demande secours enregistrée','vert'),
('voyant demande secours en transmission','jaune'),
('les deux',''),
-- ('NC','non renseigné'),
('sans objet','')
;

 
--------------------------------------------------------------------
-- Création de la table CHEMINEMENT (3.3.1)
--------------------------------------------------------------------


DROP TABLE IF EXISTS cheminement;
CREATE TABLE cheminement ( 
  idcheminement TEXT NOT NULL PRIMARY KEY, 
  libelle TEXT NOT NULL
);
-- Ajout à la table gpkg_contents
INSERT INTO gpkg_contents VALUES 
  ('cheminement','attributes','cheminement','table des cheminements',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

--------------------------------------------------------------------
-- Création de la table géométrique NOEUD_CHEMINEMENT (3.3.3)
--------------------------------------------------------------------

DROP TABLE IF EXISTS noeud_cheminement;
CREATE TABLE noeud_cheminement (  
  idnoeud TEXT NOT NULL PRIMARY KEY, 
  altitude REAL, 
  bandeEveilVigilance TEXT NOT NULL,
  hauteurRessaut REAL NOT NULL,
  abaissePente INTEGER NOT NULL,
  abaisseLargeur REAL NOT NULL,
  masqueCovisibilite TEXT NOT NULL,
  controleBev TEXT NOT NULL,
  bandeInterception BOOLEAN,
  geom POINT NOT NULL,
  CONSTRAINT fk_bandeEveilVigilance FOREIGN KEY (bandeEveilVigilance) REFERENCES enum_etat(valeur),
  CONSTRAINT fk_masqueCovisibilite FOREIGN KEY (masqueCovisibilite) REFERENCES enum_masqueCovisibilite(valeur),
  CONSTRAINT fk_controleBev FOREIGN KEY (controleBev) REFERENCES enum_controleBev(valeur)
);

-- Ajout à la table gpkg_contents
INSERT INTO gpkg_contents VALUES 
  ('noeud_cheminement','features','noeud_cheminement','table géométrique des noeuds de cheminements',(datetime('now')),NULL,NULL,NULL,NULL,2154)
;

-- Ajout à la table gpkg_geometry_columns
INSERT INTO gpkg_geometry_columns VALUES 
  ('noeud_cheminement','geom','POINT',2154,0,0)  
;
  
--------------------------------------------------------------------
-- Création de la table géométrique TRONCON_CHEMINEMENT (3.3.2)
--------------------------------------------------------------------

DROP TABLE IF EXISTS troncon_cheminement;
CREATE TABLE troncon_cheminement (  
  idtroncon TEXT NOT NULL PRIMARY KEY, 
--  !! from et to sont des mots clés pour SQL => les mettre entre quotes
  'from' TEXT NOT NULL,
  'to' TEXT NOT NULL,
  longueur INTEGER NOT NULL,
  typeTroncon TEXT NOT NULL,
  statutVoie TEXT NOT NULL,
  pente TINYINT NOT NULL,
  devers INTEGER NOT NULL,
  urlMedia TEXT,
  geom LINESTRING NOT NULL,
  CONSTRAINT fk_from FOREIGN KEY ('from') REFERENCES noeud_cheminement(idnoeud),
  CONSTRAINT fk_to FOREIGN KEY ('to') REFERENCES noeud_cheminement(idnoeud),
  CONSTRAINT fk_typeTroncon FOREIGN KEY (typeTroncon) REFERENCES enum_type_troncon(valeur),
  CONSTRAINT fk_statutVoie FOREIGN KEY (statutVoie) REFERENCES enum_statut_voie(valeur)
);
-- Ajout à la table gpkg_contents
INSERT INTO gpkg_contents VALUES 
  ('troncon_cheminement','features','troncon_cheminement','table géométrique des tronçons de cheminements',(datetime('now')),NULL,NULL,NULL,NULL,2154)
;

-- Ajout à la table gpkg_geometry_columns
INSERT INTO gpkg_geometry_columns VALUES 
  ('troncon_cheminement','geom','LINESTRING',2154,0,0)
 ;


--------------------------------------------------------------------
-- Création de la table géométrique OBSTACLE (3.3.4)
--------------------------------------------------------------------

DROP TABLE IF EXISTS obstacle;
CREATE TABLE obstacle (  
  idobstacle TEXT NOT NULL PRIMARY KEY,
-- Attributs TRONÇON  
  idtroncon TEXT NOT NULL, 
  'from' TEXT NOT NULL,
  'to' TEXT NOT NULL,
  longueur INTEGER NOT NULL,
  typeTroncon TEXT NOT NULL,
  statutVoie TEXT NOT NULL,
  pente TINYINT NOT NULL,
  devers INTEGER NOT NULL,
  -- urlMedia TEXT,            -- est sinon en doublon
-- Attributs OBSTACLE
  typeObstacle TEXT NOT NULL,
  largeurUtile REAL NOT NULL,
  positionObstacle TEXT NOT NULL,
  longueurObstacle REAL,
  rappelObstacle TEXT NOT NULL,
  reperabiliteVisuelle BOOLEAN NOT NULL,
  urlMedia TEXT,
  hauteurSousObs REAL,
  hauteurObsPoseSol REAL,
  geom POINT NOT NULL,
  CONSTRAINT fk_obstacle_troncon FOREIGN KEY (idtroncon) REFERENCES troncon_cheminement(idtroncon),
  CONSTRAINT fk_from FOREIGN KEY ('from') REFERENCES noeud_cheminement(idnoeud),
  CONSTRAINT fk_to FOREIGN KEY ('to') REFERENCES noeud_cheminement(idnoeud),
  CONSTRAINT fk_typeTroncon FOREIGN KEY (typeTroncon) REFERENCES enum_type_troncon(valeur),
  CONSTRAINT fk_statutVoie FOREIGN KEY (statutVoie) REFERENCES enum_statut_voie(valeur),
  CONSTRAINT fk_typeObstacle FOREIGN KEY (typeObstacle) REFERENCES enum_type_obstacle(valeur),
  CONSTRAINT fk_positionObstacle FOREIGN KEY (positionObstacle) REFERENCES enum_position_obstacle(valeur),
  CONSTRAINT fk_rappelObstacle FOREIGN KEY (rappelObstacle) REFERENCES enum_rappel_obstacle(valeur)
);
-- Ajout à la table gpkg_contents
INSERT INTO gpkg_contents VALUES 
  ('obstacle','features','obstacle','table géométrique des obstacles',(datetime('now')),NULL,NULL,NULL,NULL,2154)
;

-- Ajout à la table gpkg_geometry_columns
INSERT INTO gpkg_geometry_columns VALUES 
  ('obstacle','geom','POINT',2154,0,0)
 ;

--------------------------------------------------------------------
-- Création de la table géométrique CIRCULATION (3.3.5)
-- intégrant les attributs et la géométrie du tronçon
--------------------------------------------------------------------

DROP TABLE IF EXISTS circulation;
CREATE TABLE circulation (
  idcirculation TEXT NOT NULL PRIMARY KEY,
-- Attributs TRONÇON  
  idtroncon TEXT NOT NULL, 
  'from' TEXT NOT NULL,
  'to' TEXT NOT NULL,
  longueur INTEGER NOT NULL,
  typeTroncon TEXT NOT NULL,
  statutVoie TEXT NOT NULL,
  pente TINYINT NOT NULL,
  devers INTEGER NOT NULL,
  urlMedia TEXT,
-- Attributs CIRCULATION
  typeSol TEXT,		
  largeurUtile REAL NOT NULL,
  etatRevetement TEXT NOT NULL,
  eclairage TEXT,
  transition TEXT,	
  typePassage TEXT,
  repereLineaire TEXT NOT NULL,
  couvert TEXT,
  geom LINESTRING NOT NULL,
  CONSTRAINT fk_circulation_troncon FOREIGN KEY (idtroncon) REFERENCES troncon_cheminement(idtroncon),
  CONSTRAINT fk_from FOREIGN KEY ('from') REFERENCES noeud_cheminement(idnoeud),
  CONSTRAINT fk_to FOREIGN KEY ('to') REFERENCES noeud_cheminement(idnoeud),
  CONSTRAINT fk_typeTroncon FOREIGN KEY (typeTroncon) REFERENCES enum_type_troncon(valeur),
  CONSTRAINT fk_statutVoie FOREIGN KEY (statutVoie) REFERENCES enum_statut_voie(valeur),
  CONSTRAINT fk_typeSol FOREIGN KEY (typeSol) REFERENCES enum_type_sol(valeur),
  CONSTRAINT fk_etatRevetement FOREIGN KEY (etatRevetement) REFERENCES enum_etat_revetement(valeur),
  CONSTRAINT fk_eclairage FOREIGN KEY (eclairage) REFERENCES enum_eclairage(valeur),
  CONSTRAINT fk_transition FOREIGN KEY (transition) REFERENCES enum_transition(valeur),
  CONSTRAINT fk_typePassage FOREIGN KEY (typePassage) REFERENCES enum_type_passage(valeur),
  CONSTRAINT fk_repereLineaire FOREIGN KEY (repereLineaire) REFERENCES enum_repere_lineaire(valeur),
  CONSTRAINT fk_couvert FOREIGN KEY (couvert) REFERENCES enum_couvert(valeur)
);
-- Ajout à la table gpkg_contents
INSERT INTO gpkg_contents VALUES 
  ('circulation','features','circulation','table géométrique des circulations',(datetime('now')),NULL,NULL,NULL,NULL,2154)
;

-- Ajout à la table gpkg_geometry_columns
INSERT INTO gpkg_geometry_columns VALUES 
  ('circulation','geom','LINESTRING',2154,0,0)
 ;

--------------------------------------------------------------------
-- Création de la table géométrique TRAVERSEE (3.3.7)
-- intégrant les attributs et la géométrie du tronçon
--------------------------------------------------------------------

DROP TABLE IF EXISTS traversee;
CREATE TABLE traversee (
  idtraversee TEXT NOT NULL PRIMARY KEY,
-- Attributs TRONÇON
  idtroncon TEXT NOT NULL, 
  'from' TEXT NOT NULL,
  'to' TEXT NOT NULL,
  longueur INTEGER NOT NULL,
  typeTroncon TEXT NOT NULL,
  statutVoie TEXT NOT NULL,
  pente TINYINT NOT NULL,
  devers INTEGER NOT NULL,
  urlMedia TEXT,
-- Attributs TRAVERSEE
  etatRevetement TEXT NOT NULL,
  typeMarquage TEXT NOT NULL,
  etatMarquage TEXT,
  eclairage TEXT,
  feuPietons BOOLEAN NOT NULL,
  aideSonore TEXT NOT NULL,
  repereLineaire TEXT NOT NULL,
  chausseeBombee BOOLEAN TEXT NOT NULL,
  voiesTraversees TEXT,
  geom LINESTRING NOT NULL,
  CONSTRAINT fk_traversee_troncon FOREIGN KEY (idtroncon) REFERENCES troncon_cheminement(idtroncon),
  CONSTRAINT fk_from FOREIGN KEY ('from') REFERENCES noeud_cheminement(idnoeud),
  CONSTRAINT fk_to FOREIGN KEY ('to') REFERENCES noeud_cheminement(idnoeud),
  CONSTRAINT fk_typeTroncon FOREIGN KEY (typeTroncon) REFERENCES enum_type_troncon(valeur),
  CONSTRAINT fk_statutVoie FOREIGN KEY (statutVoie) REFERENCES enum_statut_voie(valeur),
  CONSTRAINT fk_etatRevetement FOREIGN KEY (etatRevetement) REFERENCES enum_etat_revetement(valeur),
  CONSTRAINT fk_marquage FOREIGN KEY (typeMarquage) REFERENCES enum_marquage(valeur),
  CONSTRAINT fk_etatMarqauge FOREIGN KEY (etatMarquage) REFERENCES enum_etat(valeur),
  CONSTRAINT fk_eclairage FOREIGN KEY (eclairage) REFERENCES enum_eclairage(valeur),
  CONSTRAINT fk_etatAideSonore FOREIGN KEY (aideSonore) REFERENCES enum_etat(valeur),
  CONSTRAINT fk_repereLineaire FOREIGN KEY (repereLineaire) REFERENCES enum_repere_lineaire(valeur)
);
-- Ajout à la table gpkg_contents
INSERT INTO gpkg_contents VALUES 
  ('traversee','features','traversee','table géométrique des traversees',(datetime('now')),NULL,NULL,NULL,NULL,2154)
;

-- Ajout à la table gpkg_geometry_columns
INSERT INTO gpkg_geometry_columns VALUES 
  ('traversee','geom','LINESTRING',2154,0,0)
 ;


--------------------------------------------------------------------
-- Création de la table géométrique RAMPE D'ACCES (3.3.8)           
-- intégrant les attributs et la géométrie du tronçon               
--------------------------------------------------------------------

DROP TABLE IF EXISTS rampe;
CREATE TABLE rampe (
  idrampe TEXT NOT NULL PRIMARY KEY,
  -- Attributs TRONÇON
  idtroncon TEXT NOT NULL,
  "from" TEXT NOT NULL,
  "to" TEXT NOT NULL,
  longueur INTEGER NOT NULL,
  typeTroncon TEXT NOT NULL,
  statutVoie TEXT NOT NULL,
  pente TINYINT NOT NULL,
  devers INTEGER NOT NULL,
  urlMedia TEXT,
  -- Attributs RAMPE
  etatRevetement TEXT NOT NULL,
  largeurUtile REAL NOT NULL,
  mainCourante TEXT NOT NULL,
  distPalierRepos REAL,
  chasseRoue TEXT,
  aireRotation TEXT,
  poidsSupporte INTEGER,
  -- Géométrie
  geom LINESTRING NOT NULL,
  -- Contraintes de références
  CONSTRAINT fk_rampe_troncon FOREIGN KEY (idtroncon) REFERENCES troncon_cheminement(idtroncon),
  CONSTRAINT fk_from FOREIGN KEY ("from") REFERENCES noeud_cheminement(idnoeud),
  CONSTRAINT fk_to FOREIGN KEY ("to") REFERENCES noeud_cheminement(idnoeud),
  CONSTRAINT fk_troncon FOREIGN KEY (idtroncon) REFERENCES troncon_cheminement(idtroncon),
  CONSTRAINT fk_typeTroncon FOREIGN KEY (typeTroncon) REFERENCES enum_type_troncon(valeur),
  CONSTRAINT fk_statutVoie FOREIGN KEY (statutVoie) REFERENCES enum_statut_voie(valeur),
  CONSTRAINT fk_etatRevetement FOREIGN KEY (etatRevetement) REFERENCES enum_etat(valeur),
  CONSTRAINT fk_mainCourante FOREIGN KEY (mainCourante) REFERENCES enum_cote(valeur),
  CONSTRAINT fk_chasseRoue FOREIGN KEY (chasseRoue) REFERENCES enum_cote(valeur),
  CONSTRAINT fk_aireRotation FOREIGN KEY (aireRotation) REFERENCES enum_position_hauteur(valeur)
);

-- Ajout à la table gpkg_contents
INSERT INTO gpkg_contents VALUES 
  ('rampe','features','rampe','table géométrique des rampes',(datetime('now')),NULL,NULL,NULL,NULL,2154)
;

-- Ajout à la table gpkg_geometry_columns
INSERT INTO gpkg_geometry_columns VALUES 
  ('rampe','geom','LINESTRING',2154,0,0)
;

----------------------------------------------------------------
-- ESCALIER (classe 3.3.9)
-- intégrant les attributs et la géométrie du tronçon
----------------------------------------------------------------

-- DROP TABLE IF EXISTS escalier;
DROP TABLE IF EXISTS escalier;
CREATE TABLE escalier (
  idescalier            TEXT PRIMARY KEY NOT NULL,
  -- Attributs TRONÇON
  idtroncon             TEXT NOT NULL,
  'from'                TEXT NOT NULL,
  'to'                  TEXT NOT NULL,
  longueur              INTEGER NOT NULL,
  typeTroncon           TEXT NOT NULL,
  statutVoie            TEXT NOT NULL,
  pente                 TINYINT NOT NULL,
  devers                INTEGER NOT NULL,
  urlMedia              TEXT,
  -- Attributs ESCALIER
  etatRevetement        TEXT NOT NULL,
  mainCourante          TEXT NOT NULL,
  dispositifVigilance   TEXT NOT NULL,
  contrasteVisuel       TEXT NOT NULL,
  largeurUtile          REAL,
  mainCouranteContinue  TEXT,
  prolongMainCourante   TEXT,
  nbMarches             INTEGER,
  nbVoleeMarches        INTEGER,
  hauteurMarche         REAL,
  giron                 REAL,
  -- Géométrie
  geom                  LINESTRING NOT NULL,
  -- Contraintes de références
  CONSTRAINT fk_escalier_troncon FOREIGN KEY (idtroncon) REFERENCES troncon_cheminement(idtroncon),
  CONSTRAINT fk_from        FOREIGN KEY ('from') REFERENCES noeud_cheminement(idnoeud),
  CONSTRAINT fk_to          FOREIGN KEY ('to')   REFERENCES noeud_cheminement(idnoeud),
  CONSTRAINT fk_typeTroncon FOREIGN KEY (typeTroncon) REFERENCES enum_type_troncon(valeur),
  CONSTRAINT fk_statutVoie  FOREIGN KEY (statutVoie)  REFERENCES enum_statut_voie(valeur),
  CONSTRAINT fk_etatRev     FOREIGN KEY (etatRevetement)       REFERENCES enum_etat_revetement(valeur),
  CONSTRAINT fk_mc          FOREIGN KEY (mainCourante)         REFERENCES enum_cote(valeur),
  CONSTRAINT fk_mccont      FOREIGN KEY (mainCouranteContinue) REFERENCES enum_cote(valeur),
  CONSTRAINT fk_mcprol      FOREIGN KEY (prolongMainCourante)  REFERENCES enum_cote(valeur),
  CONSTRAINT fk_vigi        FOREIGN KEY (dispositifVigilance)  REFERENCES enum_etat(valeur),
  CONSTRAINT fk_contraste   FOREIGN KEY (contrasteVisuel)      REFERENCES enum_etat(valeur)
);

-- Ajout à la table gpkg_contents
INSERT INTO gpkg_contents
VALUES ('escalier','features','escalier','Table géométrique des escaliers',(datetime('now')),NULL,NULL,NULL,NULL,2154);

-- Ajout à la table gpkg_geometry_columns
INSERT INTO gpkg_geometry_columns
VALUES ('escalier','geom','LINESTRING',2154,0,0);


----------------------------------------------------------------
-- ESCALATOR (classe 3.3.10)
-- intégrant les attributs et la géométrie du tronçon
----------------------------------------------------------------
DROP TABLE IF EXISTS escalator;
CREATE TABLE escalator (
  idescalator           TEXT PRIMARY KEY NOT NULL,
  -- Attributs TRONÇON
  idtroncon             TEXT NOT NULL,
  'from'                TEXT NOT NULL,
  'to'                  TEXT NOT NULL,
  longueur              INTEGER NOT NULL,
  typeTroncon           TEXT NOT NULL,
  statutVoie            TEXT NOT NULL,
  pente                 TINYINT NOT NULL,
  devers                INTEGER NOT NULL,
  urlMedia              TEXT,
  -- Attributs ESCALATOR
  transition            TEXT NOT NULL,
  dispositifVigilance   TEXT NOT NULL,
  largeurUtile          REAL NOT NULL,
  detecteur             BOOLEAN,
  supervision           BOOLEAN,
  -- Géométrie
  geom                  LINESTRING NOT NULL,
    -- Contraintes de références
  CONSTRAINT fk_escalator_troncon FOREIGN KEY (idtroncon) REFERENCES troncon_cheminement(idtroncon),
  CONSTRAINT fk_from        FOREIGN KEY ('from') REFERENCES noeud_cheminement(idnoeud),
  CONSTRAINT fk_to          FOREIGN KEY ('to')   REFERENCES noeud_cheminement(idnoeud),
  CONSTRAINT fk_typeTroncon FOREIGN KEY (typeTroncon) REFERENCES enum_type_troncon(valeur),
  CONSTRAINT fk_statutVoie  FOREIGN KEY (statutVoie)  REFERENCES enum_statut_voie(valeur),
  CONSTRAINT fk_transition  FOREIGN KEY (transition)  REFERENCES enum_transition(valeur),
  CONSTRAINT fk_vigi        FOREIGN KEY (dispositifVigilance) REFERENCES enum_etat(valeur)
);

-- Ajout à la table gpkg_contents
INSERT INTO gpkg_contents
VALUES ('escalator','features','escalator','Table géométrique des escalators',(datetime('now')),NULL,NULL,NULL,NULL,2154);

-- Ajout à la table gpkg_geometry_columns
INSERT INTO gpkg_geometry_columns
VALUES ('escalator','geom','LINESTRING',2154,0,0);


----------------------------------------------------------------
-- TAPIS_ROULANT (classe 3.3.11)
-- intégrant les attributs et la géométrie du tronçon
----------------------------------------------------------------
DROP TABLE IF EXISTS tapis_roulant;
CREATE TABLE tapis_roulant (
  idtapisroulant        TEXT PRIMARY KEY NOT NULL,
  -- Attributs TRONÇON
  idtroncon             TEXT NOT NULL,
  'from'                TEXT NOT NULL,
  'to'                  TEXT NOT NULL,
  longueur              INTEGER NOT NULL,
  typeTroncon           TEXT NOT NULL,
  statutVoie            TEXT NOT NULL,
  pente                 TINYINT NOT NULL,
  devers                INTEGER NOT NULL,
  urlMedia              TEXT,
  -- Attributs TAPIS_ROULANT
  sens                  TEXT NOT NULL,
  dispositifVigilance   TEXT NOT NULL,
  largeurUtile          REAL NOT NULL,
  detecteur             BOOLEAN,
  -- Géométrie
  geom                  LINESTRING NOT NULL,
  -- Contraintes de références
  CONSTRAINT fk_tapis_roulant_troncon FOREIGN KEY (idtroncon) REFERENCES troncon_cheminement(idtroncon),
  CONSTRAINT fk_from        FOREIGN KEY ('from') REFERENCES noeud_cheminement(idnoeud),
  CONSTRAINT fk_to          FOREIGN KEY ('to')   REFERENCES noeud_cheminement(idnoeud),
  CONSTRAINT fk_typeTroncon FOREIGN KEY (typeTroncon) REFERENCES enum_type_troncon(valeur),
  CONSTRAINT fk_statutVoie  FOREIGN KEY (statutVoie)  REFERENCES enum_statut_voie(valeur),
  CONSTRAINT fk_sens        FOREIGN KEY (sens)        REFERENCES enum_sens(valeur),
  CONSTRAINT fk_vigi        FOREIGN KEY (dispositifVigilance) REFERENCES enum_etat(valeur)
);

-- Ajout à la table gpkg_contents
INSERT INTO gpkg_contents
VALUES ('tapis_roulant','features','tapis_roulant','Table géométrique des tapis roulants',(datetime('now')),NULL,NULL,NULL,NULL,2154);

-- Ajout à la table gpkg_geometry_columns
INSERT INTO gpkg_geometry_columns
VALUES ('tapis_roulant','geom','LINESTRING',2154,0,0);



--------------------------------------------------------------------
-- ASCENSEUR (classe 3.3.12)
-- intégrant les attributs et la géométrie du noeud_cheminement
--------------------------------------------------------------------
DROP TABLE IF EXISTS ascenseur;
CREATE TABLE ascenseur (
  idascenseur TEXT NOT NULL PRIMARY KEY,
  -- Attributs NOEUD_CHEMINEMENT
  idnoeud TEXT NOT NULL,
  altitude REAL,
  bandeEveilVigilance TEXT NOT NULL,
  hauteurRessaut REAL NOT NULL,
  abaissePente INTEGER NOT NULL,
  abaisseLargeur REAL NOT NULL,
  masqueCovisibilite TEXT NOT NULL,
  controleBev TEXT NOT NULL,
  bandeInterception BOOLEAN,
  -- Attributs ASCENSEUR
  largeurUtile REAL NOT NULL,
  diamManoeuvreFauteuil REAL,
  largeurCabine REAL NOT NULL,
  longueurCabine REAL NOT NULL,
  boutonsEnRelief TEXT,
  annonceSonore BOOLEAN NOT NULL,
  signalEtage TEXT NOT NULL,
  boucleInducMagnet BOOLEAN NOT NULL,
  miroir BOOLEAN,
  eclairage INTEGER,
  voyantAlerte TEXT NOT NULL,
  typeOuverture TEXT NOT NULL,
  mainCourante TEXT,
  hauteurMainCourante REAL,
  etatRevetement TEXT,
  supervision BOOLEAN,
  autrePorteSortie TEXT,
  -- Géométrie
  geom POINT NOT NULL,
  -- Contraintes de références
  CONSTRAINT fk_ascenseur_noeud FOREIGN KEY (idnoeud) REFERENCES noeud_cheminement(idnoeud),
  CONSTRAINT fk_bandeEveilVigilance_ascenseur FOREIGN KEY (bandeEveilVigilance) REFERENCES enum_etat(valeur),
  CONSTRAINT fk_masqueCovisibilite_ascenseur FOREIGN KEY (masqueCovisibilite) REFERENCES enum_masqueCovisibilite(valeur),
  CONSTRAINT fk_controleBev_ascenseur FOREIGN KEY (controleBev) REFERENCES enum_controleBev(valeur)
  CONSTRAINT fk_boutonsEnRelief   FOREIGN KEY (boutonsEnRelief)     REFERENCES enum_relief_boutons(valeur),
  CONSTRAINT fk_signalEtage       FOREIGN KEY (signalEtage)         REFERENCES enum_dispositif_signalisation(valeur),
  CONSTRAINT fk_voyantAlerte      FOREIGN KEY (voyantAlerte)        REFERENCES enum_voyant_ascenseur(valeur),
  CONSTRAINT fk_typeOuverture      FOREIGN KEY (typeOuverture)        REFERENCES enum_type_ouverture(valeur),
  CONSTRAINT fk_etatRevetement     FOREIGN KEY (etatRevetement)       REFERENCES enum_etat_revetement(valeur),
  CONSTRAINT fk_mainCourante       FOREIGN KEY (mainCourante)         REFERENCES enum_cote(valeur),
  CONSTRAINT fk_autrePorteSortie   FOREIGN KEY (autrePorteSortie)     REFERENCES enum_cote(valeur)
);

-- Ajout à la table gpkg_contents
INSERT INTO gpkg_contents VALUES
  ('ascenseur','features','ascenseur','Table géométrique des ascenseurs',(datetime('now')),NULL,NULL,NULL,NULL,2154);

-- Ajout à la table gpkg_geometry_columns
INSERT INTO gpkg_geometry_columns VALUES
  ('ascenseur','geom','POINT',2154,0,0);


--------------------------------------------------------------------
-- ELEVATEUR (classe 3.3.13)
-- intégrant les attributs et la géométrie du noeud_cheminement
--------------------------------------------------------------------
DROP TABLE IF EXISTS elevateur;
CREATE TABLE elevateur (
  idelevateur TEXT NOT NULL PRIMARY KEY,
  -- Attributs NOEUD_CHEMINEMENT
  idnoeud TEXT NOT NULL,
  altitude REAL,
  bandeEveilVigilance TEXT NOT NULL,
  hauteurRessaut REAL NOT NULL,
  abaissePente INTEGER NOT NULL,
  abaisseLargeur REAL NOT NULL,
  masqueCovisibilite TEXT NOT NULL,
  controleBev TEXT NOT NULL,
  bandeInterception BOOLEAN,
  -- Attributs ELEVATEUR
  largeurUtile REAL NOT NULL,
  boutonsEnRelief TEXT,
  typeOuverture TEXT,
  largeurPlateforme REAL NOT NULL,
  longueurPlateforme REAL NOT NULL,
  utilisableAutonomie BOOLEAN,
  etatRevetement TEXT,
  supervision BOOLEAN,
  autrePorteSortie TEXT,
  chargeMaximum INTEGER,
  accompagnateur TEXT,
  -- Géométrie
  geom POINT NOT NULL,
  -- Contraintes de références
  CONSTRAINT fk_elevateur_noeud FOREIGN KEY (idnoeud) REFERENCES noeud_cheminement(idnoeud),
  CONSTRAINT fk_bandeEveilVigilance_elevateur FOREIGN KEY (bandeEveilVigilance) REFERENCES enum_etat(valeur),
  CONSTRAINT fk_masqueCovisibilite_elevateur FOREIGN KEY (masqueCovisibilite) REFERENCES enum_masqueCovisibilite(valeur),
  CONSTRAINT fk_controleBev_elevateur FOREIGN KEY (controleBev) REFERENCES enum_controleBev(valeur),
  CONSTRAINT fk_boutonsEnRelief_elevateur FOREIGN KEY (boutonsEnRelief) REFERENCES enum_relief_boutons(valeur),
  CONSTRAINT fk_typeOuverture_elevateur FOREIGN KEY (typeOuverture) REFERENCES enum_type_ouverture(valeur),
  CONSTRAINT fk_etatRevetement_elevateur FOREIGN KEY (etatRevetement) REFERENCES enum_etat_revetement(valeur),
  CONSTRAINT fk_autrePorteSortie_elevateur FOREIGN KEY (autrePorteSortie) REFERENCES enum_cote(valeur)
  CONSTRAINT fk_accompagnateur_elevateur FOREIGN KEY (accompagnateur) REFERENCES enum_temporalite(valeur)
);

-- Ajout à la table gpkg_contents
INSERT INTO gpkg_contents VALUES
  ('elevateur','features','elevateur','Table géométrique des élévateurs',(datetime('now')),NULL,NULL,NULL,NULL,2154);

-- Ajout à la table gpkg_geometry_columns
INSERT INTO gpkg_geometry_columns VALUES
  ('elevateur','geom','POINT',2154,0,0);

--------------------------------------------------------------------
-- ENTREE (classe 3.3.14)
-- intégrant les attributs et la géométrie du noeud_cheminement
--------------------------------------------------------------------
DROP TABLE IF EXISTS entree;
CREATE TABLE entree (
  identree TEXT NOT NULL PRIMARY KEY,
  -- Attributs NOEUD_CHEMINEMENT
  idnoeud TEXT NOT NULL,
  altitude REAL,
  bandeEveilVigilance TEXT NOT NULL,
  hauteurRessaut REAL NOT NULL,
  abaissePente INTEGER NOT NULL,
  abaisseLargeur REAL NOT NULL,
  masqueCovisibilite TEXT NOT NULL,
  controleBev TEXT NOT NULL,
  bandeInterception BOOLEAN,
  -- Attributs ENTREE
  adresse TEXT,
  typeEntree TEXT,                      -- facultatif
  rampe TEXT NOT NULL,                  -- enum: rampe_erp
  rampeSonnette BOOLEAN,                -- facultatif
  ascenseur BOOLEAN NOT NULL,
  escalierNbMarche INTEGER NOT NULL,
  escalierMainCourante TEXT,            -- enum: cote
  reperabilite BOOLEAN,                 -- facultatif
  reperageEltsVitres BOOLEAN NOT NULL,
  signaletique BOOLEAN,                 -- facultatif
  largeurPassage REAL NOT NULL,
  controleAcces TEXT,                   -- enum: controle_acces (facultatif)
  entreeAccueilVisible BOOLEAN,         -- facultatif
  eclairage TEXT,                       -- enum: eclairage (facultatif)
  typePorte TEXT,                       -- enum: type_porte (facultatif)
  typeOuverture TEXT NOT NULL,          -- enum: type_ouverture
  espaceManoeuvre TEXT NOT NULL,        -- enum: position_espace
  largManoeuvreExt REAL,
  longManoeuvreExt REAL,
  largManoeuvreInt REAL,
  longManoeuvreInt REAL,
  typePoignee TEXT,                     -- enum: type_poignee (facultatif)
  effortOuverture INTEGER,
  -- Géométrie
  geom POINT NOT NULL,
  -- Contraintes de références
  CONSTRAINT fk_entree_noeud                FOREIGN KEY (idnoeud)               REFERENCES noeud_cheminement(idnoeud),
  CONSTRAINT fk_bandeEveilVigilance_entree  FOREIGN KEY (bandeEveilVigilance)   REFERENCES enum_etat(valeur),
  CONSTRAINT fk_masqueCovi_entree           FOREIGN KEY (masqueCovisibilite)    REFERENCES enum_masque_covisibilite(valeur),
  CONSTRAINT fk_controleBev_entree          FOREIGN KEY (controleBev)           REFERENCES enum_controle_bev(valeur),

  CONSTRAINT fk_typeEntree_entree           FOREIGN KEY (typeEntree)            REFERENCES enum_type_entree(valeur),
  CONSTRAINT fk_rampe_entree                FOREIGN KEY (rampe)                 REFERENCES enum_rampe_erp(valeur),
  CONSTRAINT fk_escalierMainCourante_entree FOREIGN KEY (escalierMainCourante)  REFERENCES enum_cote(valeur),
  CONSTRAINT fk_controleAcces_entree        FOREIGN KEY (controleAcces)         REFERENCES enum_controle_acces(valeur),
  CONSTRAINT fk_eclairage_entree            FOREIGN KEY (eclairage)             REFERENCES enum_eclairage(valeur),
  CONSTRAINT fk_typePorte_entree            FOREIGN KEY (typePorte)             REFERENCES enum_type_porte(valeur),
  CONSTRAINT fk_typeOuverture_entree        FOREIGN KEY (typeOuverture)         REFERENCES enum_type_ouverture(valeur),
  CONSTRAINT fk_espaceManoeuvre_entree      FOREIGN KEY (espaceManoeuvre)       REFERENCES enum_position_espace(valeur),
  CONSTRAINT fk_typePoignee_entree          FOREIGN KEY (typePoignee)           REFERENCES enum_type_poignee(valeur)
);

-- Ajout à la table gpkg_contents
INSERT INTO gpkg_contents VALUES
  ('entree','features','entree','Table géométrique des entrées',(datetime('now')),NULL,NULL,NULL,NULL,2154);

-- Ajout à la table gpkg_geometry_columns
INSERT INTO gpkg_geometry_columns VALUES
  ('entree','geom','POINT',2154,0,0);


--------------------------------------------------------------------
-- PASSAGE_SELECTIF (classe 3.3.15)
-- intégrant les attributs et la géométrie du noeud_cheminement
--------------------------------------------------------------------
DROP TABLE IF EXISTS passage_selectif;
CREATE TABLE passage_selectif (
  idpassageeelectif TEXT NOT NULL PRIMARY KEY,
  -- Attributs NOEUD_CHEMINEMENT
  idnoeud TEXT NOT NULL,
  altitude REAL,
  bandeEveilVigilance TEXT NOT NULL,
  hauteurRessaut REAL NOT NULL,
  abaissePente INTEGER NOT NULL,
  abaisseLargeur REAL NOT NULL,
  masqueCovisibilite TEXT NOT NULL,
  controleBev TEXT NOT NULL,
  bandeInterception BOOLEAN,
  -- Attributs PASSAGE_SELECTIF
  passageMecanique BOOLEAN,
  largeurUtile REAL NOT NULL,
  profondeur REAL NOT NULL,
  contrasteVisuel BOOLEAN NOT NULL,
  -- Géométrie
  geom POINT NOT NULL,
  -- Contraintes de références
  CONSTRAINT fk_passage_noeud               FOREIGN KEY (idnoeud)             REFERENCES noeud_cheminement(idnoeud),
  CONSTRAINT fk_bandeEveilVigilance_passage FOREIGN KEY (bandeEveilVigilance) REFERENCES enum_etat(valeur),
  CONSTRAINT fk_masqueCovisibilite_passage  FOREIGN KEY (masqueCovisibilite)  REFERENCES enum_masque_covisibilite(valeur),
  CONSTRAINT fk_controleBev_passage         FOREIGN KEY (controleBev)         REFERENCES enum_controle_bev(valeur)
);

-- Ajout à la table gpkg_contents
INSERT INTO gpkg_contents VALUES
  ('passage_selectif','features','passage_selectif','Table géométrique des passages sélectifs',(datetime('now')),NULL,NULL,NULL,NULL,2154);

-- Ajout à la table gpkg_geometry_columns
INSERT INTO gpkg_geometry_columns VALUES
  ('passage_selectif','geom','POINT',2154,0,0);


----------------------------------------------------------------
-- QUAI (classe 3.3.16)
-- intégrant les attributs et la géométrie du tronçon
-- <!> par ChatGPT
----------------------------------------------------------------
DROP TABLE IF EXISTS quai;
CREATE TABLE quai (
  idquai                TEXT PRIMARY KEY NOT NULL,
  -- Attributs TRONÇON
  idtroncon             TEXT NOT NULL,
  'from'                TEXT NOT NULL,
  'to'                  TEXT NOT NULL,
  longueur              INTEGER NOT NULL,
  typeTroncon           TEXT NOT NULL,
  statutVoie            TEXT NOT NULL,
  pente                 TINYINT NOT NULL,
  devers                INTEGER NOT NULL,
  urlMedia              TEXT,
  -- Attributs QUAI
  etatRevetement        TEXT NOT NULL,
  hauteur               REAL NOT NULL,
  largeurPassage        REAL NOT NULL,
  signalisationPorte    TEXT,
  dispositifVigilance   TEXT NOT NULL,
  diamZoneManoeuvre     REAL NOT NULL,
  -- Géométrie
  geom                  LINESTRING NOT NULL,
  -- Contraintes de références
  CONSTRAINT fk_quai_troncon   FOREIGN KEY (idtroncon) REFERENCES troncon_cheminement(idtroncon),
  CONSTRAINT fk_from           FOREIGN KEY ('from') REFERENCES noeud_cheminement(idnoeud),
  CONSTRAINT fk_to             FOREIGN KEY ('to')   REFERENCES noeud_cheminement(idnoeud),
  CONSTRAINT fk_typeTroncon    FOREIGN KEY (typeTroncon)        REFERENCES enum_type_troncon(valeur),
  CONSTRAINT fk_statutVoie     FOREIGN KEY (statutVoie)         REFERENCES enum_statut_voie(valeur),
  CONSTRAINT fk_etatRev_quai   FOREIGN KEY (etatRevetement)     REFERENCES enum_etat_revetement(valeur),
  CONSTRAINT fk_signa_porte    FOREIGN KEY (signalisationPorte) REFERENCES enum_dispositif_signalisation(valeur),
  CONSTRAINT fk_vigi_quai      FOREIGN KEY (dispositifVigilance)REFERENCES enum_etat(valeur)
);

-- Ajout à la table gpkg_contents
INSERT INTO gpkg_contents
VALUES ('quai','features','quai','Table géométrique des quais',(datetime('now')),NULL,NULL,NULL,NULL,2154);

-- Ajout à la table gpkg_geometry_columns
INSERT INTO gpkg_geometry_columns
VALUES ('quai','geom','LINESTRING',2154,0,0);

--------------------------------------------------------------------
-- STATIONNEMENT_PMR (classe 3.3.17)
-- intégrant les attributs et la géométrie du noeud_cheminement
-- <!> par ChatGPT
--------------------------------------------------------------------
DROP TABLE IF EXISTS stationnement_pmr;
CREATE TABLE stationnement_pmr (
  idstationnementpmr TEXT NOT NULL PRIMARY KEY,

  -- Attributs NOEUD_CHEMINEMENT (hérités)
  idnoeud TEXT NOT NULL,
  altitude REAL,
  bandeEveilVigilance TEXT NOT NULL,
  hauteurRessaut REAL NOT NULL,
  abaissePente INTEGER NOT NULL,
  abaisseLargeur REAL NOT NULL,
  masqueCovisibilite TEXT NOT NULL,
  controleBev TEXT NOT NULL,
  bandeInterception BOOLEAN,

  -- Attributs spécifiques STATIONNEMENT_PMR (§3.3.17, ordre du tableur)
  typeStationnement TEXT NOT NULL,      -- enum: type_stationnementpmr
  etatRevetement     TEXT NOT NULL,     -- enum: etat_revetement
  largeurStat        REAL NOT NULL,
  longueurStat       REAL NOT NULL,
  bandLatSecurite    BOOLEAN,
  surLongueur        REAL NOT NULL,
  signalPMR          BOOLEAN NOT NULL,
  marquageSol        BOOLEAN NOT NULL,
  pente              INTEGER NOT NULL,
  devers             INTEGER NOT NULL,
  typeSol            TEXT,              -- enum: type_sol (optionnel)
  iderp              TEXT NOT NULL,     -- identifiant ERP (obligatoire)

  -- Géométrie
  geom POINT NOT NULL,

  -- Contraintes de références
  CONSTRAINT fk_stationnementpmr_noeud                FOREIGN KEY (idnoeud)             REFERENCES noeud_cheminement(idnoeud),
  CONSTRAINT fk_bandeEveilVigilance_stationnementpmr  FOREIGN KEY (bandeEveilVigilance) REFERENCES enum_etat(valeur),
  CONSTRAINT fk_masqueCovisibilite_stationnementpmr   FOREIGN KEY (masqueCovisibilite)  REFERENCES enum_masque_covisibilite(valeur),
  CONSTRAINT fk_controleBev_stationnementpmr          FOREIGN KEY (controleBev)         REFERENCES enum_controle_bev(valeur),

  CONSTRAINT fk_typeStationnementpmr_stationnementpmr FOREIGN KEY (typeStationnement)   REFERENCES enum_type_stationnementpmr(valeur),
  CONSTRAINT fk_etatRevetement_stationnementpmr       FOREIGN KEY (etatRevetement)      REFERENCES enum_etat_revetement(valeur),
  CONSTRAINT fk_typeSol_stationnementpmr              FOREIGN KEY (typeSol)             REFERENCES enum_type_sol(valeur)
);

-- Ajout à la table gpkg_contents
INSERT INTO gpkg_contents VALUES
  ('stationnement_pmr','features','stationnement_pmr','Table géométrique des stationnements PMR',(datetime('now')),NULL,NULL,NULL,NULL,2154);

-- Ajout à la table gpkg_geometry_columns
INSERT INTO gpkg_geometry_columns VALUES
  ('stationnement_pmr','geom','POINT',2154,0,0);

--------------------------------------------------------------------
-- ERP (classe 3.3.18)
-- Table alphanumérique (sans géométrie)
-- <!> par ChatGPT
--------------------------------------------------------------------
DROP TABLE IF EXISTS erp;
CREATE TABLE erp (
  iderp TEXT NOT NULL PRIMARY KEY,

  -- Attributs ERP (ordre §3.3.18)
  nom TEXT NOT NULL,
  adresse TEXT NOT NULL,
  codePostal TEXT NOT NULL,
  erpCategorie TEXT NOT NULL,       -- enum_categorie_erp
  erpType TEXT NOT NULL,            -- enum_type_erp
  dateMiseAJour DATE,
  sourceMiseAJour TEXT,
  stationnementERP BOOLEAN NOT NULL,
  stationnementPMR INTEGER NOT NULL,
  accueilPersonnel TEXT,            -- enum_personnel_erp
  accueilBIM BOOLEAN NOT NULL,
  accueilBIMPortative BOOLEAN NOT NULL,
  accueilLSF BOOLEAN NOT NULL,
  accueilST BOOLEAN NOT NULL,
  accueilAideAudition BOOLEAN NOT NULL,
  accueilPrestations TEXT,
  sanitairesERP BOOLEAN NOT NULL,
  sanitairesAdaptes INTEGER NOT NULL,
  telephone TEXT NOT NULL,
  siteWeb TEXT,
  siret TEXT NOT NULL,
  latitude REAL NOT NULL,
  longitude REAL NOT NULL,
  erpActivite TEXT,                 -- enum_erp_activite
 
 -- Géométrie 
  geom POLYGON NOT NULL,

  -- Contraintes de références
  CONSTRAINT fk_erpCategorie     FOREIGN KEY (erpCategorie)    REFERENCES enum_categorie_erp(valeur),
  CONSTRAINT fk_erpType          FOREIGN KEY (erpType)         REFERENCES enum_type_erp(valeur),
  CONSTRAINT fk_accueilPersonnel FOREIGN KEY (accueilPersonnel) REFERENCES enum_personnel_erp(valeur),
  CONSTRAINT fk_erpActivite      FOREIGN KEY (erpActivite)     REFERENCES enum_erp_activite(valeur)
);

-- Ajout à la table gpkg_contents
INSERT INTO gpkg_contents VALUES
  ('erp','features','erp','Table géométrique surfacique des ERP',(datetime('now')),NULL,NULL,NULL,NULL,2154);

-- Ajout à la table gpkg_geometry_columns
INSERT INTO gpkg_geometry_columns VALUES
  ('erp','geom','POLYGON',2154,0,0);


--------------------------------------------------------------------
-- CHEMINEMENT_ERP (classe 3.3.19)
-- Table alphanumérique (sans géométrie)
-- <!> par ChatGPT
--------------------------------------------------------------------
DROP TABLE IF EXISTS cheminement_erp;
CREATE TABLE cheminement_erp (
  idcheminementerp  TEXT NOT NULL PRIMARY KEY,
  iderp TEXT NOT NULL, 
  -- Attributs de Cheminement_ERP
  departChemStat BOOLEAN NOT NULL,
  arriveeChemAcc BOOLEAN NOT NULL,
  identreedep TEXT NOT NULL,
  identreearr TEXT NOT NULL,
  typeSol TEXT,                     -- enum_type_sol (optionnel)
  largeurUtile REAL NOT NULL,
  hautRessaut REAL NOT NULL,
  rampe TEXT,                       -- enum_rampe_erp (optionnel)
  rampeSonnette BOOLEAN,
  ascenseur BOOLEAN NOT NULL,
  escalierNbMarche INTEGER NOT NULL,
  escalierMainCourante BOOLEAN NOT NULL,
  escalierDescendant INTEGER NOT NULL,
  penteCourte INTEGER NOT NULL,
  penteMoyenne INTEGER NOT NULL,
  penteLongue INTEGER NOT NULL,
  devers INTEGER NOT NULL,
  reperageEltsVitres BOOLEAN NOT NULL,
  sysGuidVisuel BOOLEAN NOT NULL,
  sysGuidTactile BOOLEAN NOT NULL,
  sysGuidSonore BOOLEAN NOT NULL,
  exterieur BOOLEAN,                -- optionnel

  -- Contraintes de références
  CONSTRAINT fk_cheminement_erp     FOREIGN KEY (iderp)        REFERENCES erp(iderp),
  CONSTRAINT fk_cheminement_depart  FOREIGN KEY (identreedep)  REFERENCES entree(identree),
  CONSTRAINT fk_cheminement_arrivee  FOREIGN KEY (identreearr) REFERENCES entree(identree),
  CONSTRAINT fk_typeSol_chemerp     FOREIGN KEY (typeSol)      REFERENCES enum_type_sol(valeur),
  CONSTRAINT fk_rampe_chemerp       FOREIGN KEY (rampe)        REFERENCES enum_rampe_erp(valeur)
);

-- Ajout à la table gpkg_contents (type = attributes car pas de géométrie)
INSERT INTO gpkg_contents VALUES
  ('cheminement_erp','attributes','cheminement_erp','Table alphanumérique des cheminements ERP',(datetime('now')),NULL,NULL,NULL,NULL,NULL);



--------------------------------------------------------------------
-- Création de la table relation_cheminement_troncon
--------------------------------------------------------------------

DROP TABLE IF EXISTS relation_cheminement_troncon;
CREATE TABLE relation_cheminement_troncon ( 
  idcheminement TEXT NOT NULL PRIMARY KEY, 
  idtroncon TEXT NOT NULL
    -- Contraintes de références
--  CONSTRAINT fk_cheminement_relation_troncon     FOREIGN KEY (idcheminement)    REFERENCES cheminement(idcheminement),
--  CONSTRAINT fk_troncon_relation_cheminement     FOREIGN KEY (idtroncon)        REFERENCES troncon_cheminement(idtroncon), 
);
-- Ajout à la table gpkg_contents
INSERT INTO gpkg_contents VALUES 
  ('relation_cheminement_troncon','attributes','relation_cheminement_troncon','table de relation entre cheminemnt et tronçon',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

--------------------------------------------------------------------
-- Création de la table relation_noeud_stationnementpmr
--------------------------------------------------------------------

DROP TABLE IF EXISTS relation_noeud_stationnementpmr;
CREATE TABLE relation_noeud_stationnementpmr ( 
  idnoeud TEXT NOT NULL PRIMARY KEY, 
  idstationnementpmr TEXT NOT NULL
    -- Contraintes de références
--  CONSTRAINT fk_noeud_relation_stationnementpmr     FOREIGN KEY (idnoeud)    REFERENCES noeud_cheminement(idnoeud),
--  CONSTRAINT fk_stationnementpmr_relation_noeud     FOREIGN KEY (idstationnementpmr)  REFERENCES stationnement_pmr(idstationnementpmr), 
);
-- Ajout à la table gpkg_contents
INSERT INTO gpkg_contents VALUES 
  ('relation_noeud_stationnementpmr','attributes','relation_noeud_stationnementpmr','table de relation entre noeud et stationnementpmr',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

--------------------------------------------------------------------
-- Création de la table relation_entree_erp
--------------------------------------------------------------------

DROP TABLE IF EXISTS relation_entree_erp;
CREATE TABLE relation_entree_erp ( 
  identree TEXT NOT NULL PRIMARY KEY, 
  iderp TEXT NOT NULL
    -- Contraintes de références
--  CONSTRAINT fk_entree_relation_erp     FOREIGN KEY (identree)  REFERENCES entree(identree),
--  CONSTRAINT fk_erp_relation_entree     FOREIGN KEY (iderp)     REFERENCES erp(iderp), 
);
-- Ajout à la table gpkg_contents
INSERT INTO gpkg_contents VALUES 
  ('relation_entree_erp','attributes','relation_entree_erp','table de relation entre entree et erp',(datetime('now')),NULL,NULL,NULL,NULL,NULL)
;

--------------------------------------------------------------------
--- TEST DE CREATION DE VUES
--------------------------------------------------------------------

--------------------------------------------------------------------
-- VUE TRAVERSEE utilisable dans QGIS (avec CAST sur la géométrie)
--------------------------------------------------------------------

-- DROP VIEW IF EXISTS vue_traversee;

-- CREATE VIEW vue_traversee AS
-- SELECT
--      t.idtraversee,
--     t.idtroncon,
--     t."from",
--     t."to",
--     t.longueur,
--     t.typeTroncon,
--     t.statutVoie,
--     t.pente,
--     t.devers,
--     t.urlMedia,
--     t.etatRevetement,
--     t.typeMarquage,
--     t.etatMarquage,
--     t.eclairage,
-- t.feuPietons,
--     t.aideSonore,
--     t.repereLineaire,
--     t.chausseeBombee,
--     t.voiesTraversees,
--     CAST(t.geom AS BLOB) AS geom,   -- <<< forcer en géométrie GPKG
--     tc.largeurUtile,
--     tc.penteLongitudinale,
--     tc.penteTransversale,
--     tc.surface,
--     tc.etatRevetement AS etatRevetementTroncon
-- FROM traversee t
-- JOIN troncon_cheminement tc
--   ON t.idtroncon = tc.idtroncon;

--------------------------------------------------------------------
-- Déclaration de la vue comme une couche géométrique
--------------------------------------------------------------------
-- DELETE FROM gpkg_geometry_columns WHERE table_name = 'vue_traversee';
-- DELETE FROM gpkg_contents WHERE table_name = 'vue_traversee';
-- 
-- INSERT INTO gpkg_contents
-- VALUES ('vue_traversee','features','vue_traversee',
 --        'Vue enrichie des traversées avec attributs de tronçon',
--         (datetime('now')),NULL,NULL,NULL,NULL,2154);
-- 
-- INSERT INTO gpkg_geometry_columns
-- VALUES ('vue_traversee','geom','LINESTRING',2154,0,0);


