-- =====================================================
-- SCRIPT DE CRÉATION DE LA BASE DE DONNÉES
-- Projet: SCHEDULER - Gestion des emplois du temps
-- Université Iba Der Thiam de Thiès (UIDT)
-- =====================================================

DROP DATABASE IF EXISTS univ_scheduler; CREATE DATABASE univ_scheduler; USE univ_scheduler;

-- TABLE ufr (Unités de Formation et de Recherche)
CREATE TABLE ufr (id INT PRIMARY KEY AUTO_INCREMENT, nom VARCHAR(100) NOT NULL UNIQUE, description TEXT, date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

-- TABLE batiments (liés aux UFR)
CREATE TABLE batiments (id INT PRIMARY KEY AUTO_INCREMENT, nom VARCHAR(100) NOT NULL, localisation VARCHAR(255), nb_etages INT DEFAULT 1, ufr_id INT NOT NULL, statut ENUM('disponible', 'indisponible') DEFAULT 'disponible', motif_indisponibilite TEXT, date_debut_indisponibilite DATE, date_fin_indisponibilite DATE, FOREIGN KEY (ufr_id) REFERENCES ufr(id) ON DELETE CASCADE);

-- TABLE salles (liées aux bâtiments)
CREATE TABLE salles (id INT PRIMARY KEY AUTO_INCREMENT, numero VARCHAR(20) NOT NULL, capacite INT NOT NULL, type ENUM('TD', 'TP', 'Amphi', 'Autre') DEFAULT 'Autre', batiment_id INT NOT NULL, etage INT DEFAULT 0, statut ENUM('disponible', 'indisponible') DEFAULT 'disponible', motif_indisponibilite TEXT, date_debut_indisponibilite DATE, date_fin_indisponibilite DATE, FOREIGN KEY (batiment_id) REFERENCES batiments(id) ON DELETE CASCADE);

-- TABLE equipements
CREATE TABLE equipements (id INT PRIMARY KEY AUTO_INCREMENT, nom VARCHAR(100) NOT NULL UNIQUE, description TEXT);

-- TABLE liaison salle_equipement
CREATE TABLE salle_equipement (salle_id INT, equipement_id INT, PRIMARY KEY (salle_id, equipement_id), FOREIGN KEY (salle_id) REFERENCES salles(id) ON DELETE CASCADE, FOREIGN KEY (equipement_id) REFERENCES equipements(id) ON DELETE CASCADE);

-- TABLE classes
CREATE TABLE classes (id INT PRIMARY KEY AUTO_INCREMENT, intitule VARCHAR(200) NOT NULL, filiere VARCHAR(100) NOT NULL, niveau VARCHAR(50) NOT NULL, annee_scolaire VARCHAR(20) NOT NULL, ufr_id INT NOT NULL, effectif INT DEFAULT 0, nb_groupes INT DEFAULT 1, est_active BOOLEAN DEFAULT TRUE, date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (ufr_id) REFERENCES ufr(id) ON DELETE CASCADE, UNIQUE KEY unique_classe (intitule, annee_scolaire));

-- TABLE utilisateurs
CREATE TABLE utilisateurs (id INT PRIMARY KEY AUTO_INCREMENT, nom VARCHAR(100) NOT NULL, prenom VARCHAR(100) NOT NULL, email VARCHAR(150) UNIQUE NOT NULL, mot_de_passe VARCHAR(255) NOT NULL, role ENUM('admin', 'gestionnaire', 'enseignant', 'etudiant') NOT NULL, date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP, est_valide BOOLEAN DEFAULT FALSE, date_validation DATE, numero_etudiant VARCHAR(50), matricule_enseignant VARCHAR(50), ufr_id INT, classe_id INT, FOREIGN KEY (ufr_id) REFERENCES ufr(id) ON DELETE SET NULL, FOREIGN KEY (classe_id) REFERENCES classes(id) ON DELETE SET NULL);

-- TABLE demandes_inscription
CREATE TABLE demandes_inscription (id INT PRIMARY KEY AUTO_INCREMENT, nom VARCHAR(100) NOT NULL, prenom VARCHAR(100) NOT NULL, email VARCHAR(150) NOT NULL, role_demande ENUM('etudiant', 'enseignant', 'gestionnaire') NOT NULL, numero_etudiant VARCHAR(50), ufr_id INT, classe_id INT, matricule_enseignant VARCHAR(50), date_demande TIMESTAMP DEFAULT CURRENT_TIMESTAMP, statut ENUM('en_attente', 'validee', 'refusee') DEFAULT 'en_attente', FOREIGN KEY (ufr_id) REFERENCES ufr(id) ON DELETE SET NULL, FOREIGN KEY (classe_id) REFERENCES classes(id) ON DELETE SET NULL);

-- TABLE matieres
CREATE TABLE matieres (id INT PRIMARY KEY AUTO_INCREMENT, nom VARCHAR(200) NOT NULL, code VARCHAR(50) UNIQUE NOT NULL, filiere VARCHAR(100) NOT NULL, volume_horaire INT DEFAULT 0, description TEXT, date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

-- TABLE cours
CREATE TABLE cours (id INT PRIMARY KEY AUTO_INCREMENT, matiere_id INT NOT NULL, enseignant_id INT NOT NULL, classe_id INT NOT NULL, type_cours ENUM('CM', 'TD', 'TP') NOT NULL, groupes VARCHAR(255), volume_horaire INT NOT NULL, date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (matiere_id) REFERENCES matieres(id) ON DELETE CASCADE, FOREIGN KEY (enseignant_id) REFERENCES utilisateurs(id) ON DELETE CASCADE, FOREIGN KEY (classe_id) REFERENCES classes(id) ON DELETE CASCADE);

-- TABLE creneaux
CREATE TABLE creneaux (id INT PRIMARY KEY AUTO_INCREMENT, cours_id INT NOT NULL, jour DATE NOT NULL, heure_debut TIME NOT NULL, heure_fin TIME NOT NULL, salle_id INT, statut ENUM('planifie', 'annule', 'deplace') DEFAULT 'planifie', motif_annulation TEXT, FOREIGN KEY (cours_id) REFERENCES cours(id) ON DELETE CASCADE, FOREIGN KEY (salle_id) REFERENCES salles(id) ON DELETE SET NULL);

-- TABLE emplois_du_temps
CREATE TABLE emplois_du_temps (id INT PRIMARY KEY AUTO_INCREMENT, classe_id INT NOT NULL, periode_type ENUM('hebdomadaire', 'mensuel', 'semestriel') NOT NULL, periode_debut DATE NOT NULL, periode_fin DATE NOT NULL, date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP, est_valide BOOLEAN DEFAULT FALSE, date_validation DATE, FOREIGN KEY (classe_id) REFERENCES classes(id) ON DELETE CASCADE);

-- TABLE emploi_du_temps_creneaux
CREATE TABLE emploi_du_temps_creneaux (emploi_id INT, creneau_id INT, PRIMARY KEY (emploi_id, creneau_id), FOREIGN KEY (emploi_id) REFERENCES emplois_du_temps(id) ON DELETE CASCADE, FOREIGN KEY (creneau_id) REFERENCES creneaux(id) ON DELETE CASCADE);

-- TABLE reservations (réservations ponctuelles)
CREATE TABLE reservations (id INT PRIMARY KEY AUTO_INCREMENT, utilisateur_id INT NOT NULL, salle_id INT NOT NULL, motif VARCHAR(255) NOT NULL, description TEXT, date_reservation DATE NOT NULL, heure_debut TIME NOT NULL, heure_fin TIME NOT NULL, statut ENUM('confirmee', 'en_cours', 'terminee', 'annulee') DEFAULT 'confirmee', date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id) ON DELETE CASCADE, FOREIGN KEY (salle_id) REFERENCES salles(id) ON DELETE CASCADE);

-- TABLE signalements
CREATE TABLE signalements (id INT PRIMARY KEY AUTO_INCREMENT, utilisateur_id INT NOT NULL, salle_id INT NOT NULL, type_probleme VARCHAR(100) NOT NULL, description TEXT NOT NULL, date_signalement TIMESTAMP DEFAULT CURRENT_TIMESTAMP, statut ENUM('en_attente', 'en_cours', 'resolu') DEFAULT 'en_attente', date_resolution DATE, commentaire_resolution TEXT, FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id) ON DELETE CASCADE, FOREIGN KEY (salle_id) REFERENCES salles(id) ON DELETE CASCADE);

