-- Script SQL complet pour le projet de base de données hôtelière
-- Compatible MySQL
-- Contient à la fois la création des tables et l'insertion des données

-- 1. Suppression de la base existante (si nécessaire)
DROP DATABASE IF EXISTS hotel_db;

-- 2. Création de la base de données
CREATE DATABASE hotel_db;
USE hotel_db;

-- 3. Création des tables

-- Table Hotel
CREATE TABLE Hotel (
    Id_Hotel INT AUTO_INCREMENT PRIMARY KEY,
    Ville VARCHAR(100) NOT NULL,
    Pays VARCHAR(100) NOT NULL,
    Code_postal INT NOT NULL
);

-- Table Type_Chambre
CREATE TABLE Type_Chambre (
    Id_Type INT AUTO_INCREMENT PRIMARY KEY,
    Type VARCHAR(50) NOT NULL,
    Tarif DECIMAL(10,2) NOT NULL
);

-- Table Chambre
CREATE TABLE Chambre (
    Id_Chambre INT AUTO_INCREMENT PRIMARY KEY,
    Numero INT NOT NULL,
    Etage INT NOT NULL,
    Fumeur BOOLEAN NOT NULL DEFAULT FALSE,
    Id_Hotel INT NOT NULL,
    Id_Type INT NOT NULL,
    FOREIGN KEY (Id_Hotel) REFERENCES Hotel(Id_Hotel) ON DELETE CASCADE,
    FOREIGN KEY (Id_Type) REFERENCES Type_Chambre(Id_Type) ON DELETE CASCADE,
    UNIQUE KEY unique_numero_hotel (Numero, Id_Hotel)
);

-- Table Client
CREATE TABLE Client (
    Id_Client INT AUTO_INCREMENT PRIMARY KEY,
    Adresse VARCHAR(255) NOT NULL,
    Ville VARCHAR(100) NOT NULL,
    Code_postal INT NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Telephone VARCHAR(20) NOT NULL,
    Nom_complet VARCHAR(100) NOT NULL,
    UNIQUE KEY unique_email (Email)
);

-- Table Prestation
CREATE TABLE Prestation (
    Id_Prestation INT AUTO_INCREMENT PRIMARY KEY,
    Prix DECIMAL(10,2) NOT NULL,
    Description VARCHAR(255) NOT NULL
);

-- Table Hotel_Prestation (relation many-to-many)
CREATE TABLE Hotel_Prestation (
    Id_Hotel INT NOT NULL,
    Id_Prestation INT NOT NULL,
    PRIMARY KEY (Id_Hotel, Id_Prestation),
    FOREIGN KEY (Id_Hotel) REFERENCES Hotel(Id_Hotel) ON DELETE CASCADE,
    FOREIGN KEY (Id_Prestation) REFERENCES Prestation(Id_Prestation) ON DELETE CASCADE
);

-- Table Reservation
CREATE TABLE Reservation (
    Id_Reservation INT AUTO_INCREMENT PRIMARY KEY,
    Date_arrivee DATE NOT NULL,
    Date_depart DATE NOT NULL,
    Id_Client INT NOT NULL,
    Id_Chambre INT NOT NULL,
    FOREIGN KEY (Id_Client) REFERENCES Client(Id_Client) ON DELETE CASCADE,
    FOREIGN KEY (Id_Chambre) REFERENCES Chambre(Id_Chambre) ON DELETE CASCADE,
    CHECK (Date_depart > Date_arrivee)
);

-- Table Evaluation
CREATE TABLE Evaluation (
    Id_Evaluation INT AUTO_INCREMENT PRIMARY KEY,
    Date DATE NOT NULL,
    Note INT NOT NULL,
    Commentaire TEXT,
    Id_Client INT NOT NULL,
    FOREIGN KEY (Id_Client) REFERENCES Client(Id_Client) ON DELETE CASCADE,
    CHECK (Note BETWEEN 1 AND 5)
);

-- 4. Insertion des données

-- Données Hotel
INSERT INTO Hotel (Id_Hotel, Ville, Pays, Code_postal) VALUES
(1, 'Paris', 'France', 75001),
(2, 'Lyon', 'France', 69002);

-- Données Client
INSERT INTO Client (Id_Client, Adresse, Ville, Code_postal, Email, Telephone, Nom_complet) VALUES
(1, '12 Rue de Paris', 'Paris', 75001, 'jean.dupont@email.fr', '0612345678', 'Jean Dupont'),
(2, '5 Avenue Victor Hugo', 'Lyon', 69002, 'marie.leroy@email.fr', '0623456789', 'Marie Leroy'),
(3, '8 Boulevard Saint-Michel', 'Marseille', 13005, 'paul.moreau@email.fr', '0634567890', 'Paul Moreau'),
(4, '27 Rue Nationale', 'Lille', 59800, 'lucie.martin@email.fr', '0645678901', 'Lucie Martin'),
(5, '3 Rue des Fleurs', 'Nice', 06000, 'emma.giraud@email.fr', '0656789012', 'Emma Giraud');

