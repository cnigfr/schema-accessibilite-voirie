--====================================================================================================================================--
-- Titre : Script pour la création d'un schema du Standard CNIG Accessibilité sous PostgreSQL/PostGIS --------------------------------
-- Auteur : Jean-Marie FAVREAU pour la version 2021-10, Arnauld GALLAIS (CEREMA) et Gauvain DUMONT (Mobhilis) - GT CNIG Accessibilité --
-- Version : Standard CNIG Accessibilité v2021-10 révision 2025-03 ---------------------------------------------------------------------
-- Système de référence spatial : RGF93 - Lambert 93 - EPSG 2154 -----------------------------------------------------------------------
-- Date : 23/10/2025 -------------------------------------------------------------------------------------------------------------------
--====================================================================================================================================--

--===============--
-- Configuration --
--===============--
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;
SET default_tablespace = '';
SET default_table_access_method = heap;

--========--
-- Schema --
--========--

--DROP SCHEMA IF EXISTS cnig_accessibilite;
CREATE SCHEMA IF NOT EXISTS cnig_accessibilite;
COMMENT ON SCHEMA cnig_accessibilite IS 'Schema du Standard CNIG Accessibilité sous PostgreSQL/PostGIS - v2021-10 révision 2025-03';
SET search_path TO 'public', 'cnig_accessibilite';
ALTER SCHEMA cnig_accessibilite OWNER TO usr_admin;
GRANT ALL ON SCHEMA cnig_accessibilite TO usr_admin WITH GRANT OPTION;
GRANT USAGE ON SCHEMA cnig_accessibilite TO usr_edit;
GRANT USAGE ON SCHEMA cnig_accessibilite TO usr_read;

--=====================--
-- Fonctions générales
--=====================--

-- Name: update_usr_cre(); Type: FUNCTION; Schema: cnig_accessibilite; Owner: usr_admin
CREATE OR REPLACE FUNCTION cnig_accessibilite.update_usr_cre() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.usr_cre := "current_user"();
    RETURN NEW;
END;
$$;
ALTER FUNCTION cnig_accessibilite.update_usr_cre() OWNER TO usr_admin;

-- Name: update_dat_cre(); Type: FUNCTION; Schema: cnig_accessibilite; Owner: usr_admin
CREATE OR REPLACE  FUNCTION cnig_accessibilite.update_dat_cre() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.dat_cre := "now"()+ '2 HOUR'::interval;
    RETURN NEW;
END;
$$;
ALTER FUNCTION cnig_accessibilite.update_dat_cre() OWNER TO usr_admin;

-- Name: update_usr_mod(); Type: FUNCTION; Schema: cnig_accessibilite; Owner: usr_admin
CREATE OR REPLACE  FUNCTION cnig_accessibilite.update_usr_mod() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.usr_mod := "current_user"();
    RETURN NEW;
END;
$$;
ALTER FUNCTION cnig_accessibilite.update_usr_mod() OWNER TO usr_admin;

-- Name: update_dat_mod(); Type: FUNCTION; Schema: cnig_accessibilite; Owner: usr_admin
CREATE OR REPLACE  FUNCTION cnig_accessibilite.update_dat_mod() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.dat_mod := "now"()+ '2 HOUR'::interval;
    RETURN NEW;
END;
$$;
ALTER FUNCTION cnig_accessibilite.update_dat_mod() OWNER TO usr_admin;

-- Name: create_id('VARCHAR(5)','VARCHAR(3)','VARCHAR'); Type: FUNCTION; Schema: cnig_accessibilite; Owner: usr_admin
CREATE OR REPLACE FUNCTION cnig_accessibilite.create_id(codespace VARCHAR(5), codeclasse VARCHAR(3), identifianttechnique VARCHAR) 
RETURNS VARCHAR
AS $$
SELECT format('%s:%s:%s:LOC', $1, $2, $3);
$$ LANGUAGE SQL;
ALTER FUNCTION cnig_accessibilite.create_id(codespace VARCHAR(5), codeclasse VARCHAR(3), identifianttechnique VARCHAR) OWNER TO usr_admin;


-- Name: update_controlebev(); Type: FUNCTION; Schema: cnig_accessibilite; Owner: usr_admin
CREATE OR REPLACE FUNCTION cnig_accessibilite.update_controlebev() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW."bandeEveilVigilance" = 'absence' THEN
        NEW."controleBEV" := 'sans objet';
    ELSE
        NEW."controleBEV" = OLD."controleBEV";
    END IF;
    RETURN NEW;
END;
$$;
ALTER FUNCTION cnig_accessibilite.update_controlebev() OWNER TO usr_admin;

-- Name: update_rappelobstacle(); Type: FUNCTION; Schema: cnig_accessibilite; Owner: usr_admin
CREATE OR REPLACE FUNCTION cnig_accessibilite.update_rappelobstacle() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW."positionObstacle" = 'en saillie' AND NEW."rappelObstacle" := 'NC' THEN
        NEW."rappelObstacle" := 'sans objet';
    ELSE
        NEW."rappelObstacle" = OLD."rappelObstacle";
    END IF;
    RETURN NEW;
END;
$$;
ALTER FUNCTION cnig_accessibilite.update_rappelobstacle() OWNER TO usr_admin;

-- Name: update_etatMarquage(); Type: FUNCTION; Schema: cnig_accessibilite; Owner: usr_admin
CREATE OR REPLACE FUNCTION cnig_accessibilite.update_etatMarquage() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW."typeMarquage" = 'aucun' THEN
        NEW."etatMarquage" := 'absence';
    ELSE
        NEW."etatMarquage" = OLD."etatMarquage";
    END IF;
    RETURN NEW;
END;
$$;
ALTER FUNCTION cnig_accessibilite.update_etatMarquage() OWNER TO usr_admin;

-- Name: update_rampeSonnette(); Type: FUNCTION; Schema: cnig_accessibilite; Owner: usr_admin
CREATE OR REPLACE FUNCTION cnig_accessibilite.update_rampeSonnette() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.rampe = 'absence' THEN
        NEW."rampeSonnette" := FALSE;
    ELSE
        NEW."rampeSonnette" = OLD."rampeSonnette";
    END IF;
    RETURN NEW;
END;
$$;
ALTER FUNCTION cnig_accessibilite.update_rampeSonnette() OWNER TO usr_admin;

-- Name: update_escalierMainCourante(); Type: FUNCTION; Schema: cnig_accessibilite; Owner: usr_admin
CREATE OR REPLACE FUNCTION cnig_accessibilite.update_escalierMainCourante() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW."escalierNbMarche" = 0 THEN
        NEW."escalierMainCourante" := 'aucun';
    ELSE
        NEW."escalierMainCourante" = OLD."escalierMainCourante";
    END IF;
    RETURN NEW;
END;
$$;
ALTER FUNCTION cnig_accessibilite.update_escalierMainCourante() OWNER TO usr_admin;

-- Name: update_largManoeuvreExt(); Type: FUNCTION; Schema: cnig_accessibilite; Owner: usr_admin
CREATE OR REPLACE FUNCTION cnig_accessibilite.update_largManoeuvreExt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW."largManoeuvreExt" > 1.8 THEN
        NEW."largManoeuvreExt" := 9999;
    ELSE
        NEW."largManoeuvreExt" = OLD."largManoeuvreExt";
    END IF;
    RETURN NEW;
END;
$$;
ALTER FUNCTION cnig_accessibilite.update_largManoeuvreExt() OWNER TO usr_admin;

-- Name: update_longManoeuvreExt(); Type: FUNCTION; Schema: cnig_accessibilite; Owner: usr_admin
CREATE OR REPLACE FUNCTION cnig_accessibilite.update_longManoeuvreExt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW."longManoeuvreExt" > 1.8 THEN
        NEW."longManoeuvreExt" := 9999;
    ELSE
        NEW."longManoeuvreExt" = OLD."longManoeuvreExt";
    END IF;
    RETURN NEW;
END;
$$;
ALTER FUNCTION cnig_accessibilite.update_longManoeuvreExt() OWNER TO usr_admin;

-- Name: update_largManoeuvreInt(); Type: FUNCTION; Schema: cnig_accessibilite; Owner: usr_admin
CREATE OR REPLACE FUNCTION cnig_accessibilite.update_largManoeuvreInt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW."largManoeuvreInt" > 1.8 THEN
        NEW."largManoeuvreInt" := 9999;
    ELSE
        NEW."largManoeuvreInt" = OLD."largManoeuvreInt";
    END IF;
    RETURN NEW;
END;
$$;
ALTER FUNCTION cnig_accessibilite.update_largManoeuvreInt() OWNER TO usr_admin;

-- Name: update_longManoeuvreInt(); Type: FUNCTION; Schema: cnig_accessibilite; Owner: usr_admin
CREATE OR REPLACE FUNCTION cnig_accessibilite.update_longManoeuvreInt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW."longManoeuvreInt" > 1.8 THEN
        NEW."longManoeuvreInt" := 9999;
    ELSE
        NEW."longManoeuvreInt" = OLD."longManoeuvreInt";
    END IF;
    RETURN NEW;
END;
$$;
ALTER FUNCTION cnig_accessibilite.update_longManoeuvreInt() OWNER TO usr_admin;

-- Name: update_stationnementPMR(); Type: FUNCTION; Schema: cnig_accessibilite; Owner: usr_admin
CREATE OR REPLACE FUNCTION cnig_accessibilite.update_stationnementPMR() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW."stationnementERP" IS FALSE THEN
        NEW."stationnementPMR" := 0;
    ELSE
        NEW."stationnementPMR" = OLD."stationnementPMR";
    END IF;
    RETURN NEW;
END;
$$;
ALTER FUNCTION cnig_accessibilite.update_stationnementPMR() OWNER TO usr_admin;

-- Name: update_sanitairesAdaptes(); Type: FUNCTION; Schema: cnig_accessibilite; Owner: usr_admin
CREATE OR REPLACE FUNCTION cnig_accessibilite.update_sanitairesAdaptes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW."sanitairesERP" IS FALSE THEN
        NEW."sanitairesAdaptes" := 0;
    ELSE
        NEW."sanitairesAdaptes" = OLD."sanitairesAdaptes";
    END IF;
    RETURN NEW;
END;
$$;
ALTER FUNCTION cnig_accessibilite.update_sanitairesAdaptes() OWNER TO usr_admin;

-- Name: update_dEntreeDeip(); Type: FUNCTION; Schema: cnig_accessibilite; Owner: usr_admin
CREATE OR REPLACE FUNCTION cnig_accessibilite.update_idEntreeDep() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW."départChemStat" IS TRUE THEN
        NEW."update_idEntreeDep" := NULL;
    ELSE
        NEW."update_idEntreeDep" = OLD."update_idEntreeDep";
    END IF;
    RETURN NEW;
END;
$$;
ALTER FUNCTION cnig_accessibilite.update_idEntreeDep() OWNER TO usr_admin;

-- Name: update_idEntreeArr(); Type: FUNCTION; Schema: cnig_accessibilite; Owner: usr_admin
CREATE OR REPLACE FUNCTION cnig_accessibilite.update_idEntreeArr() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW."arrivéeChemAcc" IS TRUE THEN
        NEW."idEntreeArr" := NULL;
    ELSE
        NEW."idEntreeArr" = OLD."idEntreeArr";
    END IF;
    RETURN NEW;
END;
$$;
ALTER FUNCTION cnig_accessibilite.update_idEntreeArr() OWNER TO usr_admin;

-- Name: update_rampeSonnette(); Type: FUNCTION; Schema: cnig_accessibilite; Owner: usr_admin
CREATE OR REPLACE FUNCTION cnig_accessibilite.update_rampeSonnette() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.rampe = 'absence' THEN
        NEW."rampeSonnette" := FALSE;
    ELSE
        NEW."rampeSonnette" = OLD."rampeSonnette";
    END IF;
    RETURN NEW;
END;
$$;
ALTER FUNCTION cnig_accessibilite.update_rampeSonnette() OWNER TO usr_admin;

-- Name: update_ascenseur(); Type: FUNCTION; Schema: cnig_accessibilite; Owner: usr_admin
CREATE OR REPLACE FUNCTION cnig_accessibilite.update_ascenseur() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW."hautRessaut" = 0 THEN
        NEW.ascenseur := FALSE;
    ELSE
        NEW.ascenseur = OLD.ascenseur;
    END IF;
    RETURN NEW;
END;
$$;
ALTER FUNCTION cnig_accessibilite.update_ascenseur() OWNER TO usr_admin;

-- Name: update_escalierNbMarche(); Type: FUNCTION; Schema: cnig_accessibilite; Owner: usr_admin
CREATE OR REPLACE FUNCTION cnig_accessibilite.update_escalierNbMarche() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW."hautRessaut" = 0 THEN
        NEW."escalierNbMarche" := 0;
    ELSE
        NEW."escalierNbMarche" = OLD."escalierNbMarche";
    END IF;
    RETURN NEW;
END;
$$;
ALTER FUNCTION cnig_accessibilite.update_escalierNbMarche() OWNER TO usr_admin;

-- Name: update_escalierMainCourante(); Type: FUNCTION; Schema: cnig_accessibilite; Owner: usr_admin
CREATE OR REPLACE FUNCTION cnig_accessibilite.update_escalierMainCourante() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW."hautRessaut" = 0 THEN
        NEW."escalierMainCourante" := FALSE;
    ELSE
        NEW."escalierMainCourante" = OLD."escalierMainCourante";
    END IF;
    RETURN NEW;
END;
$$;
ALTER FUNCTION cnig_accessibilite.update_escalierMainCourante() OWNER TO usr_admin;

--==============--
-- Enumerations --
--==============--

------------------------------------------------------
-- Type énuméré : catégorie ERP - attribut de : ERP --
------------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_categorie_erp CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_categorie_erp (
    valeur VARCHAR(11) NOT NULL PRIMARY KEY
    , definition VARCHAR(13)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_categorie_erp
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_categorie_erp TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_categorie_erp TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_categorie_erp TO usr_read;
COMMENT ON TABLE cnig_accessibilite.enum_categorie_erp
    IS 'Type énuméré : catégorie ERP - attribut de : ERP';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_categorie_erp FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_categorie_erp FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_categorie_erp FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_categorie_erp FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_categorie_erp VALUES
    ('catégorie 1',''),
    ('catégorie 2',''),
    ('catégorie 3',''),
    ('catégorie 4',''),
    ('catégorie 5',''),
    ('NC','non renseigné'),
    ('sans objet','')
;

------------------------------------------------------------
-- Type énuméré : contrôle d’accès - attribut de : ENTREE --
------------------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_controle_acces CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_controle_acces (
    valeur VARCHAR(29) NOT NULL PRIMARY KEY
    , definition VARCHAR(13)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_controle_acces
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_controle_acces TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_controle_acces TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_controle_acces TO usr_read;
COMMENT ON TABLE cnig_accessibilite.enum_controle_acces
    IS 'Type énuméré : contrôle d’accès - attribut de : ENTREE';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_controle_acces FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_controle_acces FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_controle_acces FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_controle_acces FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_controle_acces VALUES
    ('absence',''), 	
    ('bouton d''appel',''),
    ('interphone',''),	
    ('visiophone',''),	
    ('boucle à induction magnétique','BIM'),
    ('NC','non renseigné'),
    ('sans objet','')
;

--------------------------------------------------------
-- Type énuméré : contrôle BEV - attribut de :  NOEUD --
--------------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_controle_bev CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_controle_bev (
    valeur VARCHAR(23) NOT NULL PRIMARY KEY
    , definition VARCHAR(13)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_controle_bev
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_controle_bev TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_controle_bev TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_controle_bev TO usr_read;
COMMENT ON TABLE cnig_accessibilite.enum_controle_bev
    IS 'Type énuméré : contrôle BEV - attribut de :  NOEUD';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_controle_bev FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_controle_bev FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_controle_bev FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_controle_bev FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_controle_bev VALUES
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

---------------------------------------------------------------------------------------------
-- Type énuméré : coté - attribut de : RAMPE ACCES, ESCALIER, ASCENSEUR, ENTREE, ELEVATEUR --
---------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_cote CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_cote (
    valeur VARCHAR(14) NOT NULL PRIMARY KEY
    , definition VARCHAR(171)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_cote
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_cote TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_cote TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_cote TO usr_read;
COMMENT ON TABLE cnig_accessibilite.enum_cote
    IS 'Type énuméré : coté - attribut de : RAMPE ACCES, ESCALIER, ASCENSEUR, ENTREE, ELEVATEUR';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_cote FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_cote FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_cote FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_cote FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_cote VALUES
    ('aucun',''),
    ('à droite','par rapport au sens direct du tronçon (nœud initial vers nœud final) pour les objets linéaires, et par rapport au sens "extérieur vers intérieur" pour les objets ponctuels'),
    ('à gauche','par rapport au sens direct du tronçon (nœud initial vers nœud final) pour les objets linéaires, et par rapport au sens "extérieur vers intérieur" pour les objets ponctuels'),
    ('des deux côtés',''),
    ('en face','valeur uniquement utilisable pour l''attribut autrePorteSortie des ascenseurs et élévateurs'),
    ('au milieu',''),
    ('NC','non renseigné'),
    ('sans objet','')
;

---------------------------------------------------------
-- Type énuméré : couvert - attribut de :  CIRCULATION --
---------------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_couvert CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_couvert (
    valeur VARCHAR(21) NOT NULL PRIMARY KEY
    , definition VARCHAR(13)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_couvert
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_couvert TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_couvert TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_couvert TO usr_read;
COMMENT ON TABLE cnig_accessibilite.enum_couvert
    IS 'Type énuméré : couvert - attribut de :  CIRCULATION';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_couvert FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_couvert FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_couvert FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_couvert FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_couvert VALUES
    ('intérieur',''),
    ('extérieur couvert',''),
    ('extérieur non couvert',''),
    ('NC','non renseigné'),
    ('sans objet','')
;

-----------------------------------------------------------------------------
-- Type énuméré : dispositif signalisation - attribut de : QUAI, ASCENSEUR --
-----------------------------------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_dispositif_signalisation CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_dispositif_signalisation (
    valeur VARCHAR(27) NOT NULL PRIMARY KEY
    , definition VARCHAR(13)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_dispositif_signalisation
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_dispositif_signalisation TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_dispositif_signalisation TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_dispositif_signalisation TO usr_read;
COMMENT ON TABLE cnig_accessibilite.enum_dispositif_signalisation
    IS 'Type énuméré : dispositif signalisation - attribut de : QUAI, ASCENSEUR';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_dispositif_signalisation FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_dispositif_signalisation FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_dispositif_signalisation FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_dispositif_signalisation FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_dispositif_signalisation VALUES
    ('aucun',''),
    ('visuel',''),
    ('tactile',''),
    ('sonore',''),
    ('visuel et tactile',''),
    ('visuel et sonore',''),
    ('tactile et sonore',''),
    ('visuel et tactile et sonore',''),
    ('NC','non renseigné'),
    ('sans objet','')
;

------------------------------------------------------------------------------------------
-- Type énuméré : éclairage - attribut de :  CIRCULATION, TRAVERSEE (cf. valeurs NeTEx) --
------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_eclairage CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_eclairage (
    valeur VARCHAR(21) NOT NULL PRIMARY KEY
    , definition VARCHAR(98)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_eclairage
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_eclairage TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_eclairage TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_eclairage TO usr_read;
COMMENT ON TABLE cnig_accessibilite.enum_eclairage
    IS 'Type énuméré : éclairage - attribut de :  CIRCULATION, TRAVERSEE (cf. valeurs NeTEx)';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_eclairage FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_eclairage FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_eclairage FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_eclairage FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_eclairage VALUES
    ('bon éclairage', 'éclairage régulièrement espacé, constamment alimenté et dirigé vers le trottoir'),
    ('éclairage insuffisant', 'éclairage irrégulièrement espacé ou à alimentation intermittente et/ou non dirigé vers le trottoir'),
    ('absence d''éclarage', 'absence de dispositif d’éclairage'),
    ('NC','non renseigné'),
    ('sans objet','')
;

---------------------------------------------------------------------------------------------------------------
-- Type énuméré : état - attribut de : NOEUD, TRAVERSEE, RAMPE, ESCALIER, ESCALATOR, QUAI, STATIONNEMENT PMR --
---------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_etat CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_etat (
    valeur VARCHAR(24) NOT NULL PRIMARY KEY
    , definition VARCHAR(60)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_etat
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_etat TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_etat TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_etat TO usr_read;

COMMENT ON TABLE cnig_accessibilite.enum_etat
    IS 'Type énuméré : état - attribut de : NOEUD, TRAVERSEE, RAMPE, ESCALIER, ESCALATOR, QUAI, STATIONNEMENT PMR';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_etat FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_etat FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_etat FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_etat FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_etat VALUES
    ('absence', 'absence de revêtement, de BEV, etc.'),
    ('bon état', ''),
    ('dégradation sans gravité', ''),
    ('dégradation forte', 'dégradation entraînant une difficulté d''usage ou d''inconfort'),
    ('dégradation très forte', 'dégradation entraînant un problème de sécurité immédiat'),
    ('NC','non renseigné'),
    ('sans objet','')
;

---------------------------------------------------------------
-- Type énuméré : étatRevetement - attribut de : CIRCULATION --
---------------------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_etat_revetement CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_etat_revetement (
    valeur VARCHAR(55) NOT NULL PRIMARY KEY
    , definition VARCHAR(29)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_etat_revetement
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_etat_revetement TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_etat_revetement TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_etat_revetement TO usr_read;
COMMENT ON TABLE cnig_accessibilite.enum_etat_revetement
    IS 'Type énuméré : étatRevetement - attribut de : CIRCULATION';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_etat_revetement FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_etat_revetement FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_etat_revetement FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_etat_revetement FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_etat_revetement VALUES
    ('roulant',''),
    ('dégradation sans gravité',''),
    ('dégradation entrainant un problème de sécurité immédiat',''),
    ('meuble','s''enfonce'),
    ('secouant','secoue, par exemple des pavés'),
    ('glissant',''),
    ('NC','non renseigné'),
    ('sans objet','')
;

--------------------------------------------------------
-- Type énuméré : marquage - attribut de :  TRAVERSEE --
--------------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_marquage CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_marquage (
    valeur VARCHAR(22) NOT NULL PRIMARY KEY
    , definition VARCHAR(118)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_marquage
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_marquage TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_marquage TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_marquage TO usr_read;
COMMENT ON TABLE cnig_accessibilite.enum_marquage
    IS 'Type énuméré : marquage - attribut de :  TRAVERSEE';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_marquage FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_marquage FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_marquage FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_marquage FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_marquage VALUES
    ('aucun',''),
    ('bandes blanches',''),
    ('marques d''animation','(cf. IISR 7ème partie https://equipementsdelaroute.cerema.fr/versions-consolidees-de-2022-des-9-parties-de-l-a528.html'),	
    ('clous métalliques',''),	
    ('revêtement différencié','par exemple : résine'),
    ('autre',''),
    ('NC','non renseigné'),
    ('sans objet','')
;

-------------------------------------------------------------
-- Type énuméré : masqueCovisibilité - attribut de : NOEUD --
-------------------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_masque_covisibilite CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_masque_covisibilite (
    valeur VARCHAR(21) NOT NULL PRIMARY KEY
    , definition VARCHAR(13)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_masque_covisibilite
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_masque_covisibilite TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_masque_covisibilite TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_masque_covisibilite TO usr_read;
COMMENT ON TABLE cnig_accessibilite.enum_masque_covisibilite
    IS 'Type énuméré : masqueCovisibilité - attribut de : NOEUD';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_masque_covisibilite FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_masque_covisibilite FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_masque_covisibilite FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_masque_covisibilite FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_masque_covisibilite VALUES
    ('aucun', ''),
    ('stationnement voiture', ''),
    ('végétation', ''),
    ('bâti', ''),
    ('mobilier urbain', ''),
    ('autre', ''),
    ('NC','non renseigné'),
    ('sans objet','')
;

------------------------------------------------------
-- Type énuméré : personnel ERP - attribut de : ERP --
------------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_personnel_erp CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_personnel_erp (
    valeur VARCHAR(55) NOT NULL PRIMARY KEY
    , definition VARCHAR(13)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_personnel_erp
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_personnel_erp TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_personnel_erp TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_personnel_erp TO usr_read;
COMMENT ON TABLE cnig_accessibilite.enum_personnel_erp
    IS 'Type énuméré : personnel ERP - attribut de : ERP';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_personnel_erp FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_personnel_erp FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_personnel_erp FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_personnel_erp FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_personnel_erp VALUES
    ('absence de personnel',''),
    ('personnel formé à l''accueil des publics spécifiques',''),
    ('personnel non-formé à l''accueil des publics spécifiques',''),
    ('NC','non renseigné'),
    ('sans objet','')
;

-----------------------------------------------------------
-- Type énuméré : position espace - attribut de : ENTREE --
-----------------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_position_espace CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_position_espace (
    valeur VARCHAR(22) NOT NULL PRIMARY KEY
    , definition VARCHAR(13)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_position_espace
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_position_espace TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_position_espace TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_position_espace TO usr_read;
COMMENT ON TABLE cnig_accessibilite.enum_position_espace
    IS 'Type énuméré : position espace - attribut de : ENTREE';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_position_espace FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_position_espace FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_position_espace FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_position_espace FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_position_espace VALUES
    ('absence',''),
    ('extérieur',''),
    ('intérieur',''),
    ('intérieur et extérieur',''),
    ('NC','non renseigné'),
    ('sans objet','')
;

-------------------------------------------------------------------
-- Type énuméré : position hauteur - attribut de : RAMPE ACCES --
-------------------------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_position_hauteur CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_position_hauteur (
    valeur VARCHAR(17) NOT NULL PRIMARY KEY
    , definition VARCHAR(13)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_position_hauteur
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_position_hauteur TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_position_hauteur TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_position_hauteur TO usr_read;
COMMENT ON TABLE cnig_accessibilite.enum_position_hauteur
    IS 'Type énuméré : position hauteur - attribut de : RAMPE ACCES';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_position_hauteur FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_position_hauteur FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_position_hauteur FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_position_hauteur FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_position_hauteur VALUES
    ('absence',''),
    ('en bas',''),
    ('en haut',''),
    ('en haut et en bas',''),
    ('NC','non renseigné'),
    ('sans objet','')
;

---------------------------------------------------------------
-- Type énuméré : position obstacle - attribut de : OBSTACLE --
---------------------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_position_obstacle CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_position_obstacle (
    valeur VARCHAR(20) NOT NULL PRIMARY KEY
    , definition VARCHAR(13)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_position_obstacle
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_position_obstacle TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_position_obstacle TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_position_obstacle TO usr_read;
COMMENT ON TABLE cnig_accessibilite.enum_position_obstacle
    IS 'Type énuméré : position obstacle - attribut de : OBSTACLE';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_position_obstacle FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_position_obstacle FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_position_obstacle FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_position_obstacle FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_position_obstacle VALUES
    ('obstacle en surface',''),
    ('obstacle posé au sol',''),
    ('obstacle en saillie',''),
    ('NC','non renseigné'),
    ('sans objet','')
;

-------------------------------------------------------------
-- Type énuméré : rappel obstacle - attribut de : OBSTACLE --
-------------------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_rappel_obstacle CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_rappel_obstacle (
    valeur VARCHAR(24) NOT NULL PRIMARY KEY
    , definition VARCHAR(25)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_rappel_obstacle
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_rappel_obstacle TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_rappel_obstacle TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_rappel_obstacle TO usr_read;
COMMENT ON TABLE cnig_accessibilite.enum_rappel_obstacle
    IS 'Type énuméré : rappel obstacle - attribut de : OBSTACLE';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_rappel_obstacle FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_rappel_obstacle FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_rappel_obstacle FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_rappel_obstacle FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_rappel_obstacle VALUES
    ('absence de rappel au sol',''),
    ('surépaisseur','hauteur inférieure à 3 cm'),
    ('élément bas','hauteur supérieure à 3 cm'),
    ('NC','non renseigné'),
    ('sans objet','')
;

------------------------------------------------------------------------
-- Type énuméré : rampe ERP - attribut de : ENTREE et CHEMINEMENT ERP --
------------------------------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_rampe_erp CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_rampe_erp (
    valeur VARCHAR(10) NOT NULL PRIMARY KEY
    , definition VARCHAR(13)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_rampe_erp
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_rampe_erp TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_rampe_erp TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_rampe_erp TO usr_read;
COMMENT ON TABLE cnig_accessibilite.enum_rampe_erp
    IS 'Type énuméré : rampe ERP - attribut de : ENTREE et CHEMINEMENT ERP';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_rampe_erp FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_rampe_erp FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_rampe_erp FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_rampe_erp FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_rampe_erp VALUES
    ('fixe',''),
    ('amovible',''),
    ('absence',''),
    ('NC','non renseigné'),
    ('sans objet','')
;

-------------------------------------------------------------
-- Type énuméré : relief boutons - attribut de : ASCENSEUR --
-------------------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_relief_boutons CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_relief_boutons (
    valeur VARCHAR(57) NOT NULL PRIMARY KEY
    , definition VARCHAR(13)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_relief_boutons
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_relief_boutons TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_relief_boutons TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_relief_boutons TO usr_read;
COMMENT ON TABLE cnig_accessibilite.enum_relief_boutons
    IS 'Type énuméré : relief boutons - attribut de : ASCENSEUR';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_relief_boutons FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_relief_boutons FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_relief_boutons FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_relief_boutons FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_relief_boutons VALUES
    ('aucune touche différenciée',''),
    ('touche 0 différenciée par relief supérieur',''),
    ('touche 0 de relief supérieur et autres touches en braille',''),
    ('NC','non renseigné'),
    ('sans objet','')
;

---------------------------------------------------------------------------
-- Type énuméré : repère linéaire - attribut de : CIRCULATION, TRAVERSEE --
---------------------------------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_repere_lineaire CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_repere_lineaire (
    valeur VARCHAR(22) NOT NULL PRIMARY KEY
    , definition VARCHAR(138)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_repere_lineaire
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_repere_lineaire TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_repere_lineaire TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_repere_lineaire TO usr_read;
COMMENT ON TABLE cnig_accessibilite.enum_repere_lineaire
    IS 'Type énuméré : repère linéaire - attribut de : CIRCULATION, TRAVERSEE';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_repere_lineaire FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_repere_lineaire FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_repere_lineaire FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_repere_lineaire FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_repere_lineaire VALUES
    ('aucun',''),
    ('façade ou mur','La distinction mur (02) ou muret (03) se fait suivant le critère de "hauteur d''homme" pour la visibilité et la perception auditive directe'),
    ('bordure ou muret','La distinction mur (02) ou muret (03) se fait suivant le critère de "hauteur d''homme" pour la visibilité et la perception auditive directe'),
    ('revêtement différencié',''),
    ('bande de guidage',''),
    ('autre',''),
    ('NC','non renseigné'),
    ('sans objet','')
;

-------------------------------------------------------
-- Type énuméré : sens - attribut de : TAPIS ROULANT --
-------------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_sens CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_sens (
    valeur VARCHAR(10) NOT NULL PRIMARY KEY
    , definition VARCHAR(41)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_sens
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_sens TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_sens TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_sens TO usr_read;
COMMENT ON TABLE cnig_accessibilite.enum_sens
    IS 'Type énuméré : sens - attribut de : TAPIS ROULANT';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_sens FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_sens FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_sens FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_sens FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_sens VALUES
    ('direct','noeud initial vers noeud final du tronçon'),
    ('indirect','noeud final vers noeud initial du tronçon'),
    ('variable','valeur réservée aux tapis roulants'),
    ('NC','non renseigné'),
    ('sans objet','')
;

---------------------------------------------------------------------------
-- Type énuméré : statut de la voie - attribut de :  TRONCON_CHEMINEMENT --
---------------------------------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_statut_voie CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_statut_voie (
    valeur VARCHAR(59) NOT NULL PRIMARY KEY
    , definition VARCHAR(24)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_statut_voie
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_statut_voie TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_statut_voie TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_statut_voie TO usr_read;
COMMENT ON TABLE cnig_accessibilite.enum_statut_voie
    IS 'Type énuméré : statut de la voie - attribut de :  TRONCON_CHEMINEMENT';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_statut_voie FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_statut_voie FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_statut_voie FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_statut_voie FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_statut_voie VALUES
    ('voie classique','rue, avenue, boulevard'),
    ('zone 30',''),
    ('zone de rencontre',''),	
    ('rue piétonne - aire piétonne - sente piétonne',''),	
    ('voie verte',''),
    ('autre type de voie inscrit au schéma directeur de la voirie',''),	
    ('NC','non renseigné'),
    ('sans objet','')
;

----------------------------------------------------------
-- Type énuméré : temporalité - attribut de : ELEVATEUR --
----------------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_temporalite CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_temporalite (
    valeur VARCHAR(10) NOT NULL PRIMARY KEY
    , definition VARCHAR(13)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_temporalite
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_temporalite TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_temporalite TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_temporalite TO usr_read;
COMMENT ON TABLE cnig_accessibilite.enum_temporalite
    IS 'Type énuméré : temporalité - attribut de : ELEVATEUR';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_temporalite FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_temporalite FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_temporalite FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_temporalite FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_temporalite VALUES
    ('permanent',''),
    ('temporaire',''),
    ('jamais',''),
    ('NC','non renseigné'),
    ('sans objet','')
;

----------------------------------------------------------------------
-- Type énuméré : transition - attribut de : CIRCULATION, ESCALATOR --
----------------------------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_transition CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_transition (
    valeur VARCHAR(27) NOT NULL PRIMARY KEY
    , definition VARCHAR(30)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_transition
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_transition TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_transition TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_transition TO usr_read;
COMMENT ON TABLE cnig_accessibilite.enum_transition
    IS 'Type énuméré : transition - attribut de : CIRCULATION, ESCALATOR';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_transition FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_transition FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_transition FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_transition FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_transition VALUES
    ('montée',''),	
    ('descente',''),
    ('pas de changement de niveau',''),
    ('variable','valeur réservée aux escalators'),
    ('NC','non renseigné'),
    ('sans objet','')
;

------------------------------------------------------------------------------------------------------
-- Type énuméré : type de passage - attribut de :  CIRCULATION (cf. NeTEx / PathLink / PassageType) --
------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_type_passage CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_type_passage (
    valeur VARCHAR(18) NOT NULL PRIMARY KEY
    , definition VARCHAR(16)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_type_passage
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_type_passage TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_type_passage TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_type_passage TO usr_read;
COMMENT ON TABLE cnig_accessibilite.enum_type_passage
    IS 'Type énuméré : type de passage - attribut de :  CIRCULATION (cf. NeTEx / PathLink / PassageType)';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_type_passage FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_type_passage FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_type_passage FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_type_passage FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_type_passage VALUES
    ('en surface',''),	
    ('couloir',''),
    ('aérien','passerelle, pont'),
    ('passage souterrain',''),
    ('tunnel',''),
    ('NC','non renseigné'),
    ('sans objet','')
;

-----------------------------------------------------------
-- Type énuméré : type de poignée - attribut de : ENTREE --
-----------------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_type_poignee CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_type_poignee (
    valeur VARCHAR(17) NOT NULL PRIMARY KEY
    , definition VARCHAR(15)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_type_poignee
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_type_poignee TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_type_poignee TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_type_poignee TO usr_read;
COMMENT ON TABLE cnig_accessibilite.enum_type_poignee
    IS 'Type énuméré : type de poignée - attribut de : ENTREE';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_type_poignee FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_type_poignee FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_type_poignee FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_type_poignee FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_type_poignee VALUES
    ('béquille',''),
    ('bouton',''),
    ('poignée palière',''),	
    ('poignée de tirage',''),	
    ('levier de fenêtre',''),	
    ('bâton maréchal','barre verticale'),
    ('NC','non renseigné'),
    ('sans objet','')
;

----------------------------------------------------------
-- Type énuméré : type de porte - attribut de : ENTREE, --
----------------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_type_porte CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_type_porte (
    valeur VARCHAR(17) NOT NULL PRIMARY KEY
    , definition VARCHAR(28)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_type_porte
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_type_porte TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_type_porte TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_type_porte TO usr_read;
COMMENT ON TABLE cnig_accessibilite.enum_type_porte
    IS 'Type énuméré : type de porte - attribut de : ENTREE,';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_type_porte FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_type_porte FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_type_porte FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_type_porte FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_type_porte VALUES
    ('porte normale',''),
    ('porte coulissante',''),
    ('tourniquet',''),
    ('portillon',''),
    ('portail',''),
    ('porte tambour',''),	
    ('porte battante','ouverture dans les deux sens'),
    ('NC','non renseigné'),
    ('sans objet','')
;

-------------------------------------------------------------------------------------------------------------------
-- Type énuméré : type de tronçon - attribut de : TRONCON_CHEMINEMENT (cf. NeTEx / PathLink / AccessFeatureType) --
-------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_type_troncon CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_type_troncon (
    valeur VARCHAR(30) NOT NULL PRIMARY KEY
    , definition VARCHAR(13)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_type_troncon
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_type_troncon TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_type_troncon TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_type_troncon TO usr_read;

COMMENT ON TABLE cnig_accessibilite.enum_type_troncon
    IS 'Type énuméré : type de tronçon - attribut de : TRONCON_CHEMINEMENT (cf. NeTEx / PathLink / AccessFeatureType)';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_type_troncon FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_type_troncon FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_type_troncon FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_type_troncon FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_type_troncon VALUES
    ('ascenseur',''),
    ('escalator',''),
    ('monte-charge / monte-personne',''),
    ('tapis roulant',''),
    ('rampe',''),
    ('escalier',''),
    ('série d’escaliers',''),
    ('traversée piétonne',''),
    ('îlot de traversée piétonne',''),
    ('présence de barrière(s)',''),
    ('passage étroit',''),
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
    ('navette',''),
    ('NC','non renseigné'),
    ('sans objet','')
;

-------------------------------------------------------
-- Type énuméré : type entrée - attribut de : ENTREE --
-------------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_type_entree CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_type_entree (
    valeur VARCHAR(29) NOT NULL PRIMARY KEY
    , definition VARCHAR(13)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_type_entree
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_type_entree TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_type_entree TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_type_entree TO usr_read;
COMMENT ON TABLE cnig_accessibilite.enum_type_entree
    IS 'Type énuméré : type entrée - attribut de : ENTREE';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_type_entree FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_type_entree FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_type_entree FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_type_entree FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_type_entree VALUES
    ('entrée principale de bâtiment',''),
    ('entrée secondaire de bâtiment',''),
    ('entrée de site',''),
    ('NC','non renseigné'),
    ('sans objet','')
;

-------------------------------------------------
-- Type énuméré : type ERP - attribut de : ERP --
-------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_type_erp CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_type_erp (
    valeur VARCHAR(10) NOT NULL PRIMARY KEY
    , definition VARCHAR(13)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_type_erp
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_type_erp TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_type_erp TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_type_erp TO usr_read;
COMMENT ON TABLE cnig_accessibilite.enum_type_erp
    IS 'Type énuméré : type ERP - attribut de : ERP';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_type_erp FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_type_erp FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_type_erp FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_type_erp FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_type_erp VALUES
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
    ('NC','non renseigné'),
    ('sans objet','')
;

-----------------------------------------------------------
-- Type énuméré : type obstacle - attribut de : OBSTACLE --
-----------------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_type_obstacle CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_type_obstacle (
    valeur VARCHAR(28) NOT NULL PRIMARY KEY
    , definition VARCHAR(13)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_type_obstacle
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_type_obstacle TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_type_obstacle TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_type_obstacle TO usr_read;
COMMENT ON TABLE cnig_accessibilite.enum_type_obstacle
    IS 'Type énuméré : type obstacle - attribut de : OBSTACLE';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_type_obstacle FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_type_obstacle FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_type_obstacle FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_type_obstacle FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_type_obstacle VALUES
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
    ('NC','non renseigné'),
    ('sans objet','')
;

--------------------------------------------------------------------------------
-- Type énuméré : type ouverture - attribut de : ENTREE, ASCENSEUR, ELEVATEUR --
--------------------------------------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_type_ouverture CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_type_ouverture (
    valeur VARCHAR(41) NOT NULL PRIMARY KEY
    , definition VARCHAR(13)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_type_ouverture
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_type_ouverture TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_type_ouverture TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_type_ouverture TO usr_read;
COMMENT ON TABLE cnig_accessibilite.enum_type_ouverture
    IS 'Type énuméré : type ouverture - attribut de : ENTREE, ASCENSEUR, ELEVATEUR';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_type_ouverture FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_type_ouverture FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_type_ouverture FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_type_ouverture FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_type_ouverture VALUES
    ('manuelle',''),
    ('automatique',''),
    ('ouverture manuelle assistée mécaniquement',''),
    ('NC','non renseigné'),
    ('sans objet','')
;

---------------------------------------------------------------------
-- Type énuméré : type stationnement - attribut de : STATIONNEMENT --
---------------------------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_type_stationnement CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_type_stationnement (
    valeur VARCHAR(12) NOT NULL PRIMARY KEY
    , definition VARCHAR(13)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_type_stationnement
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_type_stationnement TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_type_stationnement TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_type_stationnement TO usr_read;
COMMENT ON TABLE cnig_accessibilite.enum_type_stationnement
    IS 'Type énuméré : type stationnement - attribut de : STATIONNEMENT';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_type_stationnement FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_type_stationnement FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_type_stationnement FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_type_stationnement FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_type_stationnement VALUES
    ('longitudinal','créneau'),
    ('bataille',''),
    ('épi',''),
    ('NC','non renseigné'),
    ('sans objet','')
;

---------------------------------------------------------------------------------------------------------------------------------
-- Type énuméré : type sol - attribut de : CIRCULATION, CHEMINEMENT_ERP et STATIONNEMENT PMR (cf. NeTEx / PathLink / Flooring) --
---------------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_type_sol CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_type_sol (
    valeur VARCHAR(18) NOT NULL PRIMARY KEY
    , definition VARCHAR(30)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_type_sol
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_type_sol TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_type_sol TO usr_edit;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_type_sol TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_type_sol TO usr_read;
GRANT SELECT ON TABLE cnig_accessibilite.enum_type_sol TO usr_read;
COMMENT ON TABLE cnig_accessibilite.enum_type_sol
    IS 'Type énuméré : type sol - attribut de : CIRCULATION, CHEMINEMENT_ERP et STATIONNEMENT PMR (cf. NeTEx / PathLink / Flooring)';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_type_sol FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_type_sol FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_type_sol FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_type_sol FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_type_sol VALUES
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

---------------------------------------------------------------
-- Type énuméré : voyant ascenseur - attribut de : ASCENSEUR --
---------------------------------------------------------------
DROP TABLE IF EXISTS cnig_accessibilite.enum_voyant_ascenseur CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.enum_voyant_ascenseur (
    valeur VARCHAR(38) NOT NULL PRIMARY KEY
    , definition VARCHAR(13)
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.enum_voyant_ascenseur
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.enum_voyant_ascenseur TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.enum_voyant_ascenseur TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.enum_voyant_ascenseur TO usr_read;
COMMENT ON TABLE cnig_accessibilite.enum_voyant_ascenseur
    IS 'Type énuméré : voyant ascenseur - attribut de : ASCENSEUR';
--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.enum_voyant_ascenseur FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.enum_voyant_ascenseur FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.enum_voyant_ascenseur FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.enum_voyant_ascenseur FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
INSERT INTO cnig_accessibilite.enum_voyant_ascenseur VALUES
    ('aucun',''),
    ('voyant demande secours enregistrée','vert'),
    ('voyant demande secours en transmission','jaune'),
    ('les deux',''),
    ('NC','non renseigné'),
    ('sans objet','')
;

--===============--
-- Tables objets --
--===============--
-- Attributs de niveau 1: présence et saisie obligatoires (valeur "inconnu, non renseigné" non autorisée)
-- Attributs de niveau 2: présence obligatoire mais saisie factultative
-- Attributs de niveau 3: présence et saisie optionnelles

-----------------------
-- NOEUD_CHEMINEMENT --
-----------------------
DROP SEQUENCE IF EXISTS cnig_accessibilite.noeud_cheminement_seq CASCADE;
CREATE SEQUENCE IF NOT EXISTS cnig_accessibilite.noeud_cheminement_seq AS bigint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE IF EXISTS cnig_accessibilite.noeud_cheminement_seq
    OWNER to usr_admin;
DROP TABLE IF EXISTS cnig_accessibilite.noeud_cheminement CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.noeud_cheminement (
    --gid bigint DEFAULT nextval('cnig_accessibilite.noeud_cheminement_seq'), -- hors standard
    "idNoeud" VARCHAR NOT NULL PRIMARY KEY DEFAULT cnig_accessibilite.create_id('CODESPACE'::VARCHAR(5), 'NOD'::VARCHAR(3), 'CNIG'::VARCHAR || currval('cnig_accessibilite.noeud_cheminement_seq')) -- Niveau 1
    , altitude DOUBLE PRECISION -- Niveau 2
    , "bandeEveilVigilance" VARCHAR NOT NULL DEFAULT 'sans objet' -- Niveau 1
    , "hauteurRessaut" DOUBLE PRECISION NOT NULL -- Niveau 1
    , "abaissePente" INTEGER NOT NULL -- Niveau 1
    , "abaisseLargeur" DOUBLE PRECISION NOT NULL -- Niveau 1
    , "masqueCovisibilite" VARCHAR NOT NULL DEFAULT 'aucun' -- Niveau 1
    , "controleBEV" TEXT -- Niveau 2 (valeur multiple séparateur "|")
    , "bandeInterception" BOOLEAN -- Niveau 3
    , the_geom geometry(MultiPointZ,2154) NOT NULL
    --, photo TEXT -- hors standard
    --, commentaire TEXT -- hors standard
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
    , CONSTRAINT fk_bandeEveilVigilance FOREIGN KEY ("bandeEveilVigilance") REFERENCES cnig_accessibilite.enum_etat(valeur)
    , CONSTRAINT fk_masqueCovisibilite FOREIGN KEY ("masqueCovisibilite") REFERENCES cnig_accessibilite.enum_masque_covisibilite(valeur)
    , CONSTRAINT chk_masqueCovisibilite CHECK ("masqueCovisibilite" <> 'NC')
    , CONSTRAINT fk_controleBev FOREIGN KEY ("controleBEV") REFERENCES cnig_accessibilite.enum_controle_bev(valeur)
);
ALTER TABLE IF EXISTS cnig_accessibilite.noeud_cheminement
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.noeud_cheminement TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.noeud_cheminement TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.noeud_cheminement TO usr_read;
COMMENT ON TABLE cnig_accessibilite.noeud_cheminement
    IS 'Extrémités d''un tronçon de cheminement - NeTEx distingue les Nœuds extrémité (PathLinkEnd) qui peuvent faire référence à des objets complexes, des nœuds permettant la représentation géométrique (gml:lineString). Un nœud extrémité peut être un EquipmentPlace (espace ou se trouve un ou plusieurs équipements). Les nœuds "From" et "To" peuvent être identiques pour traverser une « EquipementPlace»';
--COMMENT ON COLUMN cnig_accessibilite.noeud_cheminement.gid IS 'Identifiant système'; -- hors standard
COMMENT ON COLUMN cnig_accessibilite.noeud_cheminement."idNoeud" IS 'identifiant du nœud de cheminement';
COMMENT ON COLUMN cnig_accessibilite.noeud_cheminement.altitude IS 'altitude du nœud de cheminement. Exprimée en mètre dans le système NGF (https://geodesie.ign.fr/index.php?page=reseaux_nivellement_francais)';
COMMENT ON COLUMN cnig_accessibilite.noeud_cheminement."bandeEveilVigilance" IS 'surface contrastée visuellement et tactilement permettant de signaler un danger';
COMMENT ON COLUMN cnig_accessibilite.noeud_cheminement."hauteurRessaut" IS 'hauteur du ressaut au niveau du nœud de cheminement';
COMMENT ON COLUMN cnig_accessibilite.noeud_cheminement."abaissePente" IS 'pente due à l’inclinaison du trottoir vers l’abaissé de trottoir.';
COMMENT ON COLUMN cnig_accessibilite.noeud_cheminement."abaisseLargeur" IS 'distance sur laquelle la hauteur de bordure de trottoir est réduite à son maximum, hors rampants.';
COMMENT ON COLUMN cnig_accessibilite.noeud_cheminement."masqueCovisibilite" IS 'masque visuel sur 5 m en amont d''une traversée';
COMMENT ON COLUMN cnig_accessibilite.noeud_cheminement."controleBEV" IS 'contrôle de l''état des bandes d''éveil à la vigilance ex : implantée en travers|profondeur insuffisante';
COMMENT ON COLUMN cnig_accessibilite.noeud_cheminement."bandeInterception" IS 'présence de bande d''interception';
COMMENT ON COLUMN cnig_accessibilite.noeud_cheminement.the_geom IS 'Géométrie';
--COMMENT ON COLUMN cnig_accessibilite.noeud_cheminement.photo IS 'Photo'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.noeud_cheminement.commentaire IS 'Commentaire'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.noeud_cheminement.dat_cre IS 'Date de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.noeud_cheminement.dat_mod IS 'Date de modification'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.noeud_cheminement.usr_cre IS 'Utilisateur de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.noeud_cheminement.usr_mod IS 'Utilisateur de modification'; -- hors standard

--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.noeud_cheminement FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.noeud_cheminement FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.noeud_cheminement FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.noeud_cheminement FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
CREATE TRIGGER update_controlebev BEFORE UPDATE ON cnig_accessibilite.noeud_cheminement FOR EACH ROW EXECUTE FUNCTION cnig_accessibilite.update_controlebev();

CREATE INDEX IF NOT EXISTS noeud_cheminement_idnoeud_idx
    ON cnig_accessibilite.noeud_cheminement
    USING btree("idNoeud");

CREATE INDEX IF NOT EXISTS noeud_cheminement_the_geom_idx
    ON cnig_accessibilite.noeud_cheminement
    USING gist(the_geom);

-----------------
-- CHEMINEMENT --
-----------------
DROP SEQUENCE IF EXISTS cnig_accessibilite.cheminement_seq CASCADE;
CREATE SEQUENCE IF NOT EXISTS cnig_accessibilite.cheminement_seq AS bigint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE IF EXISTS cnig_accessibilite.cheminement_seq
    OWNER to usr_admin;
DROP TABLE IF EXISTS cnig_accessibilite.cheminement;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.cheminement (
    --gid bigint DEFAULT nextval('cnig_accessibilite.cheminement_seq'), -- hors standard
    "idCheminement" VARCHAR NOT NULL PRIMARY KEY DEFAULT cnig_accessibilite.create_id('CODESPACE'::VARCHAR(5), 'CHE'::VARCHAR(3), 'CNIG'::VARCHAR || currval('cnig_accessibilite.cheminement_seq')) -- Niveau 1
    , libelle VARCHAR -- Niveau 2
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
);
ALTER TABLE IF EXISTS cnig_accessibilite.cheminement
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.cheminement TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.cheminement TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.cheminement TO usr_read;
COMMENT ON TABLE cnig_accessibilite.cheminement
    IS 'Cheminement d''une personne - Les CHEMINEMENTS (NAVIGATION PATH) décrivent des chemins physiques pour aller d''un point à un autre à pied (ou en fauteuil, etc.). Les constituants de base de CHEMINEMENT sont des TRONÇONS DE CHEMINEMENT. Aux extrémités de ces tronçons, les NOEUDS (PATH LINK END). Les tronçons sont assemblés en SEQUENCES DE TRONÇONS qui elles-mêmes s''assemblent en CHEMINEMENTS (la séparation en deux niveaux d''assemblage permet d''éviter les redéfinitions et de partager des SEQUENCES DE TRONÇONS entre plusieurs CHEMINEMENTS).';
--COMMENT ON COLUMN cnig_accessibilite.cheminement.gid IS 'Identifiant système'; -- hors standard
COMMENT ON COLUMN cnig_accessibilite.cheminement."idCheminement" IS 'identifiant du cheminement';
COMMENT ON COLUMN cnig_accessibilite.cheminement.libelle IS 'libellé (ou nom) du cheminement';
--COMMENT ON COLUMN cnig_accessibilite.cheminement.dat_cre IS 'Date de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.cheminement.dat_mod IS 'Date de modification'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.cheminement.usr_cre IS 'Utilisateur de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.cheminement.usr_mod IS 'Utilisateur de modification'; -- hors standard

--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.cheminement FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.cheminement FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.cheminement FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.cheminement FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard

CREATE INDEX IF NOT EXISTS cheminement_idcheminement_idx
    ON cnig_accessibilite.cheminement
    USING btree("idCheminement");

-------------------------
-- TRONCON_CHEMINEMENT --
-------------------------
DROP SEQUENCE IF EXISTS cnig_accessibilite.troncon_cheminement_seq CASCADE;
CREATE SEQUENCE IF NOT EXISTS cnig_accessibilite.troncon_cheminement_seq AS bigint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE IF EXISTS cnig_accessibilite.troncon_cheminement_seq
    OWNER to usr_admin;
DROP TABLE IF EXISTS cnig_accessibilite.troncon_cheminement CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.troncon_cheminement (
    --gid bigint DEFAULT nextval('cnig_accessibilite.troncon_cheminement_seq'), -- hors standard
    "idTroncon" VARCHAR NOT NULL PRIMARY KEY DEFAULT cnig_accessibilite.create_id('CODESPACE'::VARCHAR(5), 'TRC'::VARCHAR(3), 'CNIG'::VARCHAR || currval('cnig_accessibilite.troncon_cheminement_seq')) -- Niveau 1
    , "from" VARCHAR NOT NULL -- Niveau 1
    , "to" VARCHAR NOT NULL -- Niveau 1
    , longueur INTEGER NOT NULL -- Niveau 1
    , "typeTroncon" VARCHAR NOT NULL -- Niveau 1
    , "statutVoie" VARCHAR -- Niveau 2
    , pente INTEGER NOT NULL -- Niveau 1
    , devers INTEGER NOT NULL -- Niveau 1
    , "urlMedia" VARCHAR -- Niveau 2
    , "idCheminement" VARCHAR -- hors standard
    , the_geom geometry(MultiLinestringZ,2154) NOT NULL
    --, photo TEXT -- hors standard
    --, commentaire TEXT -- hors standard
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
    , CONSTRAINT fk_from FOREIGN KEY ("from") REFERENCES cnig_accessibilite.noeud_cheminement("idNoeud")
    , CONSTRAINT fk_to FOREIGN KEY ("to") REFERENCES cnig_accessibilite.noeud_cheminement("idNoeud")
    , CONSTRAINT fk_typeTroncon FOREIGN KEY ("typeTroncon") REFERENCES cnig_accessibilite.enum_type_troncon(valeur)
    , CONSTRAINT chk_typeTroncon CHECK ("typeTroncon" <> 'NC')
    , CONSTRAINT fk_statutVoie FOREIGN KEY ("statutVoie") REFERENCES cnig_accessibilite.enum_statut_voie(valeur)
);
ALTER TABLE IF EXISTS cnig_accessibilite.troncon_cheminement
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.troncon_cheminement TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.troncon_cheminement TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.troncon_cheminement TO usr_read;
COMMENT ON TABLE cnig_accessibilite.troncon_cheminement
    IS 'Espace ouvert au public dans lequel la personne se déplace. Le tronçon de cheminement réunit des caractéristiques physiques et liées à la circulation PMR - PSH. - PATH LINK : cf. supra, définition du CHEMINEMENT';
--COMMENT ON COLUMN cnig_accessibilite.troncon_cheminement.gid IS 'Identifiant système'; -- hors standard
COMMENT ON COLUMN cnig_accessibilite.troncon_cheminement."idTroncon" IS 'identifiant du tronçon de cheminement ';
COMMENT ON COLUMN cnig_accessibilite.troncon_cheminement."from" IS 'identifiant du nœud de départ du tronçon';
COMMENT ON COLUMN cnig_accessibilite.troncon_cheminement."to" IS 'identifiant du nœud d’arrivée du tronçon';
COMMENT ON COLUMN cnig_accessibilite.troncon_cheminement.longueur IS 'longueur du tronçon de cheminement. Attribut hérité de LINK (cf. NeTEx éléments communs page 18). Il ne s''agit pas de la distance à vol d''oiseau entre les deux nœuds, mais de la distance opérationnelle parcourue sur ce TRONÇON.';
COMMENT ON COLUMN cnig_accessibilite.troncon_cheminement."typeTroncon" IS 'type de tronçon cf. NeTEx / PathLink / AccessFeatureType';
COMMENT ON COLUMN cnig_accessibilite.troncon_cheminement."statutVoie" IS 'type de voie';
COMMENT ON COLUMN cnig_accessibilite.troncon_cheminement.pente IS 'inclinaison du terrain la plus défavorable dans le sens de circulation (nœud de départ vers nœud d’arrivée)';
COMMENT ON COLUMN cnig_accessibilite.troncon_cheminement.devers IS 'inclinaison du terrain la plus défavorable, perpendiculaire au sens de la circulation (nœud de départ vers nœud d’arrivée)';
COMMENT ON COLUMN cnig_accessibilite.troncon_cheminement."urlMedia" IS 'hyperlien vers un ou plusieurs clichés du tronçon';
COMMENT ON COLUMN cnig_accessibilite.troncon_cheminement.the_geom IS 'Géométrie';
--COMMENT ON COLUMN cnig_accessibilite.troncon_cheminement.photo IS 'Photo'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.troncon_cheminement.commentaire IS 'Commentaire'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.troncon_cheminement.dat_cre IS 'Date de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.troncon_cheminement.dat_mod IS 'Date de modification'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.troncon_cheminement.usr_cre IS 'Utilisateur de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.troncon_cheminement.usr_mod IS 'Utilisateur de modification'; -- hors standard

--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.troncon_cheminement FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.troncon_cheminement FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.troncon_cheminement FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.troncon_cheminement FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard

CREATE INDEX IF NOT EXISTS troncon_cheminement_idtroncon_idx
    ON cnig_accessibilite.troncon_cheminement
    USING btree("idTroncon");

CREATE INDEX IF NOT EXISTS troncon_cheminement_idcheminement_idx
    ON cnig_accessibilite.troncon_cheminement
    USING btree("idCheminement");

CREATE INDEX IF NOT EXISTS troncon_cheminement_the_geom_idx
    ON cnig_accessibilite.troncon_cheminement
    USING gist(the_geom);

--------------
-- OBSTACLE --
--------------
DROP SEQUENCE IF EXISTS cnig_accessibilite.obstacle_seq CASCADE;
CREATE SEQUENCE IF NOT EXISTS cnig_accessibilite.obstacle_seq AS bigint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE IF EXISTS cnig_accessibilite.obstacle_seq
    OWNER to usr_admin;
DROP TABLE IF EXISTS cnig_accessibilite.obstacle;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.obstacle (
    --gid bigint DEFAULT nextval('cnig_accessibilite.obstacle_seq'), -- hors standard
    "idObstacle" VARCHAR NOT NULL PRIMARY KEY DEFAULT cnig_accessibilite.create_id('CODESPACE'::varchar(5), 'OBS'::varchar(3), 'CNIG'::varchar || currval('cnig_accessibilite.obstacle_seq')) -- Niveau 1
    , "typeObstacle" VARCHAR NOT NULL -- Niveau 1
    , "largeurUtile" DOUBLE PRECISION NOT NULL -- Niveau 1 (suppression ?)
    , "positionObstacle" VARCHAR NOT NULL -- Niveau 1
    , "longueurObstacle" DOUBLE PRECISION -- Niveau 2
    , "rappelObstacle" VARCHAR NOT NULL DEFAULT 'sans objet' -- Niveau 1
    , "reperabiliteVisuelle" BOOLEAN NOT NULL -- Niveau 1
    , "urlMedia" VARCHAR -- Niveau 2
    , "hauteurSousObs" DOUBLE PRECISION -- Niveau 2
    , "hauteurObsPoseSol" DOUBLE PRECISION -- Niveau 3
    , "idTroncon" VARCHAR NOT NULL
    , the_geom geometry(MultiPointZ,2154) NOT NULL
    --, photo TEXT -- hors standard
    --, commentaire TEXT -- hors standard
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
    , CONSTRAINT fk_typeObstacle FOREIGN KEY ("typeObstacle") REFERENCES cnig_accessibilite.enum_type_obstacle(valeur)
    , CONSTRAINT chk_typeObstacle CHECK ("typeObstacle" <> 'NC')
    , CONSTRAINT fk_positionObstacle FOREIGN KEY ("positionObstacle") REFERENCES cnig_accessibilite.enum_position_obstacle(valeur)
    , CONSTRAINT chk_positionObstacle CHECK ("positionObstacle" <> 'NC')
    , CONSTRAINT fk_rappelObstacle FOREIGN KEY ("rappelObstacle") REFERENCES cnig_accessibilite.enum_rappel_obstacle(valeur)
    , CONSTRAINT chk_rappelObstacle CHECK ("rappelObstacle" <> 'NC')
);
ALTER TABLE IF EXISTS cnig_accessibilite.obstacle
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.obstacle TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.obstacle TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.obstacle TO usr_read;
COMMENT ON TABLE cnig_accessibilite.obstacle
    IS 'Élément situé sur le parcours du cheminement et pouvant l’entraver ou engendrer un problème de sécurité. - Classe d’objet non présente dans le profil accessibilité de NeTEx : l''obstacle y est décrit par un PathLink ou un Equipement spécifique avec les informations correspondantes.';
--COMMENT ON COLUMN cnig_accessibilite.obstacle.gid IS 'Identifiant système'; -- hors standard
COMMENT ON COLUMN cnig_accessibilite.obstacle."idObstacle" IS 'identifiant de l’obstacle';
COMMENT ON COLUMN cnig_accessibilite.obstacle."typeObstacle" IS 'nature de l’élément situé dans le passage';
COMMENT ON COLUMN cnig_accessibilite.obstacle."largeurUtile" IS 'largeur de passage utile à l''endroit de l’obstacle.';
COMMENT ON COLUMN cnig_accessibilite.obstacle."positionObstacle" IS 'position de l’élément situé dans le passage';
COMMENT ON COLUMN cnig_accessibilite.obstacle."longueurObstacle" IS 'longueur de l''obstacle dans le sens du cheminement';
COMMENT ON COLUMN cnig_accessibilite.obstacle."rappelObstacle" IS 'présence d’un élément de rappel de l’obstacle';
COMMENT ON COLUMN cnig_accessibilite.obstacle."reperabiliteVisuelle" IS 'contraste visuel de l’obstacle par rapport à son environnement';
COMMENT ON COLUMN cnig_accessibilite.obstacle."urlMedia" IS 'hyperlien vers un ou plusieurs clichés de l’obstacle';
COMMENT ON COLUMN cnig_accessibilite.obstacle."hauteurSousObs" IS 'hauteur entre le sol et le bas de l’élément en hauteur (cf figure 1 page 24)';
COMMENT ON COLUMN cnig_accessibilite.obstacle."hauteurObsPoseSol" IS 'hauteur entre le sol et le haut de l''obstacle (cf figure 1 page 24)';
COMMENT ON COLUMN cnig_accessibilite.obstacle.the_geom IS 'Géométrie';
--COMMENT ON COLUMN cnig_accessibilite.obstacle.photo IS 'Photo'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.obstacle.commentaire IS 'Commentaire'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.obstacle.dat_cre IS 'Date de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.obstacle.dat_mod IS 'Date de modification'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.obstacle.usr_cre IS 'Utilisateur de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.obstacle.usr_mod IS 'Utilisateur de modification'; -- hors standard

--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.obstacle FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.obstacle FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.obstacle FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.obstacle FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
CREATE TRIGGER update_rappelobstacle BEFORE UPDATE ON cnig_accessibilite.obstacle FOR EACH ROW EXECUTE FUNCTION cnig_accessibilite.update_rappelobstacle();

CREATE INDEX IF NOT EXISTS obstacle_idobstacle_idx
    ON cnig_accessibilite.obstacle
    USING btree("idObstacle");

CREATE INDEX IF NOT EXISTS obstacle_the_geom_idx
    ON cnig_accessibilite.obstacle
    USING gist(the_geom);

-----------------
-- CIRCULATION --
-----------------
DROP SEQUENCE IF EXISTS cnig_accessibilite.circulation_seq CASCADE;
CREATE SEQUENCE IF NOT EXISTS cnig_accessibilite.circulation_seq AS bigint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE IF EXISTS cnig_accessibilite.circulation_seq
    OWNER to usr_admin;
DROP TABLE IF EXISTS cnig_accessibilite.circulation;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.circulation (
    --gid bigint DEFAULT nextval('cnig_accessibilite.circulation_seq'), -- hors standard
    "idCirculation" VARCHAR NOT NULL PRIMARY KEY DEFAULT cnig_accessibilite.create_id('CODESPACE'::VARCHAR(5), 'CIR'::VARCHAR(3), 'CNIG'::VARCHAR || currval('cnig_accessibilite.circulation_seq')) -- Niveau 1
    , "typeSol" VARCHAR -- Niveau 2
    , "largeurUtile" DOUBLE PRECISION NOT NULL -- Niveau 1
    , "etatRevetement" VARCHAR NOT NULL -- Niveau 1
    , eclairage VARCHAR -- Niveau 2
    , transition VARCHAR -- Niveau 2
    , "typePassage" VARCHAR DEFAULT 'en surface' -- Niveau 2
    , "repereLineaire" VARCHAR DEFAULT 'aucun' -- Niveau 2
    , couvert VARCHAR -- Niveau 3
    , "idTroncon" VARCHAR NOT NULL -- hors standard
    --, photo TEXT -- hors standard
    --, commentaire TEXT -- hors standard
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
    , CONSTRAINT fk_typeSol FOREIGN KEY ("typeSol") REFERENCES cnig_accessibilite.enum_type_sol(valeur)
    , CONSTRAINT fk_etatRevetement FOREIGN KEY ("etatRevetement") REFERENCES cnig_accessibilite.enum_etat_revetement(valeur)
    , CONSTRAINT chk_etatRevetement CHECK ("etatRevetement" <> 'NC')
    , CONSTRAINT fk_eclairage FOREIGN KEY (eclairage) REFERENCES cnig_accessibilite.enum_eclairage(valeur)
    , CONSTRAINT fk_transition FOREIGN KEY (transition) REFERENCES cnig_accessibilite.enum_transition(valeur)
    , CONSTRAINT fk_typePassage FOREIGN KEY ("typePassage") REFERENCES cnig_accessibilite.enum_type_passage(valeur)
    , CONSTRAINT fk_repereLineaire FOREIGN KEY ("repereLineaire") REFERENCES cnig_accessibilite.enum_repere_lineaire(valeur)
    , CONSTRAINT chk_repereLineaire CHECK ("repereLineaire" <> 'NC')
    , CONSTRAINT fk_couvert FOREIGN KEY (couvert) REFERENCES cnig_accessibilite.enum_couvert(valeur)
    , CONSTRAINT fk_idparent FOREIGN KEY ("idTroncon") REFERENCES cnig_accessibilite.troncon_cheminement("idTroncon")

);
ALTER TABLE IF EXISTS cnig_accessibilite.circulation
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.circulation TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.circulation TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.circulation TO usr_read;
COMMENT ON TABLE cnig_accessibilite.circulation
    IS 'Cheminement "standard" sur une surface régulière, sans équipement d''accès. Par exemple un cheminement sur un trottoir, une place, une aire piétonne,etc. - Dans NeTEx, CIRCULATION n''existe pas en tant que classe d''objets mais en tant qu''un ensemble d’attributs hérités de la classe SiteElement.';
--COMMENT ON COLUMN cnig_accessibilite.circulation.gid IS 'Identifiant système'; -- hors standard
COMMENT ON COLUMN cnig_accessibilite.circulation."idCirculation" IS 'identifiant de la circulation';
COMMENT ON COLUMN cnig_accessibilite.circulation."typeSol" IS 'revêtement du tronçon';
COMMENT ON COLUMN cnig_accessibilite.circulation."largeurUtile" IS 'largeur libre de tout obstacle sur une hauteur utile de 2.20m. Cette largeur est exprimée avec une précision au cm';
COMMENT ON COLUMN cnig_accessibilite.circulation."etatRevetement" IS 'usure nuisant à la praticabilité du cheminement';
COMMENT ON COLUMN cnig_accessibilite.circulation.eclairage IS 'nature de l’éclairage';
COMMENT ON COLUMN cnig_accessibilite.circulation.transition IS 'type de transition du tronçon';
COMMENT ON COLUMN cnig_accessibilite.circulation."typePassage" IS 'type de passage (en surface, aérien, souterrain)';
COMMENT ON COLUMN cnig_accessibilite.circulation."repereLineaire" IS 'repère linéaire continu au sol';
COMMENT ON COLUMN cnig_accessibilite.circulation.couvert IS 'caractéristique de couverture du cheminement';
COMMENT ON COLUMN cnig_accessibilite.circulation."idTroncon" IS 'identifiant du tronçon emprunté';
--COMMENT ON COLUMN cnig_accessibilite.circulation.photo IS 'Photo'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.circulation.commentaire IS 'Commentaire'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.circulation.dat_cre IS 'Date de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.circulation.dat_mod IS 'Date de modification'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.circulation.usr_cre IS 'Utilisateur de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.circulation.usr_mod IS 'Utilisateur de modification'; -- hors standard

--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.circulation FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.circulation FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.circulation FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.circulation FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard

CREATE INDEX IF NOT EXISTS circulation_idcirculation_idx
    ON cnig_accessibilite.circulation
    USING btree("idCirculation");

CREATE INDEX IF NOT EXISTS circulation_idtroncon_idx
    ON cnig_accessibilite.circulation
    USING btree("idTroncon");

---------------
-- TRAVERSEE --
---------------
DROP SEQUENCE IF EXISTS cnig_accessibilite.traversee_seq CASCADE;
CREATE SEQUENCE IF NOT EXISTS cnig_accessibilite.traversee_seq AS bigint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE IF EXISTS cnig_accessibilite.traversee_seq
    OWNER to usr_admin;

DROP TABLE IF EXISTS cnig_accessibilite.traversee;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.traversee (
    --gid bigint DEFAULT nextval('cnig_accessibilite.traversee_seq'), -- hors standard
    "idTraversee" VARCHAR NOT NULL PRIMARY KEY DEFAULT cnig_accessibilite.create_id('CODESPACE'::VARCHAR(5), 'TRA'::VARCHAR(3), 'CNIG'::VARCHAR || currval('cnig_accessibilite.traversee_seq')) -- Niveau 1
    , "etatRevetement" VARCHAR NOT NULL -- Niveau 1
    , "typeMarquage" VARCHAR NOT NULL -- Niveau 1
    , "etatMarquage" VARCHAR -- Niveau 2
    , eclairage VARCHAR -- Niveau 2
    , "feuPietons" BOOLEAN NOT NULL -- Niveau 1
    , "aideSonore" VARCHAR NOT NULL -- Niveau 1
    , "repereLineaire" VARCHAR NOT NULL -- Niveau 2
    , "chausseeBombee" BOOLEAN NOT NULL DEFAULT FALSE -- Niveau 1
    , "voiesTraversees" VARCHAR(10) DEFAULT 'VV' -- Niveau 2
    , "idTroncon" VARCHAR NOT NULL -- hors standard
    --, photo TEXT -- hors standard
    --, commentaire TEXT -- hors standard
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
    , CONSTRAINT fk_etatRevetement FOREIGN KEY ("etatRevetement") REFERENCES cnig_accessibilite.enum_etat_revetement(valeur)
    , CONSTRAINT chk_etatRevetement  CHECK ("etatRevetement" <> 'NC')
    , CONSTRAINT fk_typeMarquage FOREIGN KEY ("typeMarquage") REFERENCES cnig_accessibilite.enum_marquage(valeur)
    , CONSTRAINT chk_typeMarquage  CHECK ("typeMarquage" <> 'NC')
    , CONSTRAINT fk_etatMarqauge FOREIGN KEY ("etatMarquage") REFERENCES cnig_accessibilite.enum_etat(valeur)
    , CONSTRAINT fk_eclairage FOREIGN KEY (eclairage) REFERENCES cnig_accessibilite.enum_eclairage(valeur)
    , CONSTRAINT fk_aideSonore FOREIGN KEY ("aideSonore") REFERENCES cnig_accessibilite.enum_etat(valeur)
    , CONSTRAINT chk_aideSonore CHECK ("aideSonore" <> 'NC')
    , CONSTRAINT fk_repereLineaire FOREIGN KEY ("repereLineaire") REFERENCES cnig_accessibilite.enum_repere_lineaire(valeur)
    , CONSTRAINT fk_idparent FOREIGN KEY ("idTroncon") REFERENCES cnig_accessibilite.troncon_cheminement("idTroncon")
);
ALTER TABLE IF EXISTS cnig_accessibilite.traversee
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.traversee TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.traversee TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.traversee TO usr_read;
COMMENT ON TABLE cnig_accessibilite.traversee
    IS 'DéToute zone balisée permettant aux piétons de franchir à niveau les voies réservées à la circulation routière, cycliste ou de transports en commun.finition - Profil accessibilité de NeTEx Fr v1.5 - §A.3 table 12 page 53 : CrossingEquipment http://www.normes-donnees-tc.org/wp-content/uploads/2019/12/NF_Profil-NeTEx-pour-laccessibilit%C3%A9F-v1.5.pdf#page=53';
--COMMENT ON COLUMN cnig_accessibilite.traversee.gid IS 'Identifiant système'; -- hors standard
COMMENT ON COLUMN cnig_accessibilite.traversee."idTraversee" IS 'identifiant de la traversée';
COMMENT ON COLUMN cnig_accessibilite.traversee."etatRevetement" IS 'usure nuisant à la praticabilité du cheminement';
COMMENT ON COLUMN cnig_accessibilite.traversee."typeMarquage" IS 'type de marquage au sol de la traversée piétonne';
COMMENT ON COLUMN cnig_accessibilite.traversee."etatMarquage" IS 'état du marquage au sol de la traversée piétonne';
COMMENT ON COLUMN cnig_accessibilite.traversee.eclairage IS 'nature de l’éclairage';
COMMENT ON COLUMN cnig_accessibilite.traversee."feuPietons" IS 'présence d''un feu de signalisation lumineuse de type R12, R12pps, R24, R25';
COMMENT ON COLUMN cnig_accessibilite.traversee."aideSonore" IS 'répétiteurs sonores émettant des signaux codés et parlés';
COMMENT ON COLUMN cnig_accessibilite.traversee."repereLineaire" IS 'repère linéaire continu au sol';
COMMENT ON COLUMN cnig_accessibilite.traversee."chausseeBombee" IS 'la traversée est convexe (ou bombée) elle monte puis descend';
COMMENT ON COLUMN cnig_accessibilite.traversee."voiesTraversees" IS 'Identification des voies rencontrées dans le sens du tronçon portant la traversée : B (Bus), C (piste, bande ou double-sens Cyclable), V (Voie voitures), T (Tramway). Exemples : VV, CBVVC';
COMMENT ON COLUMN cnig_accessibilite.traversee."idTroncon" IS 'identifiant du tronçon emprunté';
--COMMENT ON COLUMN cnig_accessibilite.traversee.photo IS 'Photos'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.traversee.commentaire IS 'Commentaire'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.traversee.dat_cre IS 'Date de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.traversee.dat_mod IS 'Date de modification'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.traversee.usr_cre IS 'Utilisateur de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.traversee.usr_mod IS 'Utilisateur de modification'; -- hors standard

--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.traversee FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.traversee FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.traversee FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.traversee FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
CREATE TRIGGER update_etatmarquage BEFORE UPDATE ON cnig_accessibilite.traversee FOR EACH ROW EXECUTE FUNCTION cnig_accessibilite.update_etatmarquage();

CREATE INDEX IF NOT EXISTS traversee_idtraversee_idx
    ON cnig_accessibilite.traversee
    USING btree("idTraversee");

CREATE INDEX IF NOT EXISTS traversee_idtroncon_idx
    ON cnig_accessibilite.traversee
    USING btree("idTroncon");

-----------
-- RAMPE --
-----------
DROP SEQUENCE IF EXISTS cnig_accessibilite.rampe_seq CASCADE;
CREATE SEQUENCE IF NOT EXISTS cnig_accessibilite.rampe_seq AS bigint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE IF EXISTS cnig_accessibilite.rampe_seq
    OWNER to usr_admin;

DROP TABLE IF EXISTS cnig_accessibilite.rampe;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.rampe (
    --gid bigint DEFAULT nextval('cnig_accessibilite.rampe_seq'), -- hors standard
    "idRampe" VARCHAR NOT NULL PRIMARY KEY DEFAULT cnig_accessibilite.create_id('CODESPACE'::VARCHAR(5), 'RAM'::VARCHAR(3), 'CNIG'::VARCHAR || currval('cnig_accessibilite.rampe_seq')) -- Niveau 1
    , "etatRevetement" VARCHAR NOT NULL -- Niveau 1
    , "largeurUtile" DOUBLE PRECISION NOT NULL -- Niveau 1
    , "mainCourante" VARCHAR NOT NULL -- Niveau 1
    , "distPalierRepos" DOUBLE PRECISION -- Niveau 2
    , "chasseRoue" VARCHAR -- Niveau 2
    , "aireRotation" VARCHAR -- Niveau 2
    , "poidsSupporte" integer -- Niveau 3
    , "idTroncon" VARCHAR NOT NULL -- hors standard
    --, photo TEXT -- hors standard
    --, commentaire TEXT -- hors standard
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
    , CONSTRAINT fk_etatRevetement FOREIGN KEY ("etatRevetement") REFERENCES cnig_accessibilite.enum_etat_revetement(valeur)
    , CONSTRAINT chk_etatRevetement CHECK ("etatRevetement" <> 'NC')
    , CONSTRAINT fk_mainCourante FOREIGN KEY ("mainCourante") REFERENCES cnig_accessibilite.enum_cote(valeur)
    , CONSTRAINT chk_mainCourante CHECK ("mainCourante" <> 'NC')
    , CONSTRAINT fk_chasseRoue FOREIGN KEY ("chasseRoue") REFERENCES cnig_accessibilite.enum_cote(valeur)
    , CONSTRAINT fk_aireRotation FOREIGN KEY ("aireRotation") REFERENCES cnig_accessibilite.enum_position_hauteur(valeur)
    , CONSTRAINT fk_idparent FOREIGN KEY ("idTroncon") REFERENCES cnig_accessibilite.troncon_cheminement("idTroncon")
);
ALTER TABLE IF EXISTS cnig_accessibilite.rampe
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.rampe TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.rampe TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.rampe TO usr_read;
COMMENT ON TABLE cnig_accessibilite.rampe
    IS 'Rampe d''accès. Structure en pente permettant de franchir une dénivellation ou un changement de niveau ou d''étage. - Profil accessibilité de NeTEx Fr v1.5 - §A.3 table 15 page 56 Rampequipment (http://www.normes-donnees-tc.org/wp-content/uploads/2019/12/NF_Profil-NeTEx-pour-laccessibilit%C3%A9F-v1.5.pdf#page=56)';
--COMMENT ON COLUMN cnig_accessibilite.rampe.gid IS 'Identifiant système'; -- hors standard
COMMENT ON COLUMN cnig_accessibilite.rampe."idRampe" IS 'identifiant de la rampe';
COMMENT ON COLUMN cnig_accessibilite.rampe."etatRevetement" IS 'usure nuisant à la praticabilité du cheminement';
COMMENT ON COLUMN cnig_accessibilite.rampe."largeurUtile" IS 'largeur libre de tout obstacle';
COMMENT ON COLUMN cnig_accessibilite.rampe."mainCourante" IS 'élément sur lequel on pose la main pour s''appuyer.';
COMMENT ON COLUMN cnig_accessibilite.rampe."distPalierRepos" IS 'distance maximale entre 2 paliers de repos';
COMMENT ON COLUMN cnig_accessibilite.rampe."chasseRoue" IS 'présence de chasse roue en bordure de la rampe';
COMMENT ON COLUMN cnig_accessibilite.rampe."aireRotation" IS 'présence d''une aire de rotation (ou espace de manœuvre) UFR en bas et/ou en haut de la rampe';
COMMENT ON COLUMN cnig_accessibilite.rampe."poidsSupporte" IS 'charge supportée par la rampe, en kg';
COMMENT ON COLUMN cnig_accessibilite.rampe."idTroncon" IS 'identifiant du tronçon emprunté';
--COMMENT ON COLUMN cnig_accessibilite.rampe.photo IS 'Photo'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.rampe.commentaire IS 'Commentaire'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.rampe.dat_cre IS 'Date de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.rampe.dat_mod IS 'Date de modification'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.rampe.usr_cre IS 'Utilisateur de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.rampe.usr_mod IS 'Utilisateur de modification'; -- hors standard

--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.rampe FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.rampe FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.rampe FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.rampe FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard

CREATE INDEX IF NOT EXISTS rampe_idrampe_idx
    ON cnig_accessibilite.rampe
    USING btree("idRampe");

CREATE INDEX IF NOT EXISTS rampe_idtroncon_idx
    ON cnig_accessibilite.rampe
    USING btree("idTroncon");

--------------
-- ESCALIER --
--------------
DROP SEQUENCE IF EXISTS cnig_accessibilite.escalier_seq CASCADE;
CREATE SEQUENCE IF NOT EXISTS cnig_accessibilite.escalier_seq AS bigint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE IF EXISTS cnig_accessibilite.escalier_seq
    OWNER to usr_admin;

DROP TABLE IF EXISTS cnig_accessibilite.escalier;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.escalier (
    --gid bigint DEFAULT nextval('cnig_accessibilite.escalier_seq'), -- hors standard
    "idEscalier" VARCHAR NOT NULL PRIMARY KEY DEFAULT cnig_accessibilite.create_id('CODESPACE'::VARCHAR(5), 'ESC'::VARCHAR(3), 'CNIG'::VARCHAR || currval('cnig_accessibilite.escalier_seq')) -- Niveau 1
    , "etatRevetement" VARCHAR NOT NULL -- Niveau 1
    , "mainCourante" VARCHAR NOT NULL -- Niveau 1
    , "dispositifVigilance" VARCHAR NOT NULL -- Niveau 1
    , "contrasteVisuel" VARCHAR NOT NULL -- Niveau 1
    , "largeurUtile" DOUBLE PRECISION -- Niveau 2
    , "mainCouranteContinue" VARCHAR -- Niveau 3
    , "prolongMainCourante" VARCHAR -- Niveau 3
    , "nbMarches" INTEGER -- Niveau 3
    , "nbVoleeMarches"INTEGER -- Niveau 3
    , "hauteurMarche" DOUBLE PRECISION -- Niveau 3
    , giron DOUBLE PRECISION -- Niveau 3
    , "idTroncon" VARCHAR NOT NULL -- hors standard
    --, photo TEXT -- hors standard
    --, commentaire TEXT -- hors standard
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
    , CONSTRAINT fk_etatRevetement FOREIGN KEY ("etatRevetement") REFERENCES cnig_accessibilite.enum_etat_revetement(valeur)
    , CONSTRAINT chk_etatRevetement CHECK ("etatRevetement" <> 'NC')
    , CONSTRAINT fk_mainCourante FOREIGN KEY ("mainCourante") REFERENCES cnig_accessibilite.enum_cote(valeur)
    , CONSTRAINT chk_mainCourante CHECK ("mainCourante" <> 'NC')
    , CONSTRAINT fk_dispositifVigilance FOREIGN KEY ("dispositifVigilance") REFERENCES cnig_accessibilite.enum_etat(valeur)
    , CONSTRAINT chk_dispositifVigilance CHECK ("dispositifVigilance" <> 'NC')
    , CONSTRAINT fk_contrasteVisuel FOREIGN KEY ("contrasteVisuel") REFERENCES cnig_accessibilite.enum_etat(valeur)
    , CONSTRAINT chk_contrasteVisuel CHECK ("contrasteVisuel" <> 'NC')
    , CONSTRAINT fk_mainCouranteContinue FOREIGN KEY ("mainCouranteContinue") REFERENCES cnig_accessibilite.enum_cote(valeur)
    , CONSTRAINT fk_prolongMainCourante FOREIGN KEY ("prolongMainCourante") REFERENCES cnig_accessibilite.enum_cote(valeur)
    , CONSTRAINT fk_idparent FOREIGN KEY ("idTroncon") REFERENCES cnig_accessibilite.troncon_cheminement("idTroncon")
);
ALTER TABLE IF EXISTS cnig_accessibilite.escalier
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.escalier TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.escalier TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.escalier TO usr_read;
COMMENT ON TABLE cnig_accessibilite.escalier
    IS 'Ouvrage permettant de monter ou de descendre, constitué d’une succession de marches. - Profil accessibilité de NeTEx Fr v1.5 - §A.3 table 18 et 19 page 57 (http://www.normes-donnees-tc.org/wp-content/uploads/2019/12/NF_Profil-NeTEx-pour-laccessibilit%C3%A9F-v1.5.pdf#page=57): Stair. Stair est décrit dans NeTEx comme deux objets StairEnd et N (plusieurs) StairCaseEquipments';
--COMMENT ON COLUMN cnig_accessibilite.escalier.gid IS 'Identifiant système'; -- hors standard
COMMENT ON COLUMN cnig_accessibilite.escalier."idEscalier" IS 'identifiant de l’escalier';
COMMENT ON COLUMN cnig_accessibilite.escalier."etatRevetement" IS 'usure nuisant à la praticabilité du cheminement';
COMMENT ON COLUMN cnig_accessibilite.escalier."mainCourante" IS 'élément sur lequel on pose la main pour s''appuyer';
COMMENT ON COLUMN cnig_accessibilite.escalier."dispositifVigilance" IS 'dispositif d’éveil de vigilance en haut de l''escalier';
COMMENT ON COLUMN cnig_accessibilite.escalier."contrasteVisuel" IS 'dispositif contrastant sur le nez des première et dernière marches';
COMMENT ON COLUMN cnig_accessibilite.escalier."largeurUtile" IS 'largeur de passage utile entre deux mains courantes ou entre le fût central et la main courante.';
COMMENT ON COLUMN cnig_accessibilite.escalier."mainCouranteContinue" IS 'précise si la main courante est continue ou pas entre plusieurs volées de marches';
COMMENT ON COLUMN cnig_accessibilite.escalier."prolongMainCourante" IS 'prolongement de la main courante au-delà des première et dernière marches';
COMMENT ON COLUMN cnig_accessibilite.escalier."nbMarches" IS 'nombre total de marches';
COMMENT ON COLUMN cnig_accessibilite.escalier."nbVoleeMarches" IS 'nombre de volées de marches';
COMMENT ON COLUMN cnig_accessibilite.escalier."hauteurMarche" IS 'hauteur des marches';
COMMENT ON COLUMN cnig_accessibilite.escalier."giron" IS 'dimension du giron (profondeur de la marche)';
COMMENT ON COLUMN cnig_accessibilite.escalier."idTroncon" IS 'identifiant du tronçon emprunté';
--COMMENT ON COLUMN cnig_accessibilite.escalier.photo IS 'Photo'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.escalier.commentaire IS 'Commentaire'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.escalier.dat_cre IS 'Date de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.escalier.dat_mod IS 'Date de modification'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.escalier.usr_cre IS 'Utilisateur de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.escalier.usr_mod IS 'Utilisateur de modification'; -- hors standard

--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.escalier FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.escalier FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.escalier FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.escalier FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard

CREATE INDEX IF NOT EXISTS escalier_idescalier_idx
    ON cnig_accessibilite.escalier
    USING btree("idEscalier");

CREATE INDEX IF NOT EXISTS escalier_idtroncon_idx
    ON cnig_accessibilite.escalier
    USING btree("idTroncon");

----------------
-- ESCALATOR --
----------------
DROP SEQUENCE IF EXISTS cnig_accessibilite.escalator_seq CASCADE;
CREATE SEQUENCE IF NOT EXISTS cnig_accessibilite.escalator_seq AS bigint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE IF EXISTS cnig_accessibilite.escalator_seq
    OWNER to usr_admin;

DROP TABLE IF EXISTS cnig_accessibilite.escalator;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.escalator (
    --gid bigint DEFAULT nextval('cnig_accessibilite.escalator_seq'), -- hors standard
    "idEscalator" VARCHAR NOT NULL PRIMARY KEY DEFAULT cnig_accessibilite.create_id('CODESPACE'::VARCHAR(5), 'EST'::VARCHAR(3), 'CNIG'::VARCHAR || currval('cnig_accessibilite.escalator_seq')) -- Niveau 1
    , transition VARCHAR NOT NULL -- Niveau 1
    , "dispositifVigilance" VARCHAR NOT NULL -- Niveau 1
    , "largeurUtile" DOUBLE PRECISION NOT NULL -- Niveau 1
    , detecteur BOOLEAN -- Niveau 3
    , supervision BOOLEAN -- Niveau 3
    , "idTroncon" VARCHAR NOT NULL -- hors standard
    --, photo TEXT -- hors standard
    --, commentaire TEXT -- hors standard
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
    , CONSTRAINT fk_transition FOREIGN KEY ("transition") REFERENCES cnig_accessibilite.enum_transition(valeur)
    , CONSTRAINT chk_transition CHECK (transition = 'montée' OR transition = 'descente' OR transition = 'variable')
    , CONSTRAINT fk_dispositifVigilance FOREIGN KEY ("dispositifVigilance") REFERENCES cnig_accessibilite.enum_etat(valeur)
    , CONSTRAINT chk_dispositifVigilance CHECK ("dispositifVigilance" <> 'NC')
    , CONSTRAINT fk_idparent FOREIGN KEY ("idTroncon") REFERENCES cnig_accessibilite.troncon_cheminement("idTroncon")
);
ALTER TABLE IF EXISTS cnig_accessibilite.escalator
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.escalator TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.escalator TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.escalator TO usr_read;
COMMENT ON TABLE cnig_accessibilite.escalator
    IS 'Escalier mécanique - Profil accessibilité de NeTEx Fr v1.5 - §A.3 table 24 page 59 (http://www.normes-donnees-tc.org/wp-content/uploads/2019/12/NF_Profil-NeTEx-pour-laccessibilit%C3%A9F-v1.5.pdf#page=59): EscalatorEquipement';
--COMMENT ON COLUMN cnig_accessibilite.escalator.gid IS 'Identifiant système'; -- hors standard
COMMENT ON COLUMN cnig_accessibilite.escalator."idEscalator" IS 'identifiant de l’escalator';
COMMENT ON COLUMN cnig_accessibilite.escalator."transition" IS 'type d''escalator : montée, descente, variable';
COMMENT ON COLUMN cnig_accessibilite.escalator."dispositifVigilance" IS 'dispositif d’éveil de vigilance';
COMMENT ON COLUMN cnig_accessibilite.escalator."largeurUtile" IS 'largeur libre de tout obstacle';
COMMENT ON COLUMN cnig_accessibilite.escalator."detecteur" IS 'signale une mise en marche par détecteur (ou autre)';
COMMENT ON COLUMN cnig_accessibilite.escalator."supervision" IS 'présence d''un système de contrôle à distance du fonctionnement';
COMMENT ON COLUMN cnig_accessibilite.escalator."idTroncon" IS 'identifiant du tronçon emprunté';
--COMMENT ON COLUMN cnig_accessibilite.escalator.photo IS 'Photo'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.escalator.commentaire IS 'Commentaire'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.escalator.dat_cre IS 'Date de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.escalator.dat_mod IS 'Date de modification'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.escalator.usr_cre IS 'Utilisateur de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.escalator.usr_mod IS 'Utilisateur de modification'; -- hors standard

--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.escalator FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.escalator FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.escalator FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.escalator FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard

CREATE INDEX IF NOT EXISTS escalator_idescalator_idx
    ON cnig_accessibilite.escalator
    USING btree("idEscalator");

CREATE INDEX IF NOT EXISTS escalator_idtroncon_idx
    ON cnig_accessibilite.escalator
    USING btree("idTroncon");

-------------------
-- TAPIS_ROULANT --
-------------------

DROP SEQUENCE IF EXISTS cnig_accessibilite.tapis_roulant_seq CASCADE;
CREATE SEQUENCE IF NOT EXISTS cnig_accessibilite.tapis_roulant_seq AS bigint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE IF EXISTS cnig_accessibilite.tapis_roulant_seq
    OWNER to usr_admin;

DROP TABLE IF EXISTS cnig_accessibilite.tapis_roulant;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.tapis_roulant (
    --gid bigint DEFAULT nextval('cnig_accessibilite.tapis_roulant_seq'), -- hors standard
    "idTapisRoulant" VARCHAR NOT NULL PRIMARY KEY DEFAULT cnig_accessibilite.create_id('CODESPACE'::VARCHAR(5), 'TAP'::VARCHAR(3), 'CNIG'::VARCHAR || currval('cnig_accessibilite.tapis_roulant_seq')) -- Niveau 1
    , sens VARCHAR NOT NULL -- Niveau 1
    , "dispositifVigilance" VARCHAR NOT NULL -- Niveau 1
    , "largeurUtile" DOUBLE PRECISION NOT NULL -- Niveau 1
    , detecteur BOOLEAN -- Niveau 3
    , "idTroncon" VARCHAR NOT NULL -- hors standard
    --, photo TEXT -- hors standard
    --, commentaire TEXT -- hors standard
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
    , CONSTRAINT fk_sens FOREIGN KEY (sens) REFERENCES cnig_accessibilite.enum_sens(valeur)
    , CONSTRAINT chk_sens CHECK (sens <> 'NC')
    , CONSTRAINT fk_dispositifVigilance FOREIGN KEY ("dispositifVigilance") REFERENCES cnig_accessibilite.enum_sens(valeur)
    , CONSTRAINT chk_dispositifVigilance CHECK ("dispositifVigilance" <> 'NC')
    , CONSTRAINT fk_idparent FOREIGN KEY ("idTroncon") REFERENCES cnig_accessibilite.troncon_cheminement("idTroncon")
);
ALTER TABLE IF EXISTS cnig_accessibilite.tapis_roulant
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.tapis_roulant TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.tapis_roulant TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.tapis_roulant TO usr_read;
COMMENT ON TABLE cnig_accessibilite.tapis_roulant
    IS 'Surface plane animée d''un mouvement de translation, servant à transporter des personnes - Profil accessibilité de NeTEx Fr v1.5 - §A.3 table 24 page 59 (http://www.normes-donnees-tc.org/wp-content/uploads/2019/12/NF_Profil-NeTEx-pour-laccessibilit%C3%A9F-v1.5.pdf#page=59): TravelatorEquipment';
--COMMENT ON COLUMN cnig_accessibilite.tapis_roulant.gid IS 'Identifiant système'; -- hors standard
COMMENT ON COLUMN cnig_accessibilite.tapis_roulant."idTapisRoulant" IS 'identifiant du tapis roulant';
COMMENT ON COLUMN cnig_accessibilite.tapis_roulant.sens IS 'sens de la translation du tapis roulant';
COMMENT ON COLUMN cnig_accessibilite.tapis_roulant."dispositifVigilance" IS 'dispositif d’éveil de vigilance';
COMMENT ON COLUMN cnig_accessibilite.tapis_roulant."largeurUtile" IS 'largeur libre de tout obstacle';
COMMENT ON COLUMN cnig_accessibilite.tapis_roulant.detecteur IS 'signale une mise en marche par détecteur (ou autre)';
COMMENT ON COLUMN cnig_accessibilite.tapis_roulant."idTroncon" IS 'identifiant du tronçon emprunté';
--COMMENT ON COLUMN cnig_accessibilite.tapis_roulant.photo IS 'Photo'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.tapis_roulant.commentaire IS 'Commentaire'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.tapis_roulant.dat_cre IS 'Date de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.tapis_roulant.dat_mod IS 'Date de modification'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.tapis_roulant.usr_cre IS 'Utilisateur de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.tapis_roulant.usr_mod IS 'Utilisateur de modification'; -- hors standard

--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.tapis_roulant FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.tapis_roulant FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.tapis_roulant FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.tapis_roulant FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard

CREATE INDEX IF NOT EXISTS tapis_roulant_idtapisroulant_idx
    ON cnig_accessibilite.tapis_roulant
    USING btree("idTapisRoulant");

CREATE INDEX IF NOT EXISTS tapis_roulant_idtroncon_idx
    ON cnig_accessibilite.tapis_roulant
    USING btree("idTroncon");

---------------
-- ASCENSEUR --
---------------
DROP SEQUENCE IF EXISTS cnig_accessibilite.ascenseur_seq CASCADE;
CREATE SEQUENCE IF NOT EXISTS cnig_accessibilite.ascenseur_seq AS bigint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE IF EXISTS cnig_accessibilite.ascenseur_seq
    OWNER to usr_admin;

DROP TABLE IF EXISTS cnig_accessibilite.ascenseur;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.ascenseur (
    --gid bigint DEFAULT nextval('cnig_accessibilite.ascenseur_seq'), -- hors standard
    "idAscenseur" VARCHAR NOT NULL PRIMARY KEY DEFAULT cnig_accessibilite.create_id('CODESPACE'::VARCHAR(5), 'ASC'::VARCHAR(3), 'CNIG'::VARCHAR || currval('cnig_accessibilite.ascenseur_seq')) -- Niveau 1
    , "largeurUtile" DOUBLE PRECISION NOT NULL -- Niveau 1
    , "diamManoeuvreFauteuil" DOUBLE PRECISION -- Niveau 2
    , "largeurCabine" DOUBLE PRECISION NOT NULL -- Niveau 1
    , "longueurCabine" DOUBLE PRECISION NOT NULL -- Niveau 1
    , "boutonsEnRelief" VARCHAR -- Niveau 2
    , "annonceSonore" BOOLEAN NOT NULL -- Niveau 1
    , "signalEtage" VARCHAR NOT NULL -- Niveau 1
    , "boucleInducMagnet" BOOLEAN NOT NULL -- Niveau 1
    , miroir BOOLEAN -- Niveau 2
    , eclairage INTEGER -- Niveau 2
    , "voyantAlerte" VARCHAR NOT NULL -- Niveau 1
    , "typeOuverture" VARCHAR NOT NULL -- Niveau 1
    , "mainCourante" VARCHAR -- Niveau 2
    , "hauteurMainCourante" DOUBLE PRECISION -- Niveau 2
    , "etatRevetement" VARCHAR -- Niveau 3
    , "supervision" BOOLEAN -- Niveau 3
    , "autrePorteSortie" VARCHAR -- Niveau 3
    --, "opaciteParois" BOOLEAN DEFAULT TRUE
    , "idNoeud" VARCHAR NOT NULL -- hors standard
    --, photo TEXT -- hors standard
    --, commentaire TEXT -- hors standard
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
    , CONSTRAINT fk_boutonsEnRelief FOREIGN KEY ("boutonsEnRelief") REFERENCES cnig_accessibilite.enum_relief_boutons(valeur)
    , CONSTRAINT fk_signalEtage FOREIGN KEY ("signalEtage") REFERENCES cnig_accessibilite.enum_dispositif_signalisation(valeur)
    , CONSTRAINT chk_signalEtage CHECK ("signalEtage" <> 'NC')
    , CONSTRAINT fk_voyantAlerte FOREIGN KEY ("voyantAlerte") REFERENCES cnig_accessibilite.enum_voyant_ascenseur(valeur)
    , CONSTRAINT chk_voyantAlerte CHECK ("voyantAlerte" <> 'NC')
    , CONSTRAINT fk_typeOuverture FOREIGN KEY ("typeOuverture") REFERENCES cnig_accessibilite.enum_type_ouverture(valeur)
    , CONSTRAINT chk_typeOuverture CHECK ("typeOuverture" <> 'NC')
    , CONSTRAINT fk_mainCourante FOREIGN KEY ("mainCourante") REFERENCES cnig_accessibilite.enum_cote(valeur)
    , CONSTRAINT fk_etatRevetement FOREIGN KEY ("etatRevetement") REFERENCES cnig_accessibilite.enum_etat_revetement(valeur)
    , CONSTRAINT fk_autrePorteSortie FOREIGN KEY ("autrePorteSortie") REFERENCES cnig_accessibilite.enum_cote(valeur)
    , CONSTRAINT fk_idparent FOREIGN KEY ("idNoeud") REFERENCES cnig_accessibilite.noeud_cheminement("idNoeud")

);
ALTER TABLE IF EXISTS cnig_accessibilite.ascenseur
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.ascenseur TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.ascenseur TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.ascenseur TO usr_read;
COMMENT ON TABLE cnig_accessibilite.ascenseur
    IS 'Ascenseur - Profil accessibilité de NeTEx Fr v1.5 - §A.3 table 25 page 60 (http://www.normes-donnees-tc.org/wp-content/uploads/2019/12/NF_Profil-NeTEx-pour-laccessibilit%C3%A9F-v1.5.pdf#page=60): LiftEquipment';
--COMMENT ON COLUMN cnig_accessibilite.ascenseur.gid IS 'Identifiant système'; -- hors standard
COMMENT ON COLUMN cnig_accessibilite.ascenseur."idAscenseur" IS 'identifiant de l’ascenseur';
COMMENT ON COLUMN cnig_accessibilite.ascenseur."largeurUtile" IS 'largeur utile de la porte de l''ascenseur';
COMMENT ON COLUMN cnig_accessibilite.ascenseur."diamManoeuvreFauteuil" IS 'diamètre de la zone de manœuvre des usagers en fauteuil roulant';
COMMENT ON COLUMN cnig_accessibilite.ascenseur."largeurCabine" IS 'dimension la plus petite de la partie utile de la cabine';
COMMENT ON COLUMN cnig_accessibilite.ascenseur."longueurCabine" IS 'dimension la plus grande de la partie utile de la cabine';
COMMENT ON COLUMN cnig_accessibilite.ascenseur."boutonsEnRelief" IS 'présence de touches en relief et en braille pour désigner les étages';
COMMENT ON COLUMN cnig_accessibilite.ascenseur."annonceSonore" IS 'annonce sonore du numéro d’étage sélectionné ou information sonore de prise en compte de la sélection de l’étage';
COMMENT ON COLUMN cnig_accessibilite.ascenseur."signalEtage" IS 'affichage visuel et/ou annonce sonore de l''étage atteint.';
COMMENT ON COLUMN cnig_accessibilite.ascenseur."boucleInducMagnet" IS 'présence d''un équipement boucle à induction magnétique (BIM) ';
COMMENT ON COLUMN cnig_accessibilite.ascenseur.miroir IS 'présence d''un miroir';
COMMENT ON COLUMN cnig_accessibilite.ascenseur.eclairage IS 'éclairage de la cabine d''ascenseur, en lux';
COMMENT ON COLUMN cnig_accessibilite.ascenseur."voyantAlerte" IS 'existence de voyant permettant de signifier une perturbation dans le fonctionnement.';
COMMENT ON COLUMN cnig_accessibilite.ascenseur."typeOuverture" IS 'type d’ouverture (manuelle / automatique)';
COMMENT ON COLUMN cnig_accessibilite.ascenseur."mainCourante" IS 'existence d''une barre d''aide au maintien.';
COMMENT ON COLUMN cnig_accessibilite.ascenseur."hauteurMainCourante" IS 'hauteur de la barre d''appui. Egale à 0 en l''absence de barre d''appui';
COMMENT ON COLUMN cnig_accessibilite.ascenseur."etatRevetement" IS 'usure nuisant à la praticabilité du cheminement';
COMMENT ON COLUMN cnig_accessibilite.ascenseur.supervision IS 'présence d''un système de contrôle à distance du fonctionnement';
COMMENT ON COLUMN cnig_accessibilite.ascenseur."autrePorteSortie" IS 'indique le côté de la porte aux étages, si différent de celui du rez-de-chaussée';
--COMMENT ON COLUMN cnig_accessibilite.ascenseur."opaciteParois" IS 'toutes les parois de l''ascenseur sont opaques (oui / non)';
COMMENT ON COLUMN cnig_accessibilite.ascenseur."idNoeud" IS 'identifiant du noeud associé';
--COMMENT ON COLUMN cnig_accessibilite.ascenseur.photo IS 'Photo'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.ascenseur.commentaire IS 'Commentaire'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.ascenseur.dat_cre IS 'Date de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.ascenseur.dat_mod IS 'Date de modification'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.ascenseur.usr_cre IS 'Utilisateur de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.ascenseur.usr_mod IS 'Utilisateur de modification'; -- hors standard

--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.ascenseur FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.ascenseur FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.ascenseur FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.ascenseur FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard

CREATE INDEX IF NOT EXISTS ascenseur_idascenseur_idx
    ON cnig_accessibilite.ascenseur
    USING btree("idAscenseur");

CREATE INDEX IF NOT EXISTS ascenseur_idnoeud_idx
    ON cnig_accessibilite.ascenseur
    USING btree("idNoeud");

---------------
-- ELEVATEUR --
---------------
DROP SEQUENCE IF EXISTS cnig_accessibilite.elevateur_seq CASCADE;
CREATE SEQUENCE IF NOT EXISTS cnig_accessibilite.elevateur_seq AS bigint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE IF EXISTS cnig_accessibilite.elevateur_seq
    OWNER to usr_admin;

DROP TABLE IF EXISTS cnig_accessibilite.elevateur;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.elevateur (
    --gid bigint DEFAULT nextval('cnig_accessibilite.elevateur_seq'), -- hors standard
    "idElevateur" VARCHAR NOT NULL PRIMARY KEY DEFAULT cnig_accessibilite.create_id('CODESPACE'::VARCHAR(5), 'ELE'::VARCHAR(3), 'CNIG'::VARCHAR || currval('cnig_accessibilite.elevateur_seq')) -- Niveau 1
    , "largeurUtile" DOUBLE PRECISION NOT NULL -- Niveau 1
    , "boutonsEnRelief" VARCHAR -- Niveau 2
    , "typeOuverture" VARCHAR -- Niveau 2
    , "largeurPlateforme" DOUBLE PRECISION NOT NULL -- Niveau 1
    , "longueurPlateforme" DOUBLE PRECISION NOT NULL -- Niveau 1
    , "utilisableAutonomie" BOOLEAN -- Niveau 3
    , "etatRevetement" VARCHAR -- Niveau 3
    , supervision BOOLEAN -- Niveau 3
    , "autrePorteSortie" VARCHAR -- Niveau 3
    , "chargeMaximum" INTEGER -- Niveau 3
    , accompagnateur VARCHAR -- Niveau 3
    , "idNoeud" VARCHAR NOT NULL -- hors standard
    --, photo TEXT -- hors standard
    --, commentaire TEXT -- hors standard
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
    , CONSTRAINT fk_boutonsEnRelief FOREIGN KEY ("boutonsEnRelief") REFERENCES cnig_accessibilite.enum_relief_boutons(valeur)
    , CONSTRAINT fk_typeOuverture FOREIGN KEY ("typeOuverture") REFERENCES cnig_accessibilite.enum_dispositif_signalisation(valeur)
    , CONSTRAINT chk_typeOuverture CHECK ("typeOuverture" <> 'NC')
    , CONSTRAINT fk_etatRevetement FOREIGN KEY ("etatRevetement") REFERENCES cnig_accessibilite.enum_etat_revetement(valeur)
    , CONSTRAINT fk_autrePorteSortie FOREIGN KEY ("autrePorteSortie") REFERENCES cnig_accessibilite.enum_cote(valeur)
    , CONSTRAINT fk_accompagnateur FOREIGN KEY (accompagnateur) REFERENCES cnig_accessibilite.enum_temporalite(valeur)
    , CONSTRAINT fk_idparent FOREIGN KEY ("idNoeud") REFERENCES cnig_accessibilite.noeud_cheminement("idNoeud")
);
ALTER TABLE IF EXISTS cnig_accessibilite.elevateur
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.elevateur TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.elevateur TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.elevateur TO usr_read;

COMMENT ON TABLE cnig_accessibilite.elevateur
    IS 'Système de franchissement d''une dénivellation muni d''une plate-forme ou d''une nacelle. - Profil accessibilité de NeTEx Fr v1.5 - §A.3 table 23 page 59 (http://www.normes-donnees-tc.org/wp-content/uploads/2019/12/NF_Profil-NeTEx-pour-laccessibilit%C3%A9F-v1.5.pdf#page=59): ELEVATOR est un cas spécifique des 
LiftEquipment';
--COMMENT ON COLUMN cnig_accessibilite.elevateur.gid IS 'Identifiant système'; -- hors standard
COMMENT ON COLUMN cnig_accessibilite.elevateur."idElevateur" IS 'identifiant de l’élévateur';
COMMENT ON COLUMN cnig_accessibilite.elevateur."largeurUtile" IS 'largeur utile de la porte ou du portillon';
COMMENT ON COLUMN cnig_accessibilite.elevateur."boutonsEnRelief" IS 'présence de touches en relief et en braille pour désigner les étages';
COMMENT ON COLUMN cnig_accessibilite.elevateur."typeOuverture" IS 'type d’ouverture (manuelle / automatique)';
COMMENT ON COLUMN cnig_accessibilite.elevateur."largeurPlateforme" IS 'dimension la plus petite de la partie utile de la plate-forme';
COMMENT ON COLUMN cnig_accessibilite.elevateur."longueurPlateforme" IS 'dimension la plus grande de la partie utile de la plate-forme';
COMMENT ON COLUMN cnig_accessibilite.elevateur."utilisableAutonomie" IS 'possibilité d''utiliser l''élévateur sans autorisation ou intervention d''un opérateur';
COMMENT ON COLUMN cnig_accessibilite.elevateur."etatRevetement" IS 'usure nuisant à la praticabilité du cheminement';
COMMENT ON COLUMN cnig_accessibilite.elevateur.supervision IS 'présence d''un système de contrôle à distance du fonctionnement';
COMMENT ON COLUMN cnig_accessibilite.elevateur."autrePorteSortie" IS 'indique le côté de la porte aux étages, si différent de celui du rez-de-chausée';
COMMENT ON COLUMN cnig_accessibilite.elevateur."chargeMaximum" IS 'charge maximale admissible';
COMMENT ON COLUMN cnig_accessibilite.elevateur.accompagnateur IS 'existence d''un agent préposé à l''utilisation de l''élévateur';
COMMENT ON COLUMN cnig_accessibilite.elevateur."idNoeud" IS 'identifiant du noeud associé';
--COMMENT ON COLUMN cnig_accessibilite.elevateur.photo IS 'Photo'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.elevateur.commentaire IS 'Commentaire'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.elevateur.dat_cre IS 'Date de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.elevateur.dat_mod IS 'Date de modification'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.elevateur.usr_cre IS 'Utilisateur de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.elevateur.usr_mod IS 'Utilisateur de modification'; -- hors standard

--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.elevateur FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.elevateur FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.elevateur FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.elevateur FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard

CREATE INDEX IF NOT EXISTS elevateur_idelevateur_idx
    ON cnig_accessibilite.elevateur
    USING btree("idElevateur");

CREATE INDEX IF NOT EXISTS elevateur_idnoeud_idx
    ON cnig_accessibilite.elevateur
    USING btree("idNoeud");

------------
-- ENTREE --
------------
DROP SEQUENCE IF EXISTS cnig_accessibilite.entree_seq CASCADE;
CREATE SEQUENCE IF NOT EXISTS cnig_accessibilite.entree_seq AS bigint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE IF EXISTS cnig_accessibilite.entree_seq
    OWNER to usr_admin;

DROP TABLE IF EXISTS cnig_accessibilite.entree CASCADE;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.entree (
    --gid bigint DEFAULT nextval('cnig_accessibilite.entree_seq'), -- hors standard
    "idEntree" VARCHAR NOT NULL PRIMARY KEY DEFAULT cnig_accessibilite.create_id('CODESPACE'::VARCHAR(5), 'ENT'::VARCHAR(3), 'CNIG'::VARCHAR || currval('cnig_accessibilite.entree_seq')) -- Niveau 1
    , adresse VARCHAR -- Niveau 2
    , "typeEntree" VARCHAR -- Niveau 2
    , rampe VARCHAR NOT NULL -- Niveau 1
    , "rampeSonnette" BOOLEAN -- Niveau 2
    , ascenseur BOOLEAN NOT NULL DEFAULT FALSE -- Niveau 1
    , "escalierNbMarche" INTEGER NOT NULL -- Niveau 1
    , "escalierMainCourante" VARCHAR -- Niveau 2
    , reperabilite BOOLEAN -- Niveau 2
    , "reperageEltsVitres" BOOLEAN NOT NULL -- Niveau 1
    , signaletique BOOLEAN -- Niveau 2
    , "largeurPassage" DOUBLE PRECISION NOT NULL -- Niveau 1
    , "controleAcces" VARCHAR -- Niveau 2
    , "entreeAccueilVisible" BOOLEAN -- Niveau 2
    , eclairage INTEGER -- Niveau 2
    , "typePorte" VARCHAR -- Niveau 2
    , "typeOuverture" VARCHAR NOT NULL -- Niveau 1
    , "espaceManoeuvre" VARCHAR NOT NULL -- Niveau 1
    , "largManoeuvreExt" DOUBLE PRECISION -- Niveau 2
    , "longManoeuvreExt" DOUBLE PRECISION -- Niveau 2
    , "largManoeuvreInt" DOUBLE PRECISION -- Niveau 2
    , "longManoeuvreInt" DOUBLE PRECISION -- Niveau 2
    , "typePoignée" VARCHAR -- Niveau 3
    , "effortOuverture" INTEGER -- Niveau 3
    , "idNoeud" VARCHAR NOT NULL -- hors standard
    , "idERP" VARCHAR NOT NULL -- hors standard
    --, photo TEXT -- hors standard
    --, commentaire TEXT -- hors standard
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
    , CONSTRAINT fk_typeEntree FOREIGN KEY ("typeEntree") REFERENCES cnig_accessibilite.enum_type_entree(valeur)
    , CONSTRAINT fk_rampe FOREIGN KEY (rampe) REFERENCES cnig_accessibilite.enum_rampe_erp(valeur)
    , CONSTRAINT chk_rampe CHECK (rampe <> 'NC')
    , CONSTRAINT fk_escalierMainCourante FOREIGN KEY ("escalierMainCourante") REFERENCES cnig_accessibilite.enum_cote(valeur)
    , CONSTRAINT fk_controleAcces FOREIGN KEY ("controleAcces") REFERENCES cnig_accessibilite.enum_controle_acces(valeur)
    , CONSTRAINT fk_typePorte FOREIGN KEY ("typePorte") REFERENCES cnig_accessibilite.enum_type_porte(valeur)
    , CONSTRAINT fk_typeOuverture FOREIGN KEY ("typeOuverture") REFERENCES cnig_accessibilite.enum_type_ouverture(valeur)
    , CONSTRAINT fk_espaceManoeuvre FOREIGN KEY ("espaceManoeuvre") REFERENCES cnig_accessibilite.enum_position_espace(valeur)
    , CONSTRAINT fk_typePoignée FOREIGN KEY ("typePoignée") REFERENCES cnig_accessibilite.enum_type_poignee(valeur)
    , CONSTRAINT fk_idparent FOREIGN KEY ("idNoeud") REFERENCES cnig_accessibilite.noeud_cheminement("idNoeud")
);
ALTER TABLE IF EXISTS cnig_accessibilite.entree
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.entree TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.entree TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.entree TO usr_read;
COMMENT ON TABLE cnig_accessibilite.entree
    IS 'Ouverture permettant le passage - Profil accessibilité de NeTEx Fr v1.5 - §A.3 table 13 page 54 (http://www.normes-donnees-tc.org/wp-content/uploads/2019/12/NF_Profil-NeTEx-pour-laccessibilit%C3%A9F-v1.5.pdf#page=56): Entrance (avec des sous-types parmi ParkingPassengerEntrance, StopPlaceEntrance, PointOfInterestEntrance, etc.)';
--COMMENT ON COLUMN cnig_accessibilite.entree.gid IS 'identifiant de l’entrée'; -- hors standard
COMMENT ON COLUMN cnig_accessibilite.entree."idEntree" IS 'identifiant du entree';
COMMENT ON COLUMN cnig_accessibilite.entree.adresse IS 'adresse de l''entrée';
COMMENT ON COLUMN cnig_accessibilite.entree."typeEntree" IS 'type d''entrée';
COMMENT ON COLUMN cnig_accessibilite.entree.rampe IS 'présence d’une rampe d''accès à l''entrée ';
COMMENT ON COLUMN cnig_accessibilite.entree."rampeSonnette" IS 'présence d’une sonnette au droit de la rampe à l’entrée';
COMMENT ON COLUMN cnig_accessibilite.entree.ascenseur IS 'présence d’un ascenseur ou élévateur donnant accès à l’entrée';
COMMENT ON COLUMN cnig_accessibilite.entree."escalierNbMarche" IS 'nombre de marches de l’escalier à l’entrée';
COMMENT ON COLUMN cnig_accessibilite.entree."escalierMainCourante" IS 'présence d’une main courante sur l’escalier à l’entrée';
COMMENT ON COLUMN cnig_accessibilite.entree."reperabilite" IS 'repérabilité de l’entrée dans son environnement en tenant compte de l''architecture, de la signalisation et du contraste visuel. ';
COMMENT ON COLUMN cnig_accessibilite.entree."reperageEltsVitres" IS 'présence de repérage des éléments vitrés (ex : vitrophanie)';
COMMENT ON COLUMN cnig_accessibilite.entree.signaletique IS 'présence d’une signalétique spécifique à l’entrée';
COMMENT ON COLUMN cnig_accessibilite.entree."largeurPassage" IS 'largeur de passage utile de l’entrée';
COMMENT ON COLUMN cnig_accessibilite.entree."controleAcces" IS 'équipement de contrôle d’accès à l’entrée';
COMMENT ON COLUMN cnig_accessibilite.entree."entreeAccueilVisible" IS 'visibilité de l’accueil de l’ERP depuis l’entrée';
COMMENT ON COLUMN cnig_accessibilite.entree.eclairage IS 'éclairage de l''entrée en lux';
COMMENT ON COLUMN cnig_accessibilite.entree."typePorte" IS 'type de porte à l’entrée (si plusieurs portes prendre en compte la plus accessible)';
COMMENT ON COLUMN cnig_accessibilite.entree."typeOuverture" IS 'type d’ouverture (manuelle / automatique)';
COMMENT ON COLUMN cnig_accessibilite.entree."espaceManoeuvre" IS 'indique la présence ou pas, à proximité immédiate de la porte, d''un espace pour la manœuvrer correctement. Un espace de manœuvre se matérialise par un rectangle situé à la base de la porte.';
COMMENT ON COLUMN cnig_accessibilite.entree."largManoeuvreExt" IS 'plus petite dimension de l''espace de manœuvre extérieur';
COMMENT ON COLUMN cnig_accessibilite.entree."longManoeuvreExt" IS 'plus grande dimension de l''espace de manœuvre extérieur';
COMMENT ON COLUMN cnig_accessibilite.entree."largManoeuvreInt" IS 'plus petite dimension de l''espace de manœuvre intérieur';
COMMENT ON COLUMN cnig_accessibilite.entree."longManoeuvreInt" IS 'plus grande dimension de l''espace de manœuvre intérieur';
COMMENT ON COLUMN cnig_accessibilite.entree."typePoignée" IS 'type de poignée';
COMMENT ON COLUMN cnig_accessibilite.entree."effortOuverture" IS 'effort à porter pour actionner la poignée.';
COMMENT ON COLUMN cnig_accessibilite.entree."idNoeud" IS 'identifiant du noeud associé';
--COMMENT ON COLUMN cnig_accessibilite.entree.photo IS 'Photo'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.entree.commentaire IS 'Commentaire'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.entree.dat_cre IS 'Date de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.entree.dat_mod IS 'Date de modification'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.entree.usr_cre IS 'Utilisateur de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.entree.usr_mod IS 'Utilisateur de modification'; -- hors standard

--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.entree FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.entree FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.entree FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.entree FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
CREATE TRIGGER update_rampeSonnette BEFORE UPDATE ON cnig_accessibilite.entree FOR EACH ROW EXECUTE FUNCTION cnig_accessibilite.update_rampeSonnette();
CREATE TRIGGER update_escalierMainCourante BEFORE UPDATE ON cnig_accessibilite.entree FOR EACH ROW EXECUTE FUNCTION cnig_accessibilite.update_escalierMainCourante();
CREATE TRIGGER update_largManoeuvreExt BEFORE UPDATE ON cnig_accessibilite.entree FOR EACH ROW EXECUTE FUNCTION cnig_accessibilite.update_largManoeuvreExt();
CREATE TRIGGER update_longManoeuvreExt BEFORE UPDATE ON cnig_accessibilite.entree FOR EACH ROW EXECUTE FUNCTION cnig_accessibilite.update_longManoeuvreExt();
CREATE TRIGGER update_largManoeuvreInt BEFORE UPDATE ON cnig_accessibilite.entree FOR EACH ROW EXECUTE FUNCTION cnig_accessibilite.update_largManoeuvreInt();
CREATE TRIGGER update_longManoeuvreInt BEFORE UPDATE ON cnig_accessibilite.entree FOR EACH ROW EXECUTE FUNCTION cnig_accessibilite.update_longManoeuvreInt();

CREATE INDEX IF NOT EXISTS entree_identree_idx
    ON cnig_accessibilite.entree
    USING btree("idEntree");

CREATE INDEX IF NOT EXISTS entree_idnoeud_idx
    ON cnig_accessibilite.entree
    USING btree("idNoeud");

----------------------
-- PASSAGE_SELECTIF --
----------------------
DROP SEQUENCE IF EXISTS cnig_accessibilite.passage_selectif_seq CASCADE;
CREATE SEQUENCE IF NOT EXISTS cnig_accessibilite.passage_selectif_seq AS bigint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE IF EXISTS cnig_accessibilite.passage_selectif_seq
    OWNER to usr_admin;

DROP TABLE IF EXISTS cnig_accessibilite.passage_selectif;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.passage_selectif (
    --gid bigint DEFAULT nextval('cnig_accessibilite.passage_selectif_seq'), -- hors standard
    "idPassageSelectif" VARCHAR NOT NULL PRIMARY KEY DEFAULT cnig_accessibilite.create_id('CODESPACE'::VARCHAR(5), 'PSE'::VARCHAR(3), 'CNIG'::VARCHAR || currval('cnig_accessibilite.passage_selectif_seq')) -- Niveau 1
    , "passageMecanique" BOOLEAN -- Niveau 2
    , "largeurUtile" DOUBLE PRECISION NOT NULL -- Niveau 1
    , profondeur DOUBLE PRECISION NOT NULL -- Niveau 1
    , "contrasteVisuel" BOOLEAN NOT NULL -- Niveau 1
    , "idNoeud" VARCHAR NOT NULL -- hors standard
    --, photo TEXT -- hors standard
    --, commentaire TEXT -- hors standard
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
    , CONSTRAINT fk_idparent FOREIGN KEY ("idNoeud") REFERENCES cnig_accessibilite.noeud_cheminement("idNoeud")
);
ALTER TABLE IF EXISTS cnig_accessibilite.passage_selectif
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.passage_selectif TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.passage_selectif TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.passage_selectif TO usr_read;
COMMENT ON TABLE cnig_accessibilite.passage_selectif
    IS 'Dispositif permettant le passage des piétons, mais dissuadant celui des cycles et des engins motorisés - Absent du Profil accessibilité de NeTEx Fr v1.5 (http://www.normes-donnees-tc.org/wp-content/uploads/2019/12/NF_Profil-NeTEx-pour-laccessibilit%C3%A9F-v1.5.pdf): le passage sélectif est traité en attributs du PathLink';
--COMMENT ON COLUMN cnig_accessibilite.passage_selectif.gid IS 'Identifiant système'; -- hors standard
COMMENT ON COLUMN cnig_accessibilite.passage_selectif."idPassageSelectif" IS 'identifiant du passage sélectif';
COMMENT ON COLUMN cnig_accessibilite.passage_selectif."passageMecanique" IS 'précise s''il s''agit d''un passage mécanique';
COMMENT ON COLUMN cnig_accessibilite.passage_selectif."largeurUtile" IS 'largeur libre de tout obstacle';
COMMENT ON COLUMN cnig_accessibilite.passage_selectif.profondeur IS 'profondeur du passage sélectif';
COMMENT ON COLUMN cnig_accessibilite.passage_selectif."contrasteVisuel" IS 'repérage visuel du dispositif';
COMMENT ON COLUMN cnig_accessibilite.passage_selectif."idNoeud" IS 'identifiant du noeud associé';
--COMMENT ON COLUMN cnig_accessibilite.passage_selectif.photo IS 'Photo'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.passage_selectif.commentaire IS 'Commentaire'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.passage_selectif.dat_cre IS 'Date de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.passage_selectif.dat_mod IS 'Date de modification'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.passage_selectif.usr_cre IS 'Utilisateur de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.passage_selectif.usr_mod IS 'Utilisateur de modification'; -- hors standard

--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.passage_selectif FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.passage_selectif FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.passage_selectif FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.passage_selectif FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard

CREATE INDEX IF NOT EXISTS passage_selectif_idpassageselectif_idx
    ON cnig_accessibilite.passage_selectif
    USING btree("idPassageSelectif");

CREATE INDEX IF NOT EXISTS passage_selectif_idnoeud_idx
    ON cnig_accessibilite.passage_selectif
    USING btree("idNoeud");

----------
-- QUAI --
----------
DROP SEQUENCE IF EXISTS cnig_accessibilite.quai_seq CASCADE;
CREATE SEQUENCE IF NOT EXISTS cnig_accessibilite.quai_seq AS bigint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE IF EXISTS cnig_accessibilite.quai_seq
    OWNER to usr_admin;

DROP TABLE IF EXISTS cnig_accessibilite.quai;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.quai (
    --gid bigint DEFAULT nextval('cnig_accessibilite.quai_seq'), -- hors standard
    "idQuai" VARCHAR NOT NULL PRIMARY KEY DEFAULT cnig_accessibilite.create_id('CODESPACE'::VARCHAR(5), 'CHE'::VARCHAR(3), 'CNIG'::VARCHAR || currval('cnig_accessibilite.quai_seq')) -- Niveau 1
    , "etatRevetement" VARCHAR NOT NULL -- Niveau 1
    , hauteur DOUBLE PRECISION NOT NULL -- Niveau 1
    , "largeurPassage" DOUBLE PRECISION NOT NULL -- Niveau 1
    , "signalisationPorte" VARCHAR -- Niveau 2
    , "dispositifVigilance" VARCHAR NOT NULL -- Niveau 1
    , "diamZoneManoeuvre" DOUBLE PRECISION NOT NULL -- Niveau 1
    , "idTroncon" VARCHAR NOT NULL -- hors standard
    --, photo TEXT -- hors standard
    --, commentaire TEXT -- hors standard
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
    , CONSTRAINT fk_etatRevetement FOREIGN KEY ("etatRevetement") REFERENCES cnig_accessibilite.enum_etat_revetement(valeur)
    , CONSTRAINT chk_etatRevetement CHECK ("etatRevetement" <> 'NC')
    , CONSTRAINT fk_signalisationPorte FOREIGN KEY ("signalisationPorte") REFERENCES cnig_accessibilite.enum_dispositif_signalisation(valeur)
    , CONSTRAINT fk_dispositifVigilance FOREIGN KEY ("dispositifVigilance") REFERENCES cnig_accessibilite.enum_etat(valeur)
    , CONSTRAINT fk_idparent FOREIGN KEY ("idTroncon") REFERENCES cnig_accessibilite.troncon_cheminement("idTroncon")
);
ALTER TABLE IF EXISTS cnig_accessibilite.quai
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.quai TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.quai TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.quai TO usr_read;
COMMENT ON TABLE cnig_accessibilite.quai
    IS 'Équipement d''un mode de transport permettant un accès au véhicule - Profil NeTEx pour les arrêts – v2.2(fr) §7.4 Zone d''embarquement - Table 12 page 23 (http://www.normes-donnees-tc.org/wp-content/uploads/2021/01/Profil-NeTEx-pour-les-arretsF-v2.2.pdf)';
--COMMENT ON COLUMN cnig_accessibilite.quai.gid IS 'Identifiant système'; -- hors standard
COMMENT ON COLUMN cnig_accessibilite.quai."idQuai" IS 'identifiant du quai';
COMMENT ON COLUMN cnig_accessibilite.quai."etatRevetement" IS 'usure nuisant à la praticabilité du cheminement';
COMMENT ON COLUMN cnig_accessibilite.quai.hauteur IS 'différence de niveau entre la chaussée et le quai, ou bien entre la plateforme de tram ou train et le quai';
COMMENT ON COLUMN cnig_accessibilite.quai."largeurPassage" IS 'largeur minimale de passage sur le quai, notamment entre le bord du quai et l’abri voyageur.';
COMMENT ON COLUMN cnig_accessibilite.quai."signalisationPorte" IS 'dispositif de signalisation de la porte accessible, comprenant la dalle contrastée et le dispositif de bande d’interception.';
COMMENT ON COLUMN cnig_accessibilite.quai."dispositifVigilance" IS 'dispositif d’éveil à la vigilance sur le bord de quai';
COMMENT ON COLUMN cnig_accessibilite.quai."diamZoneManoeuvre" IS ' diamètre de la zone de manœuvre des usagers en fauteuil roulant, une fois la palette ou la plate-forme élévatrice déployée';
COMMENT ON COLUMN cnig_accessibilite.quai."idTroncon" IS 'identifiant du tronçon emprunté';
--COMMENT ON COLUMN cnig_accessibilite.quai.photo IS 'Photo'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.quai.commentaire IS 'Commentaire'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.quai.dat_cre IS 'Date de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.quai.dat_mod IS 'Date de modification'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.quai.usr_cre IS 'Utilisateur de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.quai.usr_mod IS 'Utilisateur de modification'; -- hors standard

--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.quai FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.quai FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.quai FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.quai FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard

CREATE INDEX IF NOT EXISTS quai_idpassageselectif_idx
    ON cnig_accessibilite.quai
    USING btree("idQuai");

CREATE INDEX IF NOT EXISTS quai_idtroncon_idx
    ON cnig_accessibilite.quai
    USING btree("idTroncon");

-----------------------
-- STATIONNEMENT_PMR --
-----------------------
DROP SEQUENCE IF EXISTS cnig_accessibilite.stationnement_pmr_seq CASCADE;
CREATE SEQUENCE IF NOT EXISTS cnig_accessibilite.stationnement_pmr_seq AS bigint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE IF EXISTS cnig_accessibilite.stationnement_pmr_seq
    OWNER to usr_admin;

DROP TABLE IF EXISTS cnig_accessibilite.stationnement_pmr;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.stationnement_pmr (
    --gid bigint DEFAULT nextval('cnig_accessibilite.stationnement_pmr_seq'), -- hors standard
    "idStationnement" VARCHAR NOT NULL PRIMARY KEY DEFAULT cnig_accessibilite.create_id('CODESPACE'::VARCHAR(5), 'STA'::VARCHAR(3), 'CNIG'::VARCHAR || currval('cnig_accessibilite.stationnement_pmr_seq')) -- Niveau 1
    , "typeStationnement" VARCHAR -- Niveau 2
    , "etatRevetement" VARCHAR NOT NULL -- Niveau 1
    , "largeurStat" DOUBLE PRECISION NOT NULL -- Niveau 1
    , "longueurStat" DOUBLE PRECISION NOT NULL -- Niveau 1
    , "bandLatSecurite" BOOLEAN -- Niveau 2
    , "surLongueur" DOUBLE PRECISION NOT NULL -- Niveau 1
    , "signalPMR" BOOLEAN NOT NULL -- Niveau 1
    , "marquageSol" BOOLEAN NOT NULL -- Niveau 1
    , pente INTEGER NOT NULL -- Niveau 1
    , devers INTEGER NOT NULL -- Niveau 1
    , "typeSol" VARCHAR -- Niveau 3
    , "idNoeud" VARCHAR NOT NULL
    , the_geom geometry(MultiPoint,2154) NOT NULL
    --, photo TEXT -- hors standard
    --, commentaire TEXT -- hors standard
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
    , CONSTRAINT fk_typeStationnement FOREIGN KEY ("typeStationnement") REFERENCES cnig_accessibilite.enum_type_stationnement(valeur)
    , CONSTRAINT fk_etatRevetement FOREIGN KEY ("etatRevetement") REFERENCES cnig_accessibilite.enum_etat_revetement(valeur)
    , CONSTRAINT chk_etatRevetement CHECK ("etatRevetement" <> 'NC')
    , CONSTRAINT fk_typeSol FOREIGN KEY ("typeSol") REFERENCES cnig_accessibilite.enum_type_sol(valeur)
);
ALTER TABLE IF EXISTS cnig_accessibilite.stationnement_pmr
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.stationnement_pmr TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.stationnement_pmr TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.stationnement_pmr TO usr_read;
COMMENT ON TABLE cnig_accessibilite.stationnement_pmr
    IS 'Place de stationnement de véhicule sur voirie, réservée aux personnes à mobilité réduite';
--COMMENT ON COLUMN cnig_accessibilite.stationnement_pmr.gid IS 'Identifiant système'; -- hors standard
COMMENT ON COLUMN cnig_accessibilite.stationnement_pmr."idStationnement" IS 'identifiant du stationnement PMR';
COMMENT ON COLUMN cnig_accessibilite.stationnement_pmr."typeStationnement" IS 'type de stationnement (longitudinal, épi, bataille)';
COMMENT ON COLUMN cnig_accessibilite.stationnement_pmr."etatRevetement" IS 'usure nuisant à la praticabilité du cheminement';
COMMENT ON COLUMN cnig_accessibilite.stationnement_pmr."largeurStat" IS 'largeur du stationnement';
COMMENT ON COLUMN cnig_accessibilite.stationnement_pmr."longueurStat" IS 'longueur du stationnement';
COMMENT ON COLUMN cnig_accessibilite.stationnement_pmr."bandLatSecurite" IS 'présence d''une bande latérale sécurisée : espace permettant au conducteur utilisateur de fauteuil roulant ou d’un déambulateur de rejoindre le cheminement piéton sans devoir circuler sur la chaussée';
COMMENT ON COLUMN cnig_accessibilite.stationnement_pmr."surLongueur" IS 'dimension de la sur-longueur sur la voie de circulation';
COMMENT ON COLUMN cnig_accessibilite.stationnement_pmr."signalPMR" IS 'présence de signalisation indiquant la spécificité du stationnement';
COMMENT ON COLUMN cnig_accessibilite.stationnement_pmr."marquageSol" IS 'présence du marquage au sol : pictogramme et contour de la place';
COMMENT ON COLUMN cnig_accessibilite.stationnement_pmr.pente IS 'inclinaison du terrain dans le sens longitudinal du stationnement';
COMMENT ON COLUMN cnig_accessibilite.stationnement_pmr.devers IS 'inclinaison du terrain dans le sens latéral du stationnement';
COMMENT ON COLUMN cnig_accessibilite.stationnement_pmr."typeSol" IS 'matériau de revêtement du stationnement';
--COMMENT ON COLUMN cnig_accessibilite.stationnement_pmr.photo IS 'Photo'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.stationnement_pmr.commentaire IS 'Commentaire'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.stationnement_pmr.dat_cre IS 'Date de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.stationnement_pmr.dat_mod IS 'Date de modification'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.stationnement_pmr.usr_cre IS 'Utilisateur de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.stationnement_pmr.usr_mod IS 'Utilisateur de modification'; -- hors standard

--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.stationnement_pmr FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.stationnement_pmr FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.stationnement_pmr FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.stationnement_pmr FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard

CREATE INDEX IF NOT EXISTS stationnement_pmr_idstationnement_idx
    ON cnig_accessibilite.stationnement_pmr
    USING btree("idStationnement");

CREATE INDEX IF NOT EXISTS stationnement_pmr_the_geom_idx
    ON cnig_accessibilite.stationnement_pmr
    USING gist(the_geom);

---------
-- ERP --
---------
DROP SEQUENCE IF EXISTS cnig_accessibilite.erp_seq CASCADE;
CREATE SEQUENCE IF NOT EXISTS cnig_accessibilite.erp_seq AS bigint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE IF EXISTS cnig_accessibilite.erp_seq
    OWNER to usr_admin;

DROP TABLE IF EXISTS cnig_accessibilite.erp;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.erp (
    --gid bigint DEFAULT nextval('cnig_accessibilite.erp_seq'), -- hors standard
    "idERP" VARCHAR NOT NULL PRIMARY KEY DEFAULT cnig_accessibilite.create_id('CODESPACE'::VARCHAR(5), 'ERP'::VARCHAR(3), 'CNIG'::VARCHAR || currval('cnig_accessibilite.erp_seq')) -- Niveau 1
    , nom VARCHAR -- Niveau 1
    , adresse VARCHAR -- Niveau 1
    , "codePostal" VARCHAR (5) NOT NULL -- Niveau 1
    , "erpCategorie" VARCHAR NOT NULL -- Niveau 1
    , "erpType" VARCHAR NOT NULL -- Niveau 1
    , "dateMiseAJour" DATE -- Niveau 2
    , "sourceMiseAJour" VARCHAR -- Niveau 2
    , "stationnementERP" BOOLEAN NOT NULL -- Niveau 1
    , "stationnementPMR" INTEGER NOT NULL -- Niveau 1
    , "accueilPersonnel" VARCHAR -- Niveau 2
    , "accueilBIM" BOOLEAN NOT NULL -- Niveau 1
    , "accueilBIMPortative" BOOLEAN NOT NULL -- Niveau 1
    , "accueilLSF" BOOLEAN NOT NULL -- Niveau 1
    , "accueilST" BOOLEAN NOT NULL -- Niveau 1
    , "accueilAideAudition" BOOLEAN NOT NULL -- Niveau 1
    , "accueilPrestations" VARCHAR -- Niveau 2
    , "sanitairesERP" BOOLEAN NOT NULL -- Niveau 1
    , "sanitairesAdaptes" INTEGER NOT NULL -- Niveau 1
    , telephone VARCHAR NOT NULL -- Niveau 1
    , "siteWeb" VARCHAR -- Niveau 2
    , siret VARCHAR(14) NOT NULL -- Niveau 1
    , latitude DOUBLE PRECISION NOT NULL -- Niveau 1
    , longitude DOUBLE PRECISION NOT NULL -- Niveau 1
    , "erpActivite" VARCHAR -- Niveau 3
    , the_geom geometry(MultiPolygon, 2154)
    --, photo TEXT -- hors standard
    --, commentaire TEXT -- hors standard
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
    , CONSTRAINT fk_erpCategorie FOREIGN KEY ("erpCategorie") REFERENCES cnig_accessibilite.enum_categorie_erp(valeur)
    , CONSTRAINT chk_erpCategorie CHECK ("erpCategorie" <> 'NC')
    , CONSTRAINT fk_erpType FOREIGN KEY ("erpType") REFERENCES cnig_accessibilite.enum_type_erp(valeur)
    , CONSTRAINT chk_erpType CHECK ("erpType" <> 'NC')
    , CONSTRAINT fk_accueilPersonnel FOREIGN KEY ("accueilPersonnel") REFERENCES cnig_accessibilite.enum_personnel_erp(valeur)
);
ALTER TABLE IF EXISTS cnig_accessibilite.erp
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.erp TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.erp TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.erp TO usr_read;
COMMENT ON TABLE cnig_accessibilite.erp
    IS 'Établissement recevant du public ou installation ouverte au public (IOP) - L''ERP est décrit dans le Profil NeTEx Réseau comme un Point of interest (POI)';
--COMMENT ON COLUMN cnig_accessibilite.erp.gid IS 'Identifiant système'; -- hors standard
COMMENT ON COLUMN cnig_accessibilite.erp."idERP" IS 'identifiant de l''ERP';
COMMENT ON COLUMN cnig_accessibilite.erp.nom IS 'nom de l''ERP';
COMMENT ON COLUMN cnig_accessibilite.erp.adresse IS 'adresse postale principale de l''ERP';
COMMENT ON COLUMN cnig_accessibilite.erp."codePostal" IS 'code postal de l''adresse de l’ERP';
COMMENT ON COLUMN cnig_accessibilite.erp."erpCategorie" IS 'les catégories sont déterminées en fonction de la capacité d''accueil du bâtiment, y compris les salariés (sauf pour la 5e catégorie).';
COMMENT ON COLUMN cnig_accessibilite.erp."erpType" IS 'les ERP sont classés suivant cette nomenclature (https://www.service-public.fr/professionnels-entreprises/vosdroits/F32351) en fonction de leur activité ou la nature de leur exploitation.';
COMMENT ON COLUMN cnig_accessibilite.erp."dateMiseAJour" IS 'date de la dernière mise à jour des données de l''ERP';
COMMENT ON COLUMN cnig_accessibilite.erp."sourceMiseAJour" IS 'organisme qui a opéré la mise à jour des données de l''ERP';
COMMENT ON COLUMN cnig_accessibilite.erp."stationnementERP" IS 'présence de stationnement ouvert au public au sein de l''ERP';
COMMENT ON COLUMN cnig_accessibilite.erp."stationnementPMR" IS 'nombre de stationnements ouverts au public et réservé aux PMR au sein de l''ERP';
COMMENT ON COLUMN cnig_accessibilite.erp."accueilPersonnel" IS 'présence de personnel d’accueil';
COMMENT ON COLUMN cnig_accessibilite.erp."accueilBIM" IS 'présence d’une BIM – boucle à induction magnétique';
COMMENT ON COLUMN cnig_accessibilite.erp."accueilBIMPortative" IS 'présence d’une BIM portative – boucle à induction magnétique';
COMMENT ON COLUMN cnig_accessibilite.erp."accueilLSF" IS 'présence d’un dispositif de communication en LSF';
COMMENT ON COLUMN cnig_accessibilite.erp."accueilST" IS 'présence d’un dispositif de communication par sous-titrage';
COMMENT ON COLUMN cnig_accessibilite.erp."accueilAideAudition" IS 'présence d’une autre aide à l’audition ou la communication';
COMMENT ON COLUMN cnig_accessibilite.erp."accueilPrestations" IS 'prestation délivrée par l''ERP';
COMMENT ON COLUMN cnig_accessibilite.erp."sanitairesERP" IS 'présence de sanitaires ouverts au public au sein de l''ERP';
COMMENT ON COLUMN cnig_accessibilite.erp."sanitairesAdaptes" IS 'nombre de sanitaires adaptés et ouverts au public au sein de l''ERP';
COMMENT ON COLUMN cnig_accessibilite.erp.telephone IS 'numéro de téléphone de l''ERP';
COMMENT ON COLUMN cnig_accessibilite.erp."siteWeb" IS 'site internet de l''ERP';
COMMENT ON COLUMN cnig_accessibilite.erp.siret IS 'code SIRET de l''ERP';
COMMENT ON COLUMN cnig_accessibilite.erp.latitude IS 'latitude de l''entrée principale de l''ERP exprimées dans le système global WGS84';
COMMENT ON COLUMN cnig_accessibilite.erp.longitude IS 'longitude de l''entrée principale de l''ERP exprimées dans le système global WGS84';
COMMENT ON COLUMN cnig_accessibilite.erp."erpActivite" IS 'activité de l’ERP (pour communication au public)';
--COMMENT ON COLUMN cnig_accessibilite.erp.photo IS 'Photo'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.erp.commentaire IS 'Commentaire'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.erp.dat_cre IS 'Date de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.erp.dat_mod IS 'Date de modification'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.erp.usr_cre IS 'Utilisateur de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.erp.usr_mod IS 'Utilisateur de modification'; -- hors standard

--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.erp FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.erp FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.erp FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.erp FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
CREATE TRIGGER update_stationnementPMR BEFORE UPDATE ON cnig_accessibilite.erp FOR EACH ROW EXECUTE FUNCTION cnig_accessibilite.update_stationnementPMR();
CREATE TRIGGER update_sanitairesAdaptes BEFORE UPDATE ON cnig_accessibilite.erp FOR EACH ROW EXECUTE FUNCTION cnig_accessibilite.update_sanitairesAdaptes();

CREATE INDEX IF NOT EXISTS erp_iderp_idx
    ON cnig_accessibilite.erp
    USING btree("idERP");

CREATE INDEX IF NOT EXISTS erp_the_geom_idx
    ON cnig_accessibilite.erp
    USING gist(the_geom);

--------------------------------
-- CHEMINEMENT_ERP --
--------------------------------
DROP SEQUENCE IF EXISTS cnig_accessibilite.cheminement_erp_seq CASCADE;
CREATE SEQUENCE IF NOT EXISTS cnig_accessibilite.cheminement_erp_seq AS bigint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE IF EXISTS cnig_accessibilite.cheminement_erp_seq
    OWNER to usr_admin;

DROP TABLE IF EXISTS cnig_accessibilite.cheminement_erp;
CREATE TABLE IF NOT EXISTS cnig_accessibilite.cheminement_erp (
    --gid bigint DEFAULT nextval('cnig_accessibilite.cheminement_erp_seq'), -- hors standard
    "idCheminementERP" VARCHAR NOT NULL PRIMARY KEY DEFAULT cnig_accessibilite.create_id('CODESPACE'::VARCHAR(5), 'CIE'::VARCHAR(3), 'CNIG'::VARCHAR || currval('cnig_accessibilite.cheminement_erp_seq')) -- Niveau 1
    , "departChemStat" BOOLEAN NOT NULL -- Niveau 1
    , "arriveeChemAcc" BOOLEAN NOT NULL -- Niveau 1
    , "idEntreeDep" VARCHAR NOT NULL -- Niveau 1
    , "idEntreeArr" VARCHAR NOT NULL -- Niveau 1
    , "typeSol" VARCHAR -- Niveau 2
    , "largeurUtile" DOUBLE PRECISION NOT NULL -- Niveau 1
    , "hautRessaut" DOUBLE PRECISION NOT NULL -- Niveau 1
    , rampe VARCHAR -- Niveau 2
    , "rampeSonnette" BOOLEAN -- Niveau 2
    , ascenseur BOOLEAN NOT NULL -- Niveau 1
    , "escalierNbMarche" INTEGER NOT NULL -- Niveau 1
    , "escalierMainCourante" BOOLEAN NOT NULL -- Niveau 1
    , "escalierDescendant" INTEGER NOT NULL -- Niveau 1
    , "penteCourte" INTEGER NOT NULL -- Niveau 1
    , "penteMoyenne" INTEGER NOT NULL -- Niveau 1
    , "penteLongue" INTEGER NOT NULL -- Niveau 1
    , devers INTEGER NOT NULL -- Niveau 1
    , "reperageEltsVitres" BOOLEAN NOT NULL -- Niveau 1
    , "sysGuidVisuel" BOOLEAN NOT NULL -- Niveau 1
    , "sysGuidTactile" BOOLEAN NOT NULL -- Niveau 1
    , "sysGuidSonore" BOOLEAN NOT NULL -- Niveau 1
    , exterieur BOOLEAN -- Niveau 3
    , "idERP" VARCHAR NOT NULL -- hors standard
    --, photo TEXT -- hors standard
    --, commentaire TEXT -- hors standard
    --, usr_cre VARCHAR -- hors standard
    --, usr_mod VARCHAR -- hors standard
    --, dat_cre TIMESTAMP WITHOUT TIME ZONE -- hors standard
    --, dat_mod TIMESTAMP WITHOUT TIME ZONE -- hors standard
    , CONSTRAINT fk_idEntreeDep FOREIGN KEY ("idEntreeDep") REFERENCES cnig_accessibilite.entree("idEntree")
    , CONSTRAINT fk_idEntreeArr FOREIGN KEY ("idEntreeArr") REFERENCES cnig_accessibilite.entree("idEntree")
    , CONSTRAINT fk_typeSol FOREIGN KEY ("typeSol") REFERENCES cnig_accessibilite.enum_type_sol(valeur)
    , CONSTRAINT fk_rampe FOREIGN KEY (rampe) REFERENCES cnig_accessibilite.enum_rampe_erp(valeur)
);
ALTER TABLE IF EXISTS cnig_accessibilite.cheminement_erp
    OWNER to usr_admin;
GRANT ALL ON TABLE cnig_accessibilite.cheminement_erp TO usr_admin WITH GRANT OPTION;
GRANT INSERT, DELETE, SELECT, UPDATE ON TABLE cnig_accessibilite.cheminement_erp TO usr_edit;
GRANT SELECT ON TABLE cnig_accessibilite.cheminement_erp TO usr_read;
COMMENT ON TABLE cnig_accessibilite.cheminement_erp
    IS 'Cheminement piéton à l’intérieur du site d''un ERP, dont le point de départ est une entrée ou une place de stationnement PMR, et le point d''arrivée est une entrée ou l''accueil de l''ERP.  Il s''agit de cheminements décrits uniquement par des attributs, c''est à dire sans description géométrique des tronçons de cheminement car le présent standard "s''arrête" à l''entrée des ERP sans décrire géométriquement les cheminements intérieurs au cadre bâti. Des ERP de grande emprise qui disposent de voirie intérieure pourront cependant supporter une description du cheminement identique à celle adoptée dans le domaine voirie / espace public. - Il s''agit pour NeTEx d''un cheminement normal car NeTEx supporte les cheminements intérieurs au cadre bâti.';
--COMMENT ON COLUMN cnig_accessibilite.cheminement_erp.gid IS 'Identifiant système'; -- hors standard
COMMENT ON COLUMN cnig_accessibilite.cheminement_erp."idCheminementERP" IS 'identifiant du cheminement ERP';
COMMENT ON COLUMN cnig_accessibilite.cheminement_erp."departChemStat" IS 'le départ du cheminement est une place de stationnement PMR';
COMMENT ON COLUMN cnig_accessibilite.cheminement_erp."arriveeChemAcc" IS 'l’arrivée du cheminement est l’accueil';
COMMENT ON COLUMN cnig_accessibilite.cheminement_erp."idEntreeDep" IS 'identifiant de l''entrée point de départ du cheminement';
COMMENT ON COLUMN cnig_accessibilite.cheminement_erp."idEntreeArr" IS 'identifiant de l''entrée point d’arrivée du cheminement';
COMMENT ON COLUMN cnig_accessibilite.cheminement_erp."typeSol" IS 'type de revêtement de sol majoritaire du cheminement';
COMMENT ON COLUMN cnig_accessibilite.cheminement_erp."largeurUtile" IS 'largeur minimale sur l''ensemble du cheminement';
COMMENT ON COLUMN cnig_accessibilite.cheminement_erp."hautRessaut" IS 'hauteur de ressaut sur le cheminement. Il s''agit de la valeur maximale en cas de plusieurs ressauts, 0 en l''absence de ressaut.';
COMMENT ON COLUMN cnig_accessibilite.cheminement_erp.rampe IS 'présence d’une rampe sur le cheminement ';
COMMENT ON COLUMN cnig_accessibilite.cheminement_erp."rampeSonnette" IS 'présence d’une sonnette au droit de la rampe sur le cheminement';
COMMENT ON COLUMN cnig_accessibilite.cheminement_erp.ascenseur IS 'présence d’un ascenseur sur le cheminement';
COMMENT ON COLUMN cnig_accessibilite.cheminement_erp."escalierNbMarche" IS 'nombre de marches d''escalier sur le cheminement';
COMMENT ON COLUMN cnig_accessibilite.cheminement_erp."escalierMainCourante" IS 'présence d’une main courante sur l’escalier sur le cheminement';
COMMENT ON COLUMN cnig_accessibilite.cheminement_erp."escalierDescendant" IS 'nombre de volées d''escalier descendantes sur le cheminement';
COMMENT ON COLUMN cnig_accessibilite.cheminement_erp."penteCourte" IS 'pourcentage le plus défavorable d’une pente de longueur inférieure à 50cm de longueur sur le cheminement.';
COMMENT ON COLUMN cnig_accessibilite.cheminement_erp."penteMoyenne" IS 'pourcentage le plus défavorable d’une pente de longueur comprise entre 50cm et 2m sur le cheminement.';
COMMENT ON COLUMN cnig_accessibilite.cheminement_erp."penteLongue" IS 'pourcentage le plus défavorable d’une pente de longueur supérieure à 2m sur le cheminement.';
COMMENT ON COLUMN cnig_accessibilite.cheminement_erp.devers IS 'dévers le plus défavorable sur le cheminement. Inclinaison du terrain, perpendiculaire au sens de la circulation';
COMMENT ON COLUMN cnig_accessibilite.cheminement_erp."reperageEltsVitres" IS 'présence de repérage des éléments vitrés sur le cheminement  (ex : vitrophanie)';
COMMENT ON COLUMN cnig_accessibilite.cheminement_erp."sysGuidVisuel" IS 'présence d’un système de guidage visuel sur le cheminement (signalétique, contraste visuel des cheminements...)';
COMMENT ON COLUMN cnig_accessibilite.cheminement_erp."sysGuidTactile" IS 'présence d’un système de guidage tactile sur le cheminement (bande de guidage, guidage naturel…)';
COMMENT ON COLUMN cnig_accessibilite.cheminement_erp."sysGuidSonore" IS 'présence d’un système de guidage sonore sur le cheminement (balise numérique,..)';
COMMENT ON COLUMN cnig_accessibilite.cheminement_erp.exterieur IS 'cheminement en extérieur';
COMMENT ON COLUMN cnig_accessibilite.cheminement_erp."idERP" IS 'identifiant de l''ERP associé';
--COMMENT ON COLUMN cnig_accessibilite.cheminement_erp.photo IS 'Photo'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.cheminement_erp.commentaire IS 'Commentaire'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.cheminement_erp.dat_cre IS 'Date de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.cheminement_erp.dat_mod IS 'Date de modification'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.cheminement_erp.usr_cre IS 'Utilisateur de création'; -- hors standard
--COMMENT ON COLUMN cnig_accessibilite.cheminement_erp.usr_mod IS 'Utilisateur de modification'; -- hors standard

--CREATE TRIGGER update_usr_cre BEFORE INSERT ON cnig_accessibilite.cheminement_erp FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_cre(); -- hors standard
--CREATE TRIGGER update_dat_cre BEFORE INSERT ON cnig_accessibilite.cheminement_erp FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_cre(); -- hors standard
--CREATE TRIGGER update_usr_mod BEFORE UPDATE ON cnig_accessibilite.cheminement_erp FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_usr_mod(); -- hors standard
--CREATE TRIGGER update_dat_mod BEFORE UPDATE ON cnig_accessibilite.cheminement_erp FOR EACH ROW EXECUTE PROCEDURE cnig_accessibilite.update_dat_mod(); -- hors standard
CREATE TRIGGER update_idEntreeDep BEFORE UPDATE ON cnig_accessibilite.cheminement_erp FOR EACH ROW EXECUTE FUNCTION cnig_accessibilite.update_idEntreeDep();
CREATE TRIGGER update_idEntreeArr BEFORE UPDATE ON cnig_accessibilite.cheminement_erp FOR EACH ROW EXECUTE FUNCTION cnig_accessibilite.update_idEntreeArr();
CREATE TRIGGER update_rampeSonnette BEFORE UPDATE ON cnig_accessibilite.cheminement_erp FOR EACH ROW EXECUTE FUNCTION cnig_accessibilite.update_rampeSonnette();
CREATE TRIGGER update_ascenseur BEFORE UPDATE ON cnig_accessibilite.cheminement_erp FOR EACH ROW EXECUTE FUNCTION cnig_accessibilite.update_ascenseur();
CREATE TRIGGER update_escalierNbMarche BEFORE UPDATE ON cnig_accessibilite.cheminement_erp FOR EACH ROW EXECUTE FUNCTION cnig_accessibilite.update_escalierNbMarche();
CREATE TRIGGER update_escalierMainCourante BEFORE UPDATE ON cnig_accessibilite.cheminement_erp FOR EACH ROW EXECUTE FUNCTION cnig_accessibilite.update_escalierMainCourante();

CREATE INDEX IF NOT EXISTS cheminement_erp_idcheminementerp_idx
    ON cnig_accessibilite.cheminement_erp
    USING btree("idCheminementERP");

CREATE INDEX IF NOT EXISTS cheminement_erp_iderp_idx
    ON cnig_accessibilite.cheminement_erp
    USING btree("idERP");