-- =====================================================
-- INSERTION DES DONNÉES DE TEST - UFR (UIDT)
-- =====================================================
INSERT INTO ufr (nom, description) VALUES ('UFR Sciences et Technologies (UFR SET)', 'Sciences exactes, informatique, mathématiques, physique, hydrosciences'), ('UFR Sciences de l\'Ingénieur (UFR SI)', 'Génie civil, génie informatique, géotechnique, hydrogéologie, architecture'), ('UFR Sciences Économiques et Sociales (UFR SES)', 'Économie, gestion, tourisme, langues, management'), ('UFR Sciences de la Santé (UFR Santé)', 'Médecine générale'), ('École Nationale Supérieure d\'Agriculture (ENSA)', 'Agronomie, productions végétales/animales, foresterie'), ('Institut Universitaire de Technologie (IUT)', 'Formations techniques courtes (DUT)');

-- =====================================================
-- INSERTION DES CLASSES
-- =====================================================
INSERT INTO classes (intitule, filiere, niveau, annee_scolaire, ufr_id, effectif, nb_groupes) VALUES ('L1 Informatique', 'Informatique', 'Licence 1', '2024-2025', 1, 150, 5), ('L2 Informatique', 'Informatique', 'Licence 2', '2024-2025', 1, 120, 4), ('L3 Informatique', 'Informatique', 'Licence 3', '2024-2025', 1, 90, 3), ('L1 Mathématiques', 'Mathématiques', 'Licence 1', '2024-2025', 1, 100, 4), ('L2 Mathématiques', 'Mathématiques', 'Licence 2', '2024-2025', 1, 85, 3), ('L1 Génie Civil', 'Génie Civil', 'Licence 1', '2024-2025', 2, 80, 3), ('L2 Génie Informatique', 'Génie Informatique', 'Licence 2', '2024-2025', 2, 70, 3), ('L1 Sciences Économiques', 'Sciences Économiques', 'Licence 1', '2024-2025', 3, 120, 4), ('L2 Management', 'Management', 'Licence 2', '2024-2025', 3, 90, 3), ('L1 Agronomie', 'Agronomie', 'Licence 1', '2024-2025', 5, 60, 2);