-- Données Prestation
INSERT INTO Prestation (Id_Prestation, Prix, Description) VALUES
(1, 15, 'Petit-déjeuner'),
(2, 30, 'Navette aéroport'),
(3, 0, 'Wi-Fi gratuit'),
(4, 50, 'Spa et bien-être'),
(5, 20, 'Parking sécurisé');

-- Données Type_Chambre
INSERT INTO Type_Chambre (Id_Type, Type, Tarif) VALUES
(1, 'Simple', 80),
(2, 'Double', 120);

-- Données Chambre
INSERT INTO Chambre (Id_Chambre, Numero, Etage, Fumeur, Id_Hotel, Id_Type) VALUES
(1, 201, 2, FALSE, 1, 1),
(2, 502, 5, TRUE, 1, 2),
(3, 305, 3, FALSE, 2, 1),
(4, 410, 4, FALSE, 2, 2),
(5, 104, 1, TRUE, 2, 2),
(6, 202, 2, FALSE, 1, 1),
(7, 307, 3, TRUE, 1, 2),
(8, 101, 1, FALSE, 1, 1);

-- Données Hotel_Prestation
INSERT INTO Hotel_Prestation (Id_Hotel, Id_Prestation) VALUES
(1, 1), (1, 3), (1, 5),  -- Paris offre petit-déj, wifi, parking
(2, 1), (2, 2), (2, 3), (2, 4);  -- Lyon offre tout

-- Données Reservation
INSERT INTO Reservation (Id_Reservation, Date_arrivee, Date_depart, Id_Client, Id_Chambre) VALUES
(1, '2025-06-15', '2025-06-18', 1, 1),
(2, '2025-07-01', '2025-07-05', 2, 2),
(3, '2025-08-10', '2025-08-14', 3, 3),
(4, '2025-09-05', '2025-09-07', 4, 4),
(5, '2025-09-20', '2025-09-25', 5, 5),
(7, '2025-11-12', '2025-11-14', 2, 7),
(9, '2026-01-15', '2026-01-18', 4, 4),
(10, '2026-02-01', '2026-02-05', 2, 2);

-- Données Evaluation
INSERT INTO Evaluation (Id_Evaluation, Date, Note, Commentaire, Id_Client) VALUES
(1, '2025-06-15', 5, 'Excellent séjour, personnel très accueillant.', 1),
(2, '2025-07-01', 4, 'Chambre propre, bon rapport qualité/prix.', 2),
(3, '2025-08-10', 3, 'Séjour correct mais bruyant la nuit.', 3),
(4, '2025-09-05', 5, 'Service impeccable, je recommande.', 4),
(5, '2025-09-20', 4, 'Très bon petit-déjeuner, hôtel bien situé.', 5);

-- 5. Requêtes demandées

-- 3a. Liste des réservations avec nom client et ville hôtel
SELECT 
    r.Id_Reservation,
    c.Nom_complet AS Client,
    h.Ville AS Ville_Hotel,
    r.Date_arrivee,
    r.Date_depart,
    ch.Numero AS Numero_Chambre,
    tc.Type AS Type_Chambre
FROM Reservation r
JOIN Client c ON r.Id_Client = c.Id_Client
JOIN Chambre ch ON r.Id_Chambre = ch.Id_Chambre
JOIN Hotel h ON ch.Id_Hotel = h.Id_Hotel
JOIN Type_Chambre tc ON ch.Id_Type = tc.Id_Type
ORDER BY r.Date_arrivee;

-- 3b. Clients habitant à Paris
SELECT * FROM Client WHERE Ville = 'Paris';

-- 3c. Nombre de réservations par client
SELECT 
    c.Id_Client,
    c.Nom_complet,
    COUNT(r.Id_Reservation) AS Nombre_Reservations
FROM Client c
LEFT JOIN Reservation r ON c.Id_Client = r.Id_Client
GROUP BY c.Id_Client, c.Nom_complet
ORDER BY Nombre_Reservations DESC;

-- 3d. Nombre de chambres par type
SELECT 
    tc.Id_Type,
    tc.Type,
    COUNT(c.Id_Chambre) AS Nombre_Chambres
FROM Type_Chambre tc
LEFT JOIN Chambre c ON tc.Id_Type = c.Id_Type
GROUP BY tc.Id_Type, tc.Type;

-- 3e. Chambres disponibles entre deux dates (exemple: 2025-07-01 au 2025-07-31)
SELECT 
    ch.Id_Chambre,
    ch.Numero,
    ch.Etage,
    tc.Type,
    tc.Tarif,
    h.Ville
FROM Chambre ch
JOIN Type_Chambre tc ON ch.Id_Type = tc.Id_Type
JOIN Hotel h ON ch.Id_Hotel = h.Id_Hotel
WHERE ch.Id_Chambre NOT IN (
    SELECT r.Id_Chambre
    FROM Reservation r
    WHERE (r.Date_arrivee <= '2025-07-31' AND r.Date_depart >= '2025-07-01')
)
ORDER BY h.Ville, ch.Numero;