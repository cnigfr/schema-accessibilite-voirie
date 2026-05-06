"""CNIG Accessibility standard v2021-10 rev.2025-03 value lists.

All lists accept 'NC' (unknown / not filled in) and 'sans objet',
"""

# Extra values
NC = "NC"
SANS_OBJET = "sans objet"
EXTRAS = (NC, SANS_OBJET)

# Enumerated types
CATEGORIE_ERP = (
    "catégorie 1", "catégorie 2", "catégorie 3", "catégorie 4", "catégorie 5",
) + EXTRAS

CONTROLE_ACCES = (
    "absence", "bouton d'appel", "interphone", "visiophone",
    "boucle à induction magnétique",
) + EXTRAS

CONTROLE_BEV = (
    "normale",
    # across cases
    "implantée en travers",
    "implantée en travers|largeur insuffisante",
    "implantée en travers|largeur insuffisante|non contrastée",
    "implantée en travers|largeur insuffisante|profondeur insuffisante",
    "implantée en travers|largeur insuffisante|non contrastée|profondeur insuffisante",
    "implantée en travers|largeur trop importante",
    "implantée en travers|largeur trop importante|non contrastée",
    "implantée en travers|largeur trop importante|profondeur insuffisante",
    "implantée en travers|largeur trop importante|non contrastée|profondeur insuffisante",
    # curved cases
    "implantée en courbe",
    "implantée en courbe|largeur insuffisante",
    "implantée en courbe|largeur insuffisante|non contrastée",
    "implantée en courbe|largeur insuffisante|profondeur insuffisante",
    "implantée en courbe|largeur insuffisante|non contrastée|profondeur insuffisante",
    "implantée en courbe|largeur trop importante",
    "implantée en courbe|largeur trop importante|non contrastée",
    "implantée en courbe|largeur trop importante|profondeur insuffisante",
    "implantée en courbe|largeur trop importante|non contrastée|profondeur insuffisante",
    # width cases
    "largeur insuffisante",
    "largeur insuffisante|non contrastée",
    "largeur insuffisante|profondeur insuffisante",
    "largeur insuffisante|non contrastée|profondeur insuffisante",
    "largeur trop importante",
    "largeur trop importante|non contrastée",
    "largeur trop importante|profondeur insuffisante",
    "largeur trop importante|non contrastée|profondeur insuffisante",
    # contrast cases
    "non contrastée",
    "non contrastée|profondeur insuffisante",
    #  depth
    "profondeur insuffisante",
) + EXTRAS

COTE = (
    "aucun", "à droite", "à gauche", "des deux côtés", "en face", "au milieu",
) + EXTRAS

COUVERT = (
    "intérieur", "extérieur couvert", "extérieur non couvert",
) + EXTRAS

DISPOSITIF_SIGNALISATION = (
    "aucun", "visuel", "tactile", "sonore",
    "visuel et tactile", "visuel et sonore", "tactile et sonore",
    "visuel et tactile et sonore",
) + EXTRAS

ECLAIRAGE = (
    "bon éclairage", "éclairage insuffisant", "absence d'éclairage",
) + EXTRAS

ETAT = (
    "absence", "bon état", "dégradation sans gravité",
    "dégradation entraînant une difficulté d'usage ou d'inconfort",
    "dégradation entraînant un problème de sécurité immédiat",
) + EXTRAS

ETAT_REVETEMENT = (
    "roulant", "dégradation sans gravité",
    "dégradation entraînant un problème de sécurité immédiat",
    "meuble", "secouant", "glissant",
) + EXTRAS

MARQUAGE = (
    "aucun", "bandes blanches", "marques d'animation",
    "clous métalliques", "revêtement différencié", "autre",
) + EXTRAS

MASQUE_COVISIBILITE = (
    "aucun", "stationnement voiture", "végétation", "bâti", "mobilier urbain", "autre",
) + EXTRAS

PERSONNEL_ERP = (
    "absence de personnel",
    "personnel formé à l'accueil des publics spécifiques",
    "personnel non-formé à l'accueil des publics spécifiques",
) + EXTRAS

POSITION_ESPACE = (
    "absence", "extérieur", "intérieur", "intérieur et extérieur",
) + EXTRAS

POSITION_HAUTEUR = (
    "absence", "en bas", "en haut", "en haut et en bas",
) + EXTRAS

POSITION_OBSTACLE = (
    "obstacle en surface", "obstacle posé au sol", "obstacle en saillie",
) + EXTRAS

RAPPEL_OBSTACLE = (
    "absence de rappel au sol", "surépaisseur", "élément bas",
) + EXTRAS

RAMPE_ERP = (
    "fixe", "amovible", "absence",
) + EXTRAS

RELIEF_BOUTONS = (
    "aucune touche différenciée",
    "touche 0 différenciée par relief supérieur",
    "touche 0 de relief supérieur et autres touches en braille",
) + EXTRAS

REPERE_LINEAIRE = (
    "aucun", "façade ou mur", "bordure ou muret",
    "revêtement différencié", "bande de guidage", "autre",
) + EXTRAS

SENS = (
    "direct", "indirect", "variable",
) + EXTRAS

STATUT_VOIE = (
    "voie classique", "zone 30", "zone de rencontre",
    "rue piétonne - aire piétonne - sente piétonne",
    "voie verte",
    "autre type de voie inscrit au schéma directeur de la voirie",
) + EXTRAS

TEMPORALITE = (
    "permanent", "temporaire", "jamais",
) + EXTRAS

TRANSITION = (
    "montée", "descente", "pas de changement de niveau", "variable",
) + EXTRAS

TYPE_ENTREE = (
    "entrée principale de bâtiment", "entrée secondaire de bâtiment", "entrée de site",
) + EXTRAS

TYPE_ERP = (
    "J", "L", "M", "N", "O", "P", "R", "S", "T", "U",
    "V", "W", "X", "Y", "GA", "OA", "PA", "PS", "REF", "SG",
) + EXTRAS

TYPE_OBSTACLE = (
    "ressaut", "pente ponctuelle forte", "mobilier urbain", "surface irrégulière",
    "poteau non électrifié", "grille", "potelet", "végétation",
    "dévers ponctuel fort", "débord de façade, mur, paroi", "avaloir",
    "boîte aux lettres", "traversée de piste cyclable", "poteau électrifié", "autre",
) + EXTRAS

TYPE_OUVERTURE = (
    "manuelle", "automatique", "ouverture manuelle assistée mécaniquement",
) + EXTRAS

TYPE_PASSAGE = (
    "en surface", "couloir", "aérien", "passage souterrain", "tunnel",
) + EXTRAS

TYPE_POIGNEE = (
    "béquille", "bouton", "poignée palière", "poignée de tirage",
    "levier de fenêtre", "bâton maréchal",
) + EXTRAS

TYPE_PORTE = (
    "porte normale", "porte coulissante", "tourniquet", "portillon",
    "portail", "porte tambour", "porte battante",
) + EXTRAS

TYPE_SOL = (
    "tapis", "béton", "asphalte, enrobé", "liège", "caillebotis en fibre de verre",
    "carreaux de céramique émaillés", "matière plastique", "carrelage", "caoutchouc",
    "plaques métaliques", "vynil", "bois", "pierre, pavé", "gazon", "terre",
    "graviers", "matériau inégal par nature", "sable stabilisé", "autre"
) + EXTRAS

TYPE_STATIONNEMENT = (
    "longitudinal", "épi", "bataille",
) + EXTRAS

TYPE_TRONCON = (
    "ascenseur", "tapis roulant", "rampe", "escalier", "série d'escaliers",
    "traversée piétonne", "îlot de traversée piétonne",
    "présence de barrière(s)", "passage étroit", "hall",
    "couloir intérieur", "espace confiné", "gestion de queue",
    "espace ouvert", "rue", "trottoir", "chemin piéton", "passage",
    "navette", "quai", "escalator", "monte-charge / monte personne",
) + EXTRAS

VOYANT_ASCENSEUR = (
    "aucun", "voyant demande secours enregistrée",
    "voyant demande secours en transmission", "les deux",
) + EXTRAS

# Index by constraint name
ENUM_CONSTRAINTS: dict[str, tuple[str, ...]] = {
    "categorie_erp":            CATEGORIE_ERP,
    "controle_acces":           CONTROLE_ACCES,
    "controle_bev":             CONTROLE_BEV,
    "cote":                     COTE,
    "couvert":                  COUVERT,
    "dispositif_signalisation": DISPOSITIF_SIGNALISATION,
    "eclairage":                ECLAIRAGE,
    "etat":                     ETAT,
    "etat_revetement":          ETAT_REVETEMENT,
    "marquage":                 MARQUAGE,
    "masque_covisibilite":      MASQUE_COVISIBILITE,
    "personnel_erp":            PERSONNEL_ERP,
    "position_espace":          POSITION_ESPACE,
    "position_hauteur":         POSITION_HAUTEUR,
    "position_obstacle":        POSITION_OBSTACLE,
    "rappel_obstacle":          RAPPEL_OBSTACLE,
    "rampe_erp":                RAMPE_ERP,
    "relief_boutons":           RELIEF_BOUTONS,
    "repere_lineaire":          REPERE_LINEAIRE,
    "sens":                     SENS,
    "statut_voie":              STATUT_VOIE,
    "temporalite":              TEMPORALITE,
    "transition":               TRANSITION,
    "type_entree":              TYPE_ENTREE,
    "type_erp":                 TYPE_ERP,
    "type_obstacle":            TYPE_OBSTACLE,
    "type_ouverture":           TYPE_OUVERTURE,
    "type_passage":             TYPE_PASSAGE,
    "type_poignee":             TYPE_POIGNEE,
    "type_porte":               TYPE_PORTE,
    "type_sol":                 TYPE_SOL,
    "type_stationnement":       TYPE_STATIONNEMENT,
    "type_troncon":             TYPE_TRONCON,
    "voyant_ascenseur":         VOYANT_ASCENSEUR,
}

# COLUMN_SPECS: (table, column) -> (constraint_name | None, description)
COLUMN_SPECS: dict[tuple[str, str], tuple[str | None, str]] = {
    # ── CIRCULATION ──────────────────────────────────────────────────────────
    ("circulation", "idCirculation"):  (None,               "identifiant CNIG du tronçon de cheminement, auto-généré si absent"),
    ("circulation", "from"):           (None,               "identifiant du nœud de départ du tronçon"),
    ("circulation", "to"):             (None,               "identifiant du nœud d'arrivée du tronçon"),
    ("circulation", "longueur"):       (None,               "longueur du tronçon en mètres (arrondie au mètre)"),
    ("circulation", "typeTroncon"):    ("type_troncon",     "type de tronçon"),
    ("circulation", "statutVoie"):     ("statut_voie",      "type de voie"),
    ("circulation", "pente"):          (None,               "inclinaison du terrain la plus défavorable dans le sens de circulation (en %)"),
    ("circulation", "devers"):         (None,               "inclinaison transversale du terrain dans le sens de circulation (en %)"),
    ("circulation", "urlMedia"):       (None,               "lien vers une ressource multimédia illustrant le tronçon"),
    ("circulation", "typeSol"):        ("type_sol",         "revêtement du tronçon"),
    ("circulation", "largeurUtile"):   (None,               "largeur utile du cheminement en mètres"),
    ("circulation", "etatRevetement"): ("etat_revetement",  "usure nuisant à la praticabilité du cheminement"),
    ("circulation", "eclairage"):      ("eclairage",        "nature de l'éclairage"),
    ("circulation", "transition"):     ("transition",       "type de transition du tronçon"),
    ("circulation", "typePassage"):    ("type_passage",     "type de passage (en surface, aérien, souterrain)"),
    ("circulation", "repereLineaire"): ("repere_lineaire",  "repère linéaire continu au sol"),
    ("circulation", "couvert"):        ("couvert",          "caractéristique de couverture du cheminement"),
    # ── NOEUD_CHEMINEMENT ───────────────────────────────────────────────────
    ("noeud_cheminement", "idNoeud"):             (None,                  "identifiant CNIG du nœud de cheminement, auto-généré si absent"),
    ("noeud_cheminement", "altitude"):            (None,                  "altitude NGF du nœud en mètres (résolution cm)"),
    ("noeud_cheminement", "bandeEveilVigilance"): ("etat",                "surface contrastée permettant de signaler un danger"),
    ("noeud_cheminement", "hauteurRessaut"):      (None,                  "hauteur du ressaut en mètres (résolution cm)"),
    ("noeud_cheminement", "abaissePente"):        (None,                  "pente de l'abaissé de trottoir en %"),
    ("noeud_cheminement", "abaisseLargeur"):      (None,                  "largeur de l'abaissé de trottoir en mètres"),
    ("noeud_cheminement", "masqueCovisibilite"):  ("masque_covisibilite", "masque visuel sur 5 m en amont d'une traversée"),
    ("noeud_cheminement", "controleBEV"):         ("controle_bev",        "contrôle de l'état des bandes d'éveil à la vigilance"),
    ("noeud_cheminement", "bandeInterception"):   (None,                  "présence d'une bande d'interception entre trottoir et chaussée (booléen)"),
    # ── OBSTACLE ─────────────────────────────────────────────────────────────
    ("obstacle", "idObstacle"):           (None,                "identifiant CNIG de l'obstacle, auto-généré si absent"),
    ("obstacle", "typeObstacle"):         ("type_obstacle",     "nature de l'élément situé dans le passage"),
    ("obstacle", "largeurUtile"):         (None,                "largeur utile du passage en mètres"),
    ("obstacle", "positionObstacle"):     ("position_obstacle", "position de l'élément situé dans le passage"),
    ("obstacle", "longueurObstacle"):     (None,                "longueur de l'obstacle en mètres"),
    ("obstacle", "rappelObstacle"):       ("rappel_obstacle",   "présence d'un élément de rappel de l'obstacle"),
    ("obstacle", "reperabiliteVisuelle"): (None,                "l'obstacle est visuellement repérable (booléen)"),
    ("obstacle", "urlMedia"):             (None,                "lien vers une ressource multimédia illustrant l'obstacle"),
    ("obstacle", "hauteurSousObs"):       (None,                "hauteur libre sous l'obstacle en mètres"),
    ("obstacle", "hauteurObsPoseSol"):    (None,                "hauteur de l'obstacle posé au sol en mètres"),
    # ── TRAVERSEE ────────────────────────────────────────────────────────────
    ("traversee", "idTraversee"):    (None,               "identifiant CNIG de la traversée, auto-généré si absent"),
    ("traversee", "from"):           (None,               "identifiant du nœud de départ"),
    ("traversee", "to"):             (None,               "identifiant du nœud d'arrivée"),
    ("traversee", "longueur"):       (None,               "longueur de la traversée en mètres"),
    ("traversee", "statutVoie"):     ("statut_voie",      "type de voie"),
    ("traversee", "pente"):          (None,               "inclinaison du terrain la plus défavorable (en %)"),
    ("traversee", "devers"):         (None,               "inclinaison transversale du terrain (en %)"),
    ("traversee", "urlMedia"):       (None,               "lien vers une ressource multimédia"),
    ("traversee", "etatRevetement"): ("etat",             "usure nuisant à la praticabilité du cheminement"),
    ("traversee", "typeMarquage"):   ("marquage",         "type de marquage au sol de la traversée piétonne"),
    ("traversee", "etatMarquage"):   ("etat",             "état du marquage au sol de la traversée piétonne"),
    ("traversee", "eclairage"):      ("eclairage",        "nature de l'éclairage"),
    ("traversee", "feuPietons"):     (None,               "présence de feux pour piétons (booléen)"),
    ("traversee", "aideSonore"):     ("etat",             "répétiteurs sonores émettant des signaux codés et parlés"),
    ("traversee", "repereLineaire"): ("repere_lineaire",  "repère linéaire continu au sol"),
    ("traversee", "chausseeBombee"): (None,               "la chaussée est bombée (booléen)"),
    ("traversee", "voiesTraversees"): (None,               "codes des voies traversées (B, C, T, V concatenés)"),
    # ── RAMPE ────────────────────────────────────────────────────────────────
    ("rampe", "idRampe"):         (None,               "identifiant CNIG de la rampe, auto-généré si absent"),
    ("rampe", "from"):            (None,               "identifiant du nœud de départ"),
    ("rampe", "to"):              (None,               "identifiant du nœud d'arrivée"),
    ("rampe", "longueur"):        (None,               "longueur de la rampe en mètres"),
    ("rampe", "statutVoie"):      ("statut_voie",      "type de voie"),
    ("rampe", "pente"):           (None,               "inclinaison du terrain la plus défavorable (en %)"),
    ("rampe", "devers"):          (None,               "inclinaison transversale du terrain (en %)"),
    ("rampe", "urlMedia"):        (None,               "lien vers une ressource multimédia"),
    ("rampe", "etatRevetement"):  ("etat",             "usure nuisant à la praticabilité du cheminement"),
    ("rampe", "largeurUtile"):    (None,               "largeur utile de la rampe en mètres"),
    ("rampe", "mainCourante"):    ("cote",             "élément sur lequel on pose la main pour s'appuyer"),
    ("rampe", "distPalierRepos"): (None,               "distance entre paliers de repos en mètres"),
    ("rampe", "chasseRoue"):      ("cote",             "présence de chasse roue en bordure de la rampe"),
    ("rampe", "aireRotation"):    ("position_hauteur", "présence d'une aire de rotation (UFR) en bas et/ou en haut de la rampe"),
    ("rampe", "poidsSupporte"):   (None,               "charge maximale supportée en kg"),
    # ── ESCALIER ─────────────────────────────────────────────────────────────
    ("escalier", "idEscalier"):           (None,          "identifiant CNIG de l'escalier, auto-généré si absent"),
    ("escalier", "from"):                 (None,          "identifiant du nœud de départ"),
    ("escalier", "to"):                   (None,          "identifiant du nœud d'arrivée"),
    ("escalier", "longueur"):             (None,          "longueur de l'escalier en mètres"),
    ("escalier", "statutVoie"):           ("statut_voie", "type de voie"),
    ("escalier", "pente"):                (None,          "inclinaison du terrain la plus défavorable (en %)"),
    ("escalier", "devers"):               (None,          "inclinaison transversale du terrain (en %)"),
    ("escalier", "urlMedia"):             (None,          "lien vers une ressource multimédia"),
    ("escalier", "etatRevetement"):       ("etat",        "usure nuisant à la praticabilité du cheminement"),
    ("escalier", "mainCourante"):         ("cote",        "élément sur lequel on pose la main pour s'appuyer"),
    ("escalier", "dispositifVigilance"):  ("etat",        "dispositif d'éveil de vigilance en haut de l'escalier"),
    ("escalier", "contrasteVisuel"):      ("etat",        "dispositif contrastant sur le nez des première et dernière marches"),
    ("escalier", "largeurUtile"):         (None,          "largeur utile de l'escalier en mètres"),
    ("escalier", "mainCouranteContinue"): ("cote",        "la main courante est-elle continue entre les volées de marches"),
    ("escalier", "prolongMainCourante"):  ("cote",        "prolongement de la main courante au-delà des première et dernière marches"),
    ("escalier", "nbMarches"):            (None,          "nombre de marches total de l'escalier"),
    ("escalier", "nbVoleeMarches"):       (None,          "nombre de volées de marches"),
    ("escalier", "hauteurMarche"):        (None,          "hauteur des contremarches en mètres"),
    ("escalier", "giron"):                (None,          "profondeur des marches (giron) en mètres"),
    # ── ESCALATOR ────────────────────────────────────────────────────────────
    ("escalator", "idEscalator"):         (None,          "identifiant CNIG de l'escalier mécanique, auto-généré si absent"),
    ("escalator", "from"):                (None,          "identifiant du nœud de départ"),
    ("escalator", "to"):                  (None,          "identifiant du nœud d'arrivée"),
    ("escalator", "longueur"):            (None,          "longueur de l'escalier mécanique en mètres"),
    ("escalator", "statutVoie"):          ("statut_voie", "type de voie"),
    ("escalator", "pente"):               (None,          "inclinaison du terrain la plus défavorable (en %)"),
    ("escalator", "devers"):              (None,          "inclinaison transversale du terrain (en %)"),
    ("escalator", "urlMedia"):            (None,          "lien vers une ressource multimédia"),
    ("escalator", "transition"):          ("transition",  "type d'escalator : montée, descente, variable"),
    ("escalator", "dispositifVigilance"): ("etat",        "dispositif d'éveil de vigilance"),
    ("escalator", "largeurUtile"):        (None,          "largeur utile de l'escalier mécanique en mètres"),
    ("escalator", "detecteur"):           (None,          "présence d'un détecteur automatique de présence (booléen)"),
    ("escalator", "supervision"):         (None,          "l'équipement est supervisé à distance (booléen)"),
    # ── TAPIS_ROULANT ────────────────────────────────────────────────────────
    ("tapis_roulant", "idTapisRoulant"):      (None,          "identifiant CNIG du tapis roulant, auto-généré si absent"),
    ("tapis_roulant", "from"):                (None,          "identifiant du nœud de départ"),
    ("tapis_roulant", "to"):                  (None,          "identifiant du nœud d'arrivée"),
    ("tapis_roulant", "longueur"):            (None,          "longueur du tapis roulant en mètres"),
    ("tapis_roulant", "statutVoie"):          ("statut_voie", "type de voie"),
    ("tapis_roulant", "pente"):               (None,          "inclinaison du terrain la plus défavorable (en %)"),
    ("tapis_roulant", "devers"):              (None,          "inclinaison transversale du terrain (en %)"),
    ("tapis_roulant", "urlMedia"):            (None,          "lien vers une ressource multimédia"),
    ("tapis_roulant", "sens"):                ("sens",        "sens de la translation du tapis roulant"),
    ("tapis_roulant", "dispositifVigilance"): ("etat",        "dispositif d'éveil de vigilance"),
    ("tapis_roulant", "largeurUtile"):        (None,          "largeur utile du tapis roulant en mètres"),
    ("tapis_roulant", "detecteur"):           (None,          "présence d'un détecteur automatique de présence (booléen)"),
    # ── QUAI ─────────────────────────────────────────────────────────────────
    ("quai", "idQuai"):              (None,                      "identifiant CNIG du quai, auto-généré si absent"),
    ("quai", "from"):                (None,                      "identifiant du nœud de départ"),
    ("quai", "to"):                  (None,                      "identifiant du nœud d'arrivée"),
    ("quai", "longueur"):            (None,                      "longueur du quai en mètres"),
    ("quai", "statutVoie"):          ("statut_voie",             "type de voie"),
    ("quai", "pente"):               (None,                      "inclinaison du terrain la plus défavorable (en %)"),
    ("quai", "devers"):              (None,                      "inclinaison transversale du terrain (en %)"),
    ("quai", "urlMedia"):            (None,                      "lien vers une ressource multimédia"),
    ("quai", "etatRevetement"):      ("etat",                    "usure nuisant à la praticabilité du cheminement"),
    ("quai", "hauteur"):             (None,                      "hauteur du quai en mètres (résolution cm)"),
    ("quai", "largeurPassage"):      (None,                      "largeur utile de passage en mètres"),
    ("quai", "signalisationPorte"):  ("dispositif_signalisation", "dispositif de signalisation de la porte accessible"),
    ("quai", "dispositifVigilance"): ("etat",                    "dispositif d'éveil à la vigilance sur le bord de quai"),
    ("quai", "diamZoneManoeuvre"):   (None,                      "diamètre de la zone de manœuvre en mètres"),
    # ── ASCENSEUR ────────────────────────────────────────────────────────────
    ("ascenseur", "idAscenseur"):         (None,                     "identifiant CNIG de l'ascenseur, auto-généré si absent"),
    ("ascenseur", "altitude"):            (None,                  "altitude NGF du nœud en mètres (résolution cm)"),
    ("ascenseur", "bandeEveilVigilance"): ("etat",                "surface contrastée permettant de signaler un danger"),
    ("ascenseur", "hauteurRessaut"):      (None,                  "hauteur du ressaut en mètres (résolution cm)"),
    ("ascenseur", "abaissePente"):        (None,                  "pente de l'abaissé de trottoir en %"),
    ("ascenseur", "abaisseLargeur"):      (None,                  "largeur de l'abaissé de trottoir en mètres"),
    ("ascenseur", "masqueCovisibilite"):  ("masque_covisibilite", "masque visuel sur 5 m en amont d'une traversée"),
    ("ascenseur", "controleBEV"):         ("controle_bev",        "contrôle de l'état des bandes d'éveil à la vigilance"),
    ("ascenseur", "bandeInterception"):   (None,                  "présence d'une bande d'interception entre trottoir et chaussée (booléen)"),
    ("ascenseur", "largeurUtile"):        (None,                     "largeur utile de la cabine en mètres"),
    ("ascenseur", "diamManoeuvFauteuil"): (None,                     "diamètre de la zone de manœuvre devant l'ascenseur en mètres"),
    ("ascenseur", "largeurCabine"):       (None,                     "largeur intérieure de la cabine en mètres"),
    ("ascenseur", "longueurCabine"):      (None,                     "longueur intérieure de la cabine en mètres"),
    ("ascenseur", "boutonsEnRelief"):     ("relief_boutons",          "touches en relief et en braille pour désigner les étages"),
    ("ascenseur", "annonceSonore"):       (None,                     "annonce sonore de l'étage (booléen)"),
    ("ascenseur", "signalEtage"):         ("dispositif_signalisation", "affichage visuel et/ou annonce sonore de l'étage atteint"),
    ("ascenseur", "boucleInducMagnet"):   (None,                     "présence d'une boucle à induction magnétique (booléen)"),
    ("ascenseur", "miroir"):              (None,                     "présence d'un miroir dans la cabine (booléen)"),
    ("ascenseur", "eclairage"):           (None,                     "niveau d'éclairage de la cabine en lux"),
    ("ascenseur", "voyantAlerte"):        ("voyant_ascenseur",        "voyant signalant une perturbation dans le fonctionnement"),
    ("ascenseur", "typeOuverture"):       ("type_ouverture",          "type d'ouverture (manuelle / automatique)"),
    ("ascenseur", "mainCourante"):        ("cote",                   "existence d'une barre d'aide au maintien"),
    ("ascenseur", "hauteurMainCourante"): (None,                     "hauteur de la barre d'aide au maintien en mètres"),
    ("ascenseur", "etatRevetement"):      ("etat",                   "usure nuisant à la praticabilité du cheminement"),
    ("ascenseur", "supervision"):         (None,                     "l'équipement est supervisé à distance (booléen)"),
    ("ascenseur", "autrePorteSortie"):    ("cote",                   "côté de la porte aux étages, si différent du rez-de-chaussée"),
    # ── ELEVATEUR ────────────────────────────────────────────────────────────
    ("elevateur", "idElevateur"):         (None,             "identifiant CNIG de l'élévateur, auto-généré si absent"),
    ("elevateur", "altitude"):            (None,                  "altitude NGF du nœud en mètres (résolution cm)"),
    ("elevateur", "bandeEveilVigilance"): ("etat",                "surface contrastée permettant de signaler un danger"),
    ("elevateur", "hauteurRessaut"):      (None,                  "hauteur du ressaut en mètres (résolution cm)"),
    ("elevateur", "abaissePente"):        (None,                  "pente de l'abaissé de trottoir en %"),
    ("elevateur", "abaisseLargeur"):      (None,                  "largeur de l'abaissé de trottoir en mètres"),
    ("elevateur", "masqueCovisibilite"):  ("masque_covisibilite", "masque visuel sur 5 m en amont d'une traversée"),
    ("elevateur", "controleBEV"):         ("controle_bev",        "contrôle de l'état des bandes d'éveil à la vigilance"),
    ("elevateur", "bandeInterception"):   (None,                  "présence d'une bande d'interception entre trottoir et chaussée (booléen)"),
    ("elevateur", "largeurUtile"):        (None,             "largeur utile de la plateforme en mètres"),
    ("elevateur", "boutonsEnRelief"):     ("relief_boutons", "touches en relief et en braille pour désigner les étages"),
    ("elevateur", "typeOuverture"):       ("type_ouverture", "type d'ouverture (manuelle / automatique)"),
    ("elevateur", "largeurPlateforme"):   (None,             "largeur de la plateforme en mètres"),
    ("elevateur", "longueurPlateforme"):  (None,             "longueur de la plateforme en mètres"),
    ("elevateur", "utilisableAutonomie"): (None,             "utilisable en autonomie sans aide (booléen)"),
    ("elevateur", "etatRevetement"):      ("etat",           "usure nuisant à la praticabilité du cheminement"),
    ("elevateur", "supervision"):         (None,             "l'équipement est supervisé à distance (booléen)"),
    ("elevateur", "autrePorteSortie"):    ("cote",           "côté de la porte aux étages, si différent du rez-de-chaussée"),
    ("elevateur", "chargeMaximum"):       (None,             "charge maximale supportée en kg"),
    ("elevateur", "accompagnateur"):      ("temporalite",    "existence d'un agent préposé à l'utilisation de l'élévateur"),
    # ── ENTREE ───────────────────────────────────────────────────────────────
    ("entree", "idEntree"):             (None,               "identifiant CNIG de l'entrée, auto-généré si absent"),
    ("entree", "altitude"):             (None,                  "altitude NGF du nœud en mètres (résolution cm)"),
    ("entree", "bandeEveilVigilance"):  ("etat",                "surface contrastée permettant de signaler un danger"),
    ("entree", "hauteurRessaut"):       (None,                  "hauteur du ressaut en mètres (résolution cm)"),
    ("entree", "abaissePente"):         (None,                  "pente de l'abaissé de trottoir en %"),
    ("entree", "abaisseLargeur"):       (None,                  "largeur de l'abaissé de trottoir en mètres"),
    ("entree", "masqueCovisibilite"):   ("masque_covisibilite", "masque visuel sur 5 m en amont d'une traversée"),
    ("entree", "controleBEV"):          ("controle_bev",        "contrôle de l'état des bandes d'éveil à la vigilance"),
    ("entree", "bandeInterception"):    (None,                  "présence d'une bande d'interception entre trottoir et chaussée (booléen)"),
    ("entree", "adresse"):              (None,               "adresse de l'entrée"),
    ("entree", "typeEntree"):           ("type_entree",      "type d'entrée"),
    ("entree", "rampe"):                ("rampe_erp",        "présence d'une rampe d'accès à l'entrée"),
    ("entree", "rampeSonnette"):        (None,               "présence d'une sonnette à proximité de la rampe (booléen)"),
    ("entree", "ascenseur"):            (None,               "présence d'un ascenseur à l'entrée (booléen)"),
    ("entree", "escalierNbMarche"):     (None,               "nombre de marches de l'escalier à l'entrée (0 si pas de marche)"),
    ("entree", "escalierMainCourante"): ("cote",             "présence d'une main courante sur l'escalier à l'entrée"),
    ("entree", "reperabilite"):         (None,               "l'entrée est facilement repérable (booléen)"),
    ("entree", "reperageEltsVitres"):   (None,               "présence de repérage sur les éléments vitrés (booléen)"),
    ("entree", "signaletique"):         (None,               "présence d'une signalétique directionnelle (booléen)"),
    ("entree", "largeurPassage"):       (None,               "largeur utile de passage en mètres"),
    ("entree", "controleAcces"):        ("controle_acces",   "équipement de contrôle d'accès à l'entrée"),
    ("entree", "entreeAccueilVisible"): (None,               "l'accueil est visible depuis l'entrée (booléen)"),
    ("entree", "eclairage"):            (None,               "niveau d'éclairage de l'entrée en lux"),
    ("entree", "typePorte"):            ("type_porte",       "type de porte à l'entrée"),
    ("entree", "typeOuverture"):        ("type_ouverture",   "type d'ouverture (manuelle / automatique)"),
    ("entree", "espaceManoeuvre"):      ("position_espace",  "présence d'un espace de manœuvre à proximité immédiate de la porte"),
    ("entree", "largManoeuvreExt"):     (None,               "largeur de l'espace de manœuvre côté extérieur en mètres"),
    ("entree", "longManoeuvreExt"):     (None,               "longueur de l'espace de manœuvre côté extérieur en mètres"),
    ("entree", "largManoeuvreInt"):     (None,               "largeur de l'espace de manœuvre côté intérieur en mètres"),
    ("entree", "longManoeuvreInt"):     (None,               "longueur de l'espace de manœuvre côté intérieur en mètres"),
    ("entree", "typePoignee"):          ("type_poignee",     "type de poignée"),
    ("entree", "effortOuverture"):      (None,               "effort d'ouverture de la porte en newtons"),
    # ── PASSAGE_SELECTIF ─────────────────────────────────────────────────────
    ("passage_selectif", "idPassageSelectif"):  (None, "identifiant CNIG du passage sélectif, auto-généré si absent"),
    ("passage_selectif", "altitude"):           (None,                  "altitude NGF du nœud en mètres (résolution cm)"),
    ("passage_selectif", "bandeEveilVigilance"):("etat",                "surface contrastée permettant de signaler un danger"),
    ("passage_selectif", "hauteurRessaut"):     (None,                  "hauteur du ressaut en mètres (résolution cm)"),
    ("passage_selectif", "abaissePente"):       (None,                  "pente de l'abaissé de trottoir en %"),
    ("passage_selectif", "abaisseLargeur"):     (None,                  "largeur de l'abaissé de trottoir en mètres"),
    ("passage_selectif", "masqueCovisibilite"): ("masque_covisibilite", "masque visuel sur 5 m en amont d'une traversée"),
    ("passage_selectif", "controleBEV"):        ("controle_bev",        "contrôle de l'état des bandes d'éveil à la vigilance"),
    ("passage_selectif", "bandeInterception"):  (None,                  "présence d'une bande d'interception entre trottoir et chaussée (booléen)"),
    ("passage_selectif", "passageMecanique"):   (None, "passage à mécanisme motorisé (booléen)"),
    ("passage_selectif", "largeurUtile"):       (None, "largeur utile du passage en mètres"),
    ("passage_selectif", "profondeur"):         (None, "profondeur du passage en mètres"),
    ("passage_selectif", "contrasteVisuel"):    (None, "présence d'un contraste visuel (booléen)"),
    # ── STATIONNEMENT_PMR ────────────────────────────────────────────────────
    ("stationnement_pmr", "idStationnement"):   (None,                 "identifiant CNIG de la place de stationnement PMR, auto-généré si absent"),
    ("stationnement_pmr", "typeStationnement"): ("type_stationnement", "type de stationnement (longitudinal, épi, bataille)"),
    ("stationnement_pmr", "etatRevetement"):    ("etat",               "usure nuisant à la praticabilité du cheminement"),
    ("stationnement_pmr", "largeurStat"):       (None,                 "largeur de la place de stationnement en mètres"),
    ("stationnement_pmr", "longueurStat"):      (None,                 "longueur de la place de stationnement en mètres"),
    ("stationnement_pmr", "bandLatSecurite"):   (None,                 "présence d'une bande latérale de sécurité (booléen)"),
    ("stationnement_pmr", "surLongueur"):       (None,                 "surlongueur de la place en mètres"),
    ("stationnement_pmr", "signalPMR"):         (None,                 "présence d'une signalisation PMR (booléen)"),
    ("stationnement_pmr", "marquageSol"):       (None,                 "présence d'un marquage au sol (booléen)"),
    ("stationnement_pmr", "pente"):             (None,                 "inclinaison de la place de stationnement (en %)"),
    ("stationnement_pmr", "devers"):            (None,                 "inclinaison transversale de la place de stationnement (en %)"),
    ("stationnement_pmr", "typeSol"):           ("type_sol",           "matériau de revêtement du stationnement"),
    # ── ERP ──────────────────────────────────────────────────────────────────
    ("erp", "idERP"):               (None,            "identifiant CNIG de l'ERP, auto-généré si absent"),
    ("erp", "nom"):                 (None,            "nom de l'ERP"),
    ("erp", "adresse"):             (None,            "adresse de l'ERP"),
    ("erp", "codePostal"):          (None,            "code postal de l'ERP (5 caractères)"),
    ("erp", "erpCategorie"):        ("categorie_erp", "catégorie de l'ERP (déterminée selon la capacité d'accueil du bâtiment)"),
    ("erp", "erpType"):             ("type_erp",      "type de l'ERP (déterminé selon son activité ou la nature de l'exploitation)"),
    ("erp", "dateMiseAJour"):       (None,            "date de mise à jour de la fiche (format ISO 8601 AAAA-MM-JJ)"),
    ("erp", "sourceMiseAJour"):     (None,            "source de la mise à jour des données"),
    ("erp", "stationnementERP"):    (None,            "présence d'un stationnement ERP à proximité immédiate (booléen)"),
    ("erp", "stationnementPMR"):    (None,            "nombre de places de stationnement PMR à proximité immédiate"),
    ("erp", "accueilPersonnel"):    ("personnel_erp", "présence de personnel d'accueil"),
    ("erp", "accueilBIM"):          (None,            "présence d'une boucle à induction magnétique fixe (booléen)"),
    ("erp", "accueilBIMPortative"): (None,            "présence d'une boucle à induction magnétique portative (booléen)"),
    ("erp", "accueilLSF"):          (None,            "accueil en langue des signes française (booléen)"),
    ("erp", "accueilST"):           (None,            "accueil par sous-titrage (booléen)"),
    ("erp", "accueilAideAudition"): (None,            "présence d'une aide à l'audition (booléen)"),
    ("erp", "accueilPrestations"):  (None,            "description des prestations d'accueil proposées"),
    ("erp", "sanitairesERP"):       (None,            "présence de sanitaires dans l'ERP (booléen)"),
    ("erp", "sanitairesAdaptes"):   (None,            "nombre de sanitaires adaptés"),
    ("erp", "telephone"):           (None,            "numéro de téléphone de l'ERP"),
    ("erp", "siteWeb"):             (None,            "adresse du site web de l'ERP"),
    ("erp", "siret"):               (None,            "numéro SIRET de l'ERP (14 caractères)"),
    ("erp", "latitude"):            (None,            "latitude WGS84 du centroïde de l'ERP (décimal)"),
    ("erp", "longitude"):           (None,            "longitude WGS84 du centroïde de l'ERP (décimal)"),
    ("erp", "erpActivite"):         (None,            "activité de l'ERP"),
}

COLUMN_CONSTRAINTS: dict[tuple[str, str], str] = {
    k: v[0] for k, v in COLUMN_SPECS.items() if v[0] is not None
}
COLUMN_DESCRIPTIONS: dict[tuple[str, str], str] = {
    k: v[1] for k, v in COLUMN_SPECS.items()
}


# Multi-value columns (| separator)
_SEP = "|"
MULTIVALUE_COLUMNS: frozenset[tuple[str, str]] = frozenset({
    ("noeud_cheminement", "controleBEV"),
    ("ascenseur", "controleBEV"),
    ("elevateur", "controleBEV"),
    ("entree", "controleBEV"),
    ("passage_selectif", "controleBEV"),
})


# Validation value tools
def allowed_values(table: str, column: str) -> tuple[str, ...] | None:
    """Returns the allowed enum values for (table, column), or None if unconstrained or glob."""
    cname = COLUMN_CONSTRAINTS.get((table, column))
    return ENUM_CONSTRAINTS.get(cname) if cname else None


def validate(table: str, column: str, value: str) -> bool:
    """True if the value is valid for (table, column) according to the standard.

    Checks enum constraints only. Glob constraints (voiesTraversees) are
    enforced at SQL level via CHECK constraint.
    For multi-value columns (controleBEV), checks each part separated by '|'.
    """
    cname = COLUMN_CONSTRAINTS.get((table, column))
    if cname is None:
        return True
    vals = ENUM_CONSTRAINTS.get(cname)
    if vals is None:
        return True
    if (table, column) in MULTIVALUE_COLUMNS:
        parts = [v.strip() for v in value.split(_SEP) if v.strip()]
        return bool(parts) and all(v in vals for v in parts)
    return value in vals