-- =====================================================
-- INSERTION DES UTILISATEURS
-- =====================================================
INSERT INTO utilisateurs (nom, prenom, email, mot_de_passe, role, est_valide, date_validation) VALUES ('Niang', 'Mouhamadou Lamine', 'mouhamedlniang@gmail.com', 'admin123', 'admin', TRUE, CURDATE()), ('Nguer', 'Mouhameth', 'mouhamethnguer@gmail.com', 'admin123', 'admin', TRUE, CURDATE());

INSERT INTO utilisateurs (nom, prenom, email, mot_de_passe, role, est_valide, date_validation) VALUES ('Diop', 'Fatou', 'fatou.diop@univ.sn', 'gestion123', 'gestionnaire', TRUE, CURDATE());

INSERT INTO utilisateurs (nom, prenom, email, mot_de_passe, role, matricule_enseignant, est_valide, date_validation) VALUES ('Fall', 'Oumar', 'oumar.fall@univ.sn', 'prof123', 'enseignant', 'ENS2024001', TRUE, CURDATE());

INSERT INTO utilisateurs (nom, prenom, email, mot_de_passe, role, numero_etudiant, ufr_id, classe_id, est_valide, date_validation) VALUES ('Sy', 'Aminata', 'aminata.sy@etudiant.univ.sn', 'etud123', 'etudiant', '20240001', 1, 1, TRUE, CURDATE());

-- =====================================================
-- INSERTION DES ÉQUIPEMENTS
-- =====================================================
INSERT INTO equipements (nom, description) VALUES ('Vidéoprojecteur', 'Projecteur HDMI/VGA'), ('Tableau interactif', 'Tableau blanc tactile'), ('Climatisation', 'Climatisation réversible'), ('Système audio', 'Enceintes et micro'), ('Ordinateur', 'PC fixe avec écran');

-- =====================================================
-- INSERTION DES BÂTIMENTS
-- =====================================================
INSERT INTO batiments (nom, localisation, nb_etages, ufr_id) VALUES ('Bâtiment A', 'Campus Nord', 3, 1), ('Bâtiment B', 'Campus Nord', 2, 1), ('Bâtiment C', 'Campus Sud', 4, 2), ('Bâtiment D', 'Campus Sud', 3, 3), ('Bâtiment E', 'Campus Est', 2, 5);

-- =====================================================
-- INSERTION DES SALLES
-- =====================================================
INSERT INTO salles (numero, capacite, type, batiment_id, etage) VALUES ('A101', 30, 'TD', 1, 1), ('A102', 25, 'TD', 1, 1), ('A103', 40, 'TD', 1, 1), ('A201', 50, 'Amphi', 1, 2), ('B101', 30, 'TD', 2, 1), ('B202', 100, 'Amphi', 2, 2), ('C101', 30, 'TD', 3, 1), ('C201', 25, 'TP', 3, 2), ('D101', 40, 'TD', 4, 1), ('E101', 60, 'Amphi', 5, 1);

-- =====================================================
-- INSERTION DES LIAISONS SALLES-ÉQUIPEMENTS
-- =====================================================
INSERT INTO salle_equipement (salle_id, equipement_id) VALUES (1, 1), (1, 2), (2, 1), (3, 1), (3, 2), (3, 3), (4, 1), (4, 3), (4, 4), (5, 1), (6, 1), (6, 3), (6, 4), (7, 1), (8, 1), (8, 2), (8, 5), (9, 1), (9, 3), (10, 1), (10, 4);

-- =====================================================
-- INSERTION DES MATIÈRES
-- =====================================================
INSERT INTO matieres (nom, code, filiere, volume_horaire) VALUES ('Mathématiques pour l\'informatique', 'INF101', 'Informatique', 60), ('Algorithmique', 'INF102', 'Informatique', 45), ('Programmation Java', 'INF201', 'Informatique', 60), ('Bases de données', 'INF202', 'Informatique', 45), ('Réseaux', 'INF301', 'Informatique', 45), ('Mécanique des sols', 'GC101', 'Génie Civil', 50), ('Résistance des matériaux', 'GC102', 'Génie Civil', 55), ('Microéconomie', 'ECO101', 'Sciences Économiques', 40);

-- =====================================================
-- INSERTION DES COURS
-- =====================================================
INSERT INTO cours (matiere_id, enseignant_id, classe_id, type_cours, groupes, volume_horaire) VALUES (1, 3, 2, 'CM', 'tous', 30), (2, 3, 2, 'TD', 'G1,G2,G3,G4', 30), (3, 3, 2, 'CM', 'tous', 30), (4, 3, 2, 'CM', 'tous', 25), (1, 3, 1, 'CM', 'tous', 30), (6, 3, 6, 'CM', 'tous', 30), (8, 3, 8, 'CM', 'tous', 25);

-- =====================================================
-- INSERTION DES DEMANDES D'INSCRIPTION (en attente)
-- =====================================================
INSERT INTO demandes_inscription (nom, prenom, email, role_demande, numero_etudiant, ufr_id, classe_id) VALUES ('Dieng', 'Mamadou', 'mamadou.dieng@etudiant.fr', 'etudiant', '20240002', 1, 1), ('Sow', 'Aissatou', 'aissatou.sow@etudiant.fr', 'etudiant', '20240003', 1, 2), ('Faye', 'Ibrahima', 'ibrahima.faye@enseignant.fr', 'enseignant', NULL, NULL, NULL), ('Gueye', 'Mariama', 'mariama.gueye@univ.fr', 'gestionnaire', NULL, NULL, NULL);

-- =====================================================
-- FIN DU SCRIPT
-- =====================================================