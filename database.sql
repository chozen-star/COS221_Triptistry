-- ==========================================
-- Tripistry Complete Database
-- COS 221 PA5 — Final Submission
-- ==========================================

-- Tripistry Database
-- COS 221 PA5 — Final Submission
-- MariaDB 10.4

CREATE DATABASE IF NOT EXISTS tripistry;
USE tripistry;

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


-- ============================================================
-- TABLES
-- ============================================================

CREATE TABLE traveler (
    TravelerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(150) NOT NULL UNIQUE,
    PhoneNumber VARCHAR(20) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    DateOfBirth DATE,
    PassportNumber VARCHAR(30) NULL,
    CreatedAt DATE NOT NULL DEFAULT (CURDATE())
) ENGINE=InnoDB;

CREATE TABLE agency (
    AgencyID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL UNIQUE,
    Website VARCHAR(200) NOT NULL,
<<<<<<< HEAD
    Type ENUM('Full Service', 'Boutique', 'OTA') NOT NULL,
=======
    Type ENUM('Full Service','Boutique','OTA') NOT NULL,
>>>>>>> develop
    Rating DECIMAL(2,1) DEFAULT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    CreatedAt DATE NOT NULL DEFAULT (CURDATE())
) ENGINE=InnoDB;

CREATE TABLE destination (
    DestinationID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Country VARCHAR(100) NOT NULL,
    Region VARCHAR(100) DEFAULT NULL,
    Description TEXT DEFAULT NULL
) ENGINE=InnoDB;

CREATE TABLE airline (
    AirlineID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Country VARCHAR(100) DEFAULT NULL
) ENGINE=InnoDB;

CREATE TABLE flight (
    FlightID INT AUTO_INCREMENT PRIMARY KEY,
    Origin VARCHAR(100) NOT NULL,
    Destination VARCHAR(100) NOT NULL,
    DepartureTime DATETIME NOT NULL,
    ArrivalTime DATETIME NOT NULL,
    Fare DECIMAL(10,2) NOT NULL,
<<<<<<< HEAD
    AirlineID INT,
=======
    AirlineID INT DEFAULT NULL,
>>>>>>> develop
    FOREIGN KEY (AirlineID) REFERENCES airline(AirlineID) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE accommodation (
    AccommodationID INT AUTO_INCREMENT PRIMARY KEY,
    Location VARCHAR(200) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
<<<<<<< HEAD
    DestinationID INT,
=======
    DestinationID INT DEFAULT NULL,
>>>>>>> develop
    FOREIGN KEY (DestinationID) REFERENCES destination(DestinationID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE hotel (
    HotelID INT AUTO_INCREMENT PRIMARY KEY,
    AccommodationID INT NOT NULL UNIQUE,
    BedType VARCHAR(50) DEFAULT NULL,
    Stars INT DEFAULT NULL,
    FOREIGN KEY (AccommodationID) REFERENCES accommodation(AccommodationID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE resort (
    ResortID INT AUTO_INCREMENT PRIMARY KEY,
    AccommodationID INT NOT NULL UNIQUE,
    ResortType VARCHAR(100) DEFAULT NULL,
    FOREIGN KEY (AccommodationID) REFERENCES accommodation(AccommodationID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE apartment (
    ApartmentID INT AUTO_INCREMENT PRIMARY KEY,
    AccommodationID INT NOT NULL UNIQUE,
    Bedrooms INT DEFAULT NULL,
    FOREIGN KEY (AccommodationID) REFERENCES accommodation(AccommodationID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE touristattraction (
    AttractionID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(150) NOT NULL,
    Type VARCHAR(50) NOT NULL,
    Location VARCHAR(200) DEFAULT NULL,
<<<<<<< HEAD
    Price DECIMAL(10,2) DEFAULT 0,
    DestinationID INT,
=======
    Price DECIMAL(10,2) DEFAULT 0.00,
    DestinationID INT DEFAULT NULL,
>>>>>>> develop
    FOREIGN KEY (DestinationID) REFERENCES destination(DestinationID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE restaurant (
    RestaurantID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(150) NOT NULL,
    PriceRange VARCHAR(30) DEFAULT NULL,
<<<<<<< HEAD
    DestinationID INT,
=======
    DestinationID INT DEFAULT NULL,
>>>>>>> develop
    FOREIGN KEY (DestinationID) REFERENCES destination(DestinationID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE pack_cuisine (
    CuisineID INT AUTO_INCREMENT PRIMARY KEY,
    RestaurantID INT NOT NULL,
    Cuisine VARCHAR(100) NOT NULL,
    FOREIGN KEY (RestaurantID) REFERENCES restaurant(RestaurantID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE rest_location (
    LocationID INT AUTO_INCREMENT PRIMARY KEY,
    RestaurantID INT NOT NULL,
    Location VARCHAR(200) NOT NULL,
    FOREIGN KEY (RestaurantID) REFERENCES restaurant(RestaurantID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE travelpackage (
    PackageID INT AUTO_INCREMENT PRIMARY KEY,
    AgencyID INT NOT NULL,
<<<<<<< HEAD
    Type ENUM('Bundled', 'Individual') NOT NULL DEFAULT 'Bundled',
=======
    Name VARCHAR(200) NOT NULL,
    Type ENUM('Bundled','Individual') NOT NULL DEFAULT 'Bundled',
>>>>>>> develop
    Price DECIMAL(10,2) NOT NULL,
    IncludesLodging TINYINT(1) DEFAULT 0,
    IncludesService TINYINT(1) DEFAULT 0,
    IncludesActivities TINYINT(1) DEFAULT 0,
    DurationDays INT DEFAULT 0,
<<<<<<< HEAD
=======
    Itinerary TEXT DEFAULT NULL,
>>>>>>> develop
    ImageURL VARCHAR(500) DEFAULT NULL,
    FOREIGN KEY (AgencyID) REFERENCES agency(AgencyID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE package_dest (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    PackageID INT NOT NULL,
    DestinationID INT NOT NULL,
    FOREIGN KEY (PackageID) REFERENCES travelpackage(PackageID) ON DELETE CASCADE,
    FOREIGN KEY (DestinationID) REFERENCES destination(DestinationID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE includes (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    PackageID INT NOT NULL,
    FlightID INT NOT NULL,
    FOREIGN KEY (PackageID) REFERENCES travelpackage(PackageID) ON DELETE CASCADE,
    FOREIGN KEY (FlightID) REFERENCES flight(FlightID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE package_attr (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    PackageID INT NOT NULL,
    AttractionID INT NOT NULL,
    FOREIGN KEY (PackageID) REFERENCES travelpackage(PackageID) ON DELETE CASCADE,
    FOREIGN KEY (AttractionID) REFERENCES touristattraction(AttractionID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE package_rest (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    PackageID INT NOT NULL,
    RestaurantID INT NOT NULL,
    FOREIGN KEY (PackageID) REFERENCES travelpackage(PackageID) ON DELETE CASCADE,
    FOREIGN KEY (RestaurantID) REFERENCES restaurant(RestaurantID) ON DELETE CASCADE
) ENGINE=InnoDB;

<<<<<<< HEAD
=======
CREATE TABLE package_accom (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    PackageID INT NOT NULL,
    AccommodationID INT NOT NULL,
    FOREIGN KEY (PackageID) REFERENCES travelpackage(PackageID) ON DELETE CASCADE,
    FOREIGN KEY (AccommodationID) REFERENCES accommodation(AccommodationID) ON DELETE CASCADE
) ENGINE=InnoDB;

>>>>>>> develop
CREATE TABLE packages (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    TravelerID INT NOT NULL,
    PackageID INT NOT NULL,
    FOREIGN KEY (TravelerID) REFERENCES traveler(TravelerID) ON DELETE CASCADE,
    FOREIGN KEY (PackageID) REFERENCES travelpackage(PackageID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE booking (
<<<<<<< HEAD
    BookingID INT AUTO_INCREMENT PRIMARY KEY,
=======
>>>>>>> develop
    TravellerID INT NOT NULL,
    Status VARCHAR(30) NOT NULL DEFAULT 'Pending',
    BookingDate DATE NOT NULL DEFAULT (CURDATE()),
    FOREIGN KEY (TravellerID) REFERENCES traveler(TravelerID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE review (
    ReviewID INT AUTO_INCREMENT PRIMARY KEY,
    StarRating INT NOT NULL CHECK (StarRating >= 1 AND StarRating <= 5),
    Feedback TEXT DEFAULT NULL,
<<<<<<< HEAD
=======
    PackageID INT DEFAULT NULL,
>>>>>>> develop
    DestinationID INT DEFAULT NULL,
    RestaurantID INT DEFAULT NULL,
    AccommodationID INT DEFAULT NULL,
    TravellerID INT NOT NULL,
    DateSubmitted TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
<<<<<<< HEAD
=======
    FOREIGN KEY (PackageID) REFERENCES travelpackage(PackageID) ON DELETE CASCADE,
>>>>>>> develop
    FOREIGN KEY (DestinationID) REFERENCES destination(DestinationID) ON DELETE CASCADE,
    FOREIGN KEY (RestaurantID) REFERENCES restaurant(RestaurantID) ON DELETE CASCADE,
    FOREIGN KEY (AccommodationID) REFERENCES accommodation(AccommodationID) ON DELETE CASCADE,
    FOREIGN KEY (TravellerID) REFERENCES traveler(TravelerID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE grouptrip (
    GroupTripID INT AUTO_INCREMENT PRIMARY KEY,
    AgencyID INT NOT NULL,
<<<<<<< HEAD
    MaxSize INT NOT NULL DEFAULT 10,
    StartDate DATE DEFAULT NULL,
    EndDate DATE DEFAULT NULL,
    Itinerary TEXT DEFAULT NULL,
=======
    Name VARCHAR(200) NOT NULL,
    MaxSize INT NOT NULL DEFAULT 10,
    CurrentEnrolment INT NOT NULL DEFAULT 0,
    Price DECIMAL(10,2) DEFAULT NULL,
    StartDate DATE DEFAULT NULL,
    EndDate DATE DEFAULT NULL,
    Itinerary TEXT DEFAULT NULL,
    ImageURL VARCHAR(500) DEFAULT NULL,
>>>>>>> develop
    CreatedAt DATE NOT NULL DEFAULT (CURDATE()),
    FOREIGN KEY (AgencyID) REFERENCES agency(AgencyID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE group_enrolment (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    GroupTripID INT NOT NULL,
    TravellerID INT NOT NULL,
    FOREIGN KEY (GroupTripID) REFERENCES grouptrip(GroupTripID) ON DELETE CASCADE,
    FOREIGN KEY (TravellerID) REFERENCES traveler(TravelerID) ON DELETE CASCADE
) ENGINE=InnoDB;

<<<<<<< HEAD
-- ============================================================
-- SAMPLE DATA
-- ============================================================

-- Travellers
INSERT INTO traveler (Name, Email, PhoneNumber, PasswordHash, DateOfBirth, PassportNumber) VALUES
('Alice Johnson', 'alice@example.com', '0821110001', '$2y$10$rN2m4X8ZqQkVz0CYXsGLsumO/p6B3M5jz3ErfBS2Z8o9ErfAC7X2u', '1992-03-14', 'P12345678'),
('Bob Smith', 'bob@example.com', '0821110002', '$2y$10$rN2m4X8ZqQkVz0CYXsGLsumO/p6B3M5jz3ErfBS2Z8o9ErfAC7X2u', '1988-07-22', 'P12345679'),
('Carol Williams', 'carol@example.com', '0821110003', '$2y$10$rN2m4X8ZqQkVz0CYXsGLsumO/p6B3M5jz3ErfBS2Z8o9ErfAC7X2u', '1995-11-08', 'P12345680'),
('David Brown', 'david@example.com', '0821110004', '$2y$10$rN2m4X8ZqQkVz0CYXsGLsumO/p6B3M5jz3ErfBS2Z8o9ErfAC7X2u', '1990-01-15', 'P12345681'),
('Eve Martinez', 'eve@example.com', '0821110005', '$2y$10$rN2m4X8ZqQkVz0CYXsGLsumO/p6B3M5jz3ErfBS2Z8o9ErfAC7X2u', '1993-09-30', 'P12345682');

-- Agencies
INSERT INTO agency (Name, Website, Type, Rating, PasswordHash) VALUES
('Wanderlust Travel', 'www.wanderlust.com', 'Boutique', 4.5, '$2y$10$rN2m4X8ZqQkVz0CYXsGLsumO/p6B3M5jz3ErfBS2Z8o9ErfAC7X2u'),
('Global Adventures', 'www.globaladventures.com', 'Full Service', 4.2, '$2y$10$rN2m4X8ZqQkVz0CYXsGLsumO/p6B3M5jz3ErfBS2Z8o9ErfAC7X2u'),
('Budget Roamers', 'www.budgetroamers.com', 'OTA', 4.8, '$2y$10$rN2m4X8ZqQkVz0CYXsGLsumO/p6B3M5jz3ErfBS2Z8o9ErfAC7X2u'),
('Safari Experts', 'www.safariexperts.com', 'Boutique', 4.0, '$2y$10$rN2m4X8ZqQkVz0CYXsGLsumO/p6B3M5jz3ErfBS2Z8o9ErfAC7X2u');
=======
CREATE TABLE login_attempts (
    AttemptID INT AUTO_INCREMENT PRIMARY KEY,
    Identifier VARCHAR(150) NOT NULL,
    AttemptTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Success TINYINT(1) NOT NULL DEFAULT 0,
    INDEX idx_identifier_time (Identifier, AttemptTime)
) ENGINE=InnoDB;

-- ============================================================
-- SAMPLE DATA (no travellers, agencies, packages, or trips)
-- ============================================================
>>>>>>> develop

-- Destinations
INSERT INTO destination (Name, Country, Region, Description) VALUES
('Cape Town', 'South Africa', 'Western Cape', 'The Mother City, famous for Table Mountain, beaches, and the V&A Waterfront.'),
('Kruger National Park', 'South Africa', 'Mpumalanga', 'One of Africa''s largest game reserves with diverse wildlife.'),
('Victoria Falls', 'Zimbabwe', 'Matabeleland', 'One of the Seven Natural Wonders of the World.'),
('Zanzibar', 'Tanzania', 'Zanzibar Archipelago', 'Tropical paradise with white sand beaches and historic Stone Town.'),
('Marrakech', 'Morocco', 'Marrakech-Safi', 'Vibrant city known for markets, gardens, and palaces.'),
('Serengeti', 'Tanzania', 'Arusha', 'Renowned for the annual wildebeest migration.'),
('Mauritius', 'Mauritius', 'Indian Ocean', 'Island nation with beaches, lagoons, and reefs.');

-- Airlines
INSERT INTO airline (Name, Country) VALUES
('South African Airways', 'South Africa'),
('Ethiopian Airlines', 'Ethiopia'),
('Kenya Airways', 'Kenya'),
('FlySafair', 'South Africa'),
('Air Mauritius', 'Mauritius'),
('Royal Air Maroc', 'Morocco'),
('Air Tanzania', 'Tanzania');

-- Flights
INSERT INTO flight (Origin, Destination, DepartureTime, ArrivalTime, Fare, AirlineID) VALUES
('Johannesburg', 'Cape Town', '2026-07-01 08:00:00', '2026-07-01 10:00:00', 2500.00, 1),
('Cape Town', 'Johannesburg', '2026-07-08 18:00:00', '2026-07-08 20:00:00', 2300.00, 4),
('Johannesburg', 'Victoria Falls', '2026-07-02 06:00:00', '2026-07-02 08:30:00', 3800.00, 3),
('Johannesburg', 'Zanzibar', '2026-07-15 09:00:00', '2026-07-15 13:00:00', 5500.00, 2),
('Cape Town', 'Marrakech', '2026-08-01 14:00:00', '2026-08-01 22:00:00', 7200.00, 6),
('Johannesburg', 'Mauritius', '2026-09-10 10:00:00', '2026-09-10 14:30:00', 6200.00, 5),
('Johannesburg', 'Serengeti', '2026-07-20 07:00:00', '2026-07-20 11:00:00', 4800.00, 7),
('Nairobi', 'Cape Town', '2026-07-05 11:00:00', '2026-07-05 16:00:00', 4100.00, 3);

-- Accommodations
INSERT INTO accommodation (Location, Price, DestinationID) VALUES
('V&A Waterfront Hotel', 3500.00, 1),
('Table Bay Suites', 2800.00, 1),
('Kruger Rest Camp', 1800.00, 2),
('Safari Lodge', 4500.00, 2),
('Victoria Falls Hotel', 3200.00, 3),
('Stone Town Inn', 1200.00, 4),
('Beach Resort Zanzibar', 4000.00, 4),
('Riad Marrakech', 2500.00, 5),
('Serengeti Tented Camp', 5000.00, 6),
('Mauritius Beach Villa', 6000.00, 7);

INSERT INTO hotel (AccommodationID, BedType, Stars) VALUES
<<<<<<< HEAD
(1, 'Queen', 5),
(2, 'King', 4),
(3, 'Twin', 3),
(5, 'King', 4);

INSERT INTO resort (AccommodationID, ResortType) VALUES
(4, 'Game Lodge'),
(7, 'Beach Resort'),
(10, 'Beach Villa');

INSERT INTO apartment (AccommodationID, Bedrooms) VALUES
(6, 2),
(8, 1),
(9, 1);
=======
(1, 'Queen', 5), (2, 'King', 4), (3, 'Twin', 3), (5, 'King', 4);

INSERT INTO resort (AccommodationID, ResortType) VALUES
(4, 'Game Lodge'), (7, 'Beach Resort'), (10, 'Beach Villa');

INSERT INTO apartment (AccommodationID, Bedrooms) VALUES
(6, 2), (8, 1), (9, 1);
>>>>>>> develop

-- Tourist Attractions
INSERT INTO touristattraction (Name, Type, Location, Price, DestinationID) VALUES
('Table Mountain Cableway', 'Nature', 'Cape Town', 350.00, 1),
('Robben Island', 'Historical', 'Cape Town', 400.00, 1),
('Kruger Game Drive', 'Safari', 'Kruger National Park', 1200.00, 2),
('Victoria Falls Bridge', 'Adventure', 'Victoria Falls', 600.00, 3),
('Stone Town Walking Tour', 'Cultural', 'Zanzibar', 250.00, 4),
('Jardin Majorelle', 'Garden', 'Marrakech', 150.00, 5),
('Serengeti Safari', 'Safari', 'Serengeti', 1800.00, 6),
('Chamarel Coloured Earth', 'Nature', 'Mauritius', 200.00, 7);

-- Restaurants
INSERT INTO restaurant (Name, PriceRange, DestinationID) VALUES
('Test Kitchen', '$$$$', 1),
('Kloof Street House', '$$$', 1),
('Cattle Baron', '$$', 2),
('The Boma', '$$$', 3),
('Lukmaan Restaurant', '$', 4),
('Nomad', '$$$', 5),
('Lake Duluti Serena', '$$$', 6),
('La Table du Chateau', '$$$$', 7);

INSERT INTO pack_cuisine (RestaurantID, Cuisine) VALUES
<<<<<<< HEAD
(1, 'Fine Dining'), (1, 'Modern'),
(2, 'Contemporary'), (2, 'South African'),
(3, 'Grill'), (3, 'Steakhouse'),
(4, 'African'), (4, 'Traditional'),
(5, 'Swahili'), (5, 'Local'),
(6, 'Moroccan'), (6, 'Mediterranean'),
(7, 'International'), (7, 'Tanzanian'),
(8, 'French'), (8, 'Seafood');

INSERT INTO rest_location (RestaurantID, Location) VALUES
(1, 'Woodstock, Cape Town'),
(2, 'Gardens, Cape Town'),
(3, 'Skukuza, Kruger'),
(4, 'Victoria Falls Town'),
(5, 'Stone Town, Zanzibar'),
(6, 'Medina, Marrakech'),
(7, 'Arusha, Tanzania'),
(8, 'Grand Baie, Mauritius');

-- Travel Packages
INSERT INTO travelpackage (AgencyID, Type, Price, IncludesLodging, IncludesService, IncludesActivities, DurationDays, ImageURL) VALUES
(1, 'Bundled', 15000.00, 1, 1, 1, 7, NULL),
(1, 'Individual', 8500.00, 0, 1, 0, 3, NULL),
(2, 'Bundled', 22000.00, 1, 1, 1, 10, NULL),
(2, 'Bundled', 12000.00, 1, 0, 1, 5, NULL),
(3, 'Bundled', 9500.00, 1, 1, 0, 4, NULL),
(4, 'Bundled', 28000.00, 1, 1, 1, 14, NULL),
(3, 'Individual', 4500.00, 0, 0, 0, 2, NULL),
(4, 'Bundled', 18000.00, 1, 1, 1, 7, NULL);

-- Package-Destination links
INSERT INTO package_dest (PackageID, DestinationID) VALUES
(1, 1), (1, 2),
(2, 4),
(3, 5), (3, 6),
(4, 3),
(5, 1),
(6, 7),
(7, 1),
(8, 2), (8, 3);
=======
(1, 'Fine Dining'), (1, 'Modern'), (2, 'Contemporary'), (2, 'South African'),
(3, 'Grill'), (3, 'Steakhouse'), (4, 'African'), (4, 'Traditional'),
(5, 'Swahili'), (5, 'Local'), (6, 'Moroccan'), (6, 'Mediterranean'),
(7, 'International'), (7, 'Tanzanian'), (8, 'French'), (8, 'Seafood');

INSERT INTO rest_location (RestaurantID, Location) VALUES
(1, 'Woodstock, Cape Town'), (2, 'Gardens, Cape Town'), (3, 'Skukuza, Kruger'),
(4, 'Victoria Falls Town'), (5, 'Stone Town, Zanzibar'), (6, 'Medina, Marrakech'),
(7, 'Arusha, Tanzania'), (8, 'Grand Baie, Mauritius');


-- Agencies
INSERT INTO agency (Name, Website, Type, PasswordHash) VALUES
('Wanderlust Travel', 'www.wanderlust.com', 'Boutique', '$2y$10$FwC9MzSUC634tAQjbrYKqeNZuPpYqXCnD65PxAQP4Pn/0kUBdm8vC'),
('Global Adventures', 'www.globaladventures.com', 'Full Service', '$2y$10$1riB/tILmqPAG7uFka9E9.uEmPak85RG1/zGrLnC9Upbl8YETPHyC'),
('Budget Roamers', 'www.budgetroamers.com', 'OTA', '$2y$10$X2KSSkmCCbDHmBJe3j3RMew4BLi9Ue3wqJ0fWLQtZqHT/9uWfLxBW'),
('Safari Experts', 'www.safariexperts.com', 'Boutique', '$2y$10$r1Epog8eN2IIhB8No2sFyO5NGPp7GIuTMqVmX9piz1.xZJhxjI47y'),
('African Explorers', 'www.africanexplorers.com', 'Full Service', '$2y$10$iptldM00W8iKidd43huwOuGYK0Ok5cz9B4zTaH3Z2evF5T0jJvOGy');

-- Travellers
INSERT INTO traveler (Name, Email, PhoneNumber, PasswordHash, DateOfBirth, PassportNumber) VALUES
('James Carter Leroy', 'james@gmail.com', '0821110001', '$2y$10$tB38OYr02iKumErx3.U5keGO1EPnlWyHRjXSH/3Dao/kHBe/xwuUK', '1998-05-12', 'P98765432'),
('Aisha Patel', 'aisha@gmail.com', '0821110002', '$2y$10$/a1n6QLST6SY510jGGTo9OgrskQs1yKw/1PSe/cne3s7aM7PUdham', '1995-09-23', 'P98765433'),
('Thabo Molefe', 'thabo@gmail.com', '0821110003', '$2y$10$T5yJWA1B9FwSTdEGu2CFieTOaGhd8Y4fGo/p2n68dB/ZQkiFuJHoi', '2000-01-15', 'P98765434'),
('Emma Van Zyl', 'emma@gmail.com', '0821110004', '$2y$10$9aRGLCaU2G1sP.Ird9LBhedKa22Bs50/HnGGQnljiXigR5IbGaZb2', '1997-07-08', 'P98765435'),
('Liam Ndlovu', 'liam@gmail.com', '0821110005', '$2y$10$OzOpgLRJr4O1XZrdlKlx0uJmtSUi.Myvt2oOCz6CfHniLXF84sbSG', '1999-03-30', 'P98765436');

-- Packages (25)
INSERT INTO travelpackage (AgencyID, Name, Type, Price, IncludesLodging, IncludesService, IncludesActivities, DurationDays, Itinerary, ImageURL) VALUES
(1, 'Cape Town & Kruger Safari Experience', 'Bundled', 15000, 1, 1, 1, 7, 'Day 1: Arrive in Cape Town, V&A Waterfront Hotel. Day 2: Table Mountain Cableway. Day 3: Cape Peninsula & Boulders Beach. Day 4: Fly to Kruger, Rest Camp. Day 5: Full-day game drive. Day 6: Bush walk & sunset safari. Day 7: Departure.', 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&h=500&fit=crop'),
(1, 'Zanzibar Island Escape', 'Individual', 8500, 0, 1, 0, 3, 'Day 1: Fly to Zanzibar, Beach Resort. Day 2: Stone Town walking tour. Day 3: Beach day & departure.', 'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=800&h=500&fit=crop'),
(1, 'Durban Coastal Getaway', 'Bundled', 6200, 1, 1, 0, 4, 'Day 1: Arrive Durban, beachfront hotel. Day 2: uShaka Marine World. Day 3: Valley of 1000 Hills. Day 4: Departure.', 'https://images.unsplash.com/photo-1506197603052-3cc9c3a201bd?w=800&h=500&fit=crop'),
(1, 'Garden Route Road Trip', 'Bundled', 11000, 1, 0, 1, 6, 'Day 1: Cape Town to Hermanus. Day 2: Whale watching. Day 3: Knysna & lagoon cruise. Day 4: Tsitsikamma canopy tour. Day 5: Plettenberg Bay beaches. Day 6: Return.', 'https://images.unsplash.com/photo-1530841377377-3ff06c0ca713?w=800&h=500&fit=crop'),
(1, 'African Cultural Immersion', 'Individual', 5500, 0, 1, 1, 3, 'Day 1: Lesedi Cultural Village. Day 2: Soweto tour & Mandela House. Day 3: Traditional cuisine workshop.', 'https://images.unsplash.com/photo-1542051841857-5f90071e7989?w=800&h=500&fit=crop'),
(2, 'Morocco to Tanzania Grand Tour', 'Bundled', 22000, 1, 1, 1, 10, 'Day 1: Fly to Marrakech, Riad. Day 2: Medina & Jardin Majorelle. Day 3: Atlas Mountains. Day 4: Fly to Tanzania. Day 5: Serengeti safari. Day 6: Ngorongoro Crater. Day 7: Lake Manyara. Day 8: Fly to Zanzibar. Day 9: Beach & Stone Town. Day 10: Departure.', 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=800&h=500&fit=crop'),
(2, 'Victoria Falls Adventure', 'Bundled', 12000, 1, 0, 1, 5, 'Day 1: Fly to Victoria Falls, hotel. Day 2: Guided Falls tour. Day 3: Bridge walk & bungee. Day 4: Zambezi cruise. Day 5: Departure.', 'https://images.unsplash.com/photo-1473221326025-9183b464bb7e?w=800&h=500&fit=crop'),
(2, 'Kilimanjaro Summit Expedition', 'Bundled', 28000, 1, 1, 1, 8, 'Day 1: Arrive Moshi. Day 2-3: Machame route ascent. Day 4-5: Alpine desert zone. Day 6: Summit attempt at midnight. Day 7: Descend to Mweka Gate. Day 8: Departure.', 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=800&h=500&fit=crop'),
(2, 'Nile River Explorer', 'Bundled', 16500, 1, 1, 1, 9, 'Day 1: Arrive Cairo, pyramids. Day 2: Egyptian Museum. Day 3: Fly to Aswan. Day 4: Abu Simbel temples. Day 5-7: Nile cruise Luxor. Day 8: Valley of Kings. Day 9: Departure.', 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&h=500&fit=crop'),
(2, 'Madagascar Wildlife Discovery', 'Individual', 13500, 0, 1, 1, 7, 'Day 1: Arrive Antananarivo. Day 2: Andasibe National Park. Day 3: Lemur trek. Day 4: Avenue of Baobabs. Day 5: Tsingy Stone Forest. Day 6: Beach at Nosy Be. Day 7: Departure.', 'https://images.unsplash.com/photo-1555400038-63f5ba517a47?w=800&h=500&fit=crop'),
(3, 'Cape Town City & Wine Discovery', 'Bundled', 9500, 1, 1, 0, 4, 'Day 1: Arrive Cape Town, Table Bay Suites. Day 2: Table Mountain & V&A Waterfront. Day 3: Stellenbosch wine tasting. Day 4: Robben Island & departure.', 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&h=500&fit=crop'),
(3, 'Cape Town Express', 'Individual', 4500, 0, 0, 0, 2, 'Day 1: Arrive Cape Town, Table Mountain. Day 2: Cape Point tour & departure.', 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800&h=500&fit=crop'),
(3, 'Johannesburg City Break', 'Individual', 3200, 0, 1, 0, 3, 'Day 1: Arrive Joburg, Sandton. Day 2: Apartheid Museum & Constitution Hill. Day 3: Maboneng street art tour.', 'https://images.unsplash.com/photo-1582719508461-905c673771fd?w=800&h=500&fit=crop'),
(3, 'Drakensberg Hiking Weekend', 'Bundled', 5100, 1, 0, 1, 3, 'Day 1: Arrive at Amphitheatre. Day 2: Tugela Falls hike. Day 3: Rock art tour & departure.', 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=800&h=500&fit=crop'),
(3, 'Budget Botswana Safari', 'Bundled', 7800, 1, 1, 1, 5, 'Day 1: Arrive Maun, camp. Day 2: Okavango Delta mokoro ride. Day 3: Moremi game drive. Day 4: Chobe River cruise. Day 5: Departure.', 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800&h=500&fit=crop'),
(4, 'Mauritius Paradise Retreat', 'Bundled', 28000, 1, 1, 1, 14, 'Day 1: Arrive Mauritius, Beach Villa. Day 2-3: Water sports. Day 4: Chamarel Earth. Day 5: Ile aux Cerfs. Day 6-7: Catamaran cruise. Day 8: Port Louis. Day 9: Gorges. Day 10: Dolphins. Day 11-13: Free beach days. Day 14: Departure.', 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800&h=500&fit=crop'),
(4, 'Kruger & Falls Ultimate Safari', 'Bundled', 18000, 1, 1, 1, 7, 'Day 1: Fly to Kruger, Safari Lodge. Day 2-3: Game drives. Day 4: Fly to Victoria Falls. Day 5: Falls tour. Day 6: Chobe day trip. Day 7: Departure.', 'https://images.unsplash.com/photo-1596394516093-501ba68a0ba6?w=800&h=500&fit=crop'),
(4, 'Serengeti Migration Spectacle', 'Bundled', 25000, 1, 1, 1, 8, 'Day 1: Arrive Arusha. Day 2-3: Serengeti migration viewing. Day 4: Ngorongoro Crater. Day 5: Lake Manyara. Day 6: Tarangire elephants. Day 7: Fly to Zanzibar. Day 8: Departure.', 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&h=500&fit=crop'),
(4, 'Namib Desert Adventure', 'Bundled', 19500, 1, 1, 1, 9, 'Day 1: Arrive Windhoek. Day 2-3: Sossusvlei dunes. Day 4-5: Swakopmund activities. Day 6: Skeleton Coast flight. Day 7: Etosha National Park. Day 8: Game drives. Day 9: Departure.', 'https://images.unsplash.com/photo-1530789253388-930c80bdc8ce?w=800&h=500&fit=crop'),
(4, 'Okavango Delta Luxury Camp', 'Bundled', 32000, 1, 1, 1, 6, 'Day 1: Fly to Maun. Day 2-4: Delta camp, mokoro rides, walking safaris. Day 5: Scenic flight. Day 6: Departure.', 'https://images.unsplash.com/photo-1468817814611-b7edf94b5d60?w=800&h=500&fit=crop'),
(5, 'Ethiopian Highlands Trek', 'Bundled', 14000, 1, 1, 1, 10, 'Day 1: Arrive Addis Ababa. Day 2-3: Lalibela rock churches. Day 4-6: Simien Mountains trek. Day 7: Gondar castles. Day 8: Lake Tana monasteries. Day 9: Blue Nile Falls. Day 10: Departure.', 'https://images.unsplash.com/photo-1503220317375-aaad61436b1b?w=800&h=500&fit=crop'),
(5, 'Rwanda Gorilla Encounter', 'Bundled', 27000, 1, 1, 1, 5, 'Day 1: Arrive Kigali. Day 2: Genocide memorial. Day 3: Volcanoes National Park, gorilla trek. Day 4: Golden monkey trek. Day 5: Departure.', 'https://images.unsplash.com/photo-1488085061387-422e29b40080?w=800&h=500&fit=crop'),
(5, 'Seychelles Island Hopping', 'Bundled', 22000, 1, 1, 1, 8, 'Day 1: Arrive Mahe. Day 2-3: Praslin & Valle de Mai. Day 4-5: La Digue beaches. Day 6: Curieuse Island. Day 7: Snorkelling. Day 8: Departure.', 'https://images.unsplash.com/photo-1549877452-9c387954fbc2?w=800&h=500&fit=crop'),
(5, 'Zambezi White Water Rafting', 'Individual', 8900, 1, 0, 1, 4, 'Day 1: Arrive Livingstone. Day 2: Full-day rafting. Day 3: Helicopter over Falls. Day 4: Departure.', 'https://images.unsplash.com/photo-1466978913421-dad2ebd01d17?w=800&h=500&fit=crop'),
(5, 'Mozambique Dhow Safari', 'Bundled', 16000, 1, 1, 1, 7, 'Day 1: Arrive Vilanculos. Day 2-4: Bazaruto Archipelago dhow cruise. Day 5: Snorkelling with dugongs. Day 6: Beach day. Day 7: Departure.', 'https://images.unsplash.com/photo-1516483638261-f4dbaf036963?w=800&h=500&fit=crop');

-- Package-Destination links
INSERT INTO package_dest (PackageID, DestinationID) VALUES
(1, 1),
(1, 2),
(2, 4),
(3, 1),
(4, 1),
(4, 5),
(5, 2),
(6, 5),
(6, 6),
(7, 3),
(8, 3),
(9, 3),
(10, 4),
(11, 1),
(12, 1),
(13, 1),
(14, 2),
(15, 2),
(16, 7),
(17, 2),
(17, 3),
(18, 6),
(19, 3),
(20, 2),
(21, 3),
(22, 2),
(23, 7),
(24, 3),
(25, 4);
>>>>>>> develop

-- Package-Flight links
INSERT INTO includes (PackageID, FlightID) VALUES
(1, 1),
<<<<<<< HEAD
(2, 4),
(3, 5),
(4, 3),
(5, 1),
(6, 6),
(7, 1),
(8, 1);

-- Package-Attraction links
INSERT INTO package_attr (PackageID, AttractionID) VALUES
(1, 1), (1, 2),
(2, 5),
(3, 6),
(4, 4),
(5, 1),
(6, 8),
(7, 1),
(8, 3);

-- Package-Restaurant links
INSERT INTO package_rest (PackageID, RestaurantID) VALUES
(1, 1), (1, 2),
(2, 5),
(3, 6),
(4, 4),
(5, 2),
(6, 8),
(7, 2),
(8, 3);

-- Bookings
INSERT INTO packages (TravelerID, PackageID) VALUES
(1, 1),
(2, 3),
(3, 5),
(4, 6),
(5, 8);

INSERT INTO booking (TravellerID, Status, BookingDate) VALUES
(1, 'Confirmed', '2026-05-10'),
(2, 'Pending', '2026-05-12'),
(3, 'Confirmed', '2026-05-14'),
(4, 'Pending', '2026-05-15'),
(5, 'Confirmed', '2026-05-16');

-- Reviews
INSERT INTO review (StarRating, Feedback, DestinationID, RestaurantID, AccommodationID, TravellerID) VALUES
(5, 'Cape Town is absolutely stunning! Table Mountain views are unforgettable.', 1, NULL, NULL, 1),
(4, 'Great food and service at the Test Kitchen.', NULL, 1, NULL, 2),
(3, 'The hotel was nice but a bit overpriced.', NULL, NULL, 1, 3),
(5, 'Best safari experience ever! Highly recommend.', 2, NULL, NULL, 4),
(4, 'Loved the Swahili cuisine and the beach views.', 4, NULL, NULL, 5),
(2, 'Marrakech was too crowded for my taste.', 5, NULL, NULL, 1),
(5, 'Incredible French cuisine with ocean views.', NULL, 8, NULL, 2),
(4, 'Luxurious tented camp, felt like a dream.', NULL, NULL, 9, 4);

-- Group Trips
INSERT INTO grouptrip (AgencyID, MaxSize, StartDate, EndDate, Itinerary) VALUES
(4, 15, '2026-08-01', '2026-08-07', 'Day 1: Arrival in Kruger. Day 2: Morning game drive. Day 3: Bush walk. Day 4: Panorama Route. Day 5: Rest day. Day 6: Night drive. Day 7: Departure.'),
(2, 20, '2026-09-15', '2026-09-25', 'Day 1: Fly to Marrakech. Day 2-3: Explore Medina. Day 4-5: Atlas Mountains trek. Day 6-7: Sahara desert camp. Day 8-9: Coastal Essaouira. Day 10: Return.'),
(1, 10, '2026-07-10', '2026-07-17', 'Day 1: Cape Town arrival. Day 2: Table Mountain. Day 3: Cape Peninsula. Day 4: Wine tasting. Day 5: Robben Island. Day 6: Beach day. Day 7: Departure.'),
(3, 12, '2026-10-01', '2026-10-07', 'Day 1: Arrival in Zanzibar. Day 2: Stone Town tour. Day 3: Spice farm. Day 4-5: Beach days. Day 6: Dolphin tour. Day 7: Departure.');

-- Group Enrolments
INSERT INTO group_enrolment (GroupTripID, TravellerID) VALUES
(1, 1), (1, 2), (1, 3),
(2, 4), (2, 5),
(3, 1), (3, 3), (3, 4),
(4, 2), (4, 5);
=======
(1, 2),
(2, 4),
(3, 1),
(4, 1),
(5, 1),
(6, 5),
(7, 3),
(8, 3),
(9, 3),
(10, 4),
(11, 1),
(12, 1),
(13, 1),
(14, 1),
(15, 1),
(16, 6),
(17, 3),
(17, 1),
(18, 7),
(19, 3),
(20, 1),
(21, 3),
(22, 1),
(23, 6),
(24, 3),
(25, 4);

-- Package-Attraction links
INSERT INTO package_attr (PackageID, AttractionID) VALUES
(1, 1),
(1, 2),
(2, 5),
(3, 1),
(4, 1),
(5, 2),
(6, 6),
(7, 4),
(8, 4),
(9, 4),
(10, 5),
(11, 1),
(12, 1),
(13, 1),
(14, 3),
(15, 3),
(16, 8),
(17, 3),
(17, 4),
(18, 7),
(19, 4),
(20, 3),
(21, 4),
(22, 3),
(23, 8),
(24, 4),
(25, 5);

-- Package-Restaurant links
INSERT INTO package_rest (PackageID, RestaurantID) VALUES
(1, 1),
(1, 2),
(2, 5),
(3, 1),
(4, 2),
(5, 3),
(6, 6),
(7, 4),
(8, 4),
(9, 4),
(10, 5),
(11, 2),
(12, 2),
(13, 1),
(14, 3),
(15, 3),
(16, 8),
(17, 3),
(17, 4),
(18, 7),
(19, 4),
(20, 3),
(21, 4),
(22, 3),
(23, 8),
(24, 4),
(25, 5);

-- Package-Accommodation links
INSERT INTO package_accom (PackageID, AccommodationID) VALUES
(1, 1),
(1, 3),
(2, 7),
(3, 1),
(4, 2),
(5, 3),
(6, 8),
(6, 9),
(7, 5),
(8, 5),
(9, 5),
(10, 7),
(11, 2),
(12, 2),
(13, 1),
(14, 3),
(15, 4),
(16, 10),
(17, 4),
(17, 5),
(18, 9),
(19, 5),
(20, 4),
(21, 5),
(22, 4),
(23, 10),
(24, 5),
(25, 7);

-- Group Trips (15)
INSERT INTO grouptrip (AgencyID, Name, MaxSize, Price, StartDate, EndDate, Itinerary, ImageURL) VALUES
(1, 'Cape Town Explorer Week', 12, 4200, '2026-07-10', '2026-07-17', 'Day 1: Cape Town arrival. Day 2: Table Mountain. Day 3: Cape Peninsula. Day 4: Wine tasting. Day 5: Robben Island. Day 6: Beach day. Day 7: Departure.', 'https://images.unsplash.com/photo-1580060839134-75a5edca2e99?w=800&h=500&fit=crop'),
(1, 'Garden Route Road Trip', 10, 5500, '2026-08-01', '2026-08-07', 'Day 1: Cape Town to Hermanus. Day 2: Whale watching. Day 3: Knysna & lagoon. Day 4: Tsitsikamma treetop canopy. Day 5: Plettenberg Bay. Day 6: Oudtshoorn ostrich farm. Day 7: Return.', 'https://images.unsplash.com/photo-1500534623283-312aade485b7?w=800&h=500&fit=crop'),
(1, 'Kruger Budget Safari', 20, 3200, '2026-09-15', '2026-09-21', 'Day 1: Arrive Kruger, Rest Camp. Day 2: Morning game drive. Day 3: Full-day safari. Day 4: Bush walk. Day 5: Panorama Route. Day 6: Sunset drive. Day 7: Departure.', 'https://images.unsplash.com/photo-1516426122078-c23e76319801?w=800&h=500&fit=crop'),
(2, 'Moroccan Desert Expedition', 15, 8500, '2026-08-10', '2026-08-19', 'Day 1: Fly to Marrakech. Day 2-3: Explore Medina. Day 4-5: Atlas Mountains trek. Day 6-7: Sahara desert camp. Day 8-9: Coastal Essaouira. Day 10: Return.', 'https://images.unsplash.com/photo-1489749798305-4fea3ae63d43?w=800&h=500&fit=crop'),
(2, 'Serengeti Migration Safari', 18, 12000, '2026-07-20', '2026-07-28', 'Day 1: Arrive Arusha. Day 2-4: Serengeti migration. Day 5: Ngorongoro Crater. Day 6: Lake Manyara. Day 7: Tarangire elephants. Day 8: Fly to Zanzibar. Day 9: Departure.', 'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?w=800&h=500&fit=crop'),
(2, 'Victoria Falls Thrill Week', 10, 6800, '2026-10-05', '2026-10-11', 'Day 1: Fly to Vic Falls. Day 2: Guided Falls tour. Day 3: White water rafting. Day 4: Bungee jump. Day 5: Helicopter ride. Day 6: Chobe day trip. Day 7: Departure.', 'https://images.unsplash.com/photo-1590073242678-70ee3fc28e8e?w=800&h=500&fit=crop'),
(3, 'Zanzibar Spice Escape', 14, 2800, '2026-08-20', '2026-08-26', 'Day 1: Arrive Zanzibar. Day 2: Stone Town tour. Day 3: Spice farm visit. Day 4-5: Beach days. Day 6: Dolphin tour. Day 7: Departure.', 'https://images.unsplash.com/photo-1559128010-7c1ad6e1b6a5?w=800&h=500&fit=crop'),
(3, 'Drakensberg Hiking Camp', 16, 1800, '2026-09-05', '2026-09-09', 'Day 1: Arrive Amphitheatre. Day 2: Tugela Falls hike. Day 3: Cathedral Peak. Day 4: Rock art tour. Day 5: Departure.', 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800&h=500&fit=crop'),
(3, 'Botswana Wildlife Budget', 20, 4200, '2026-10-15', '2026-10-21', 'Day 1: Arrive Maun. Day 2: Okavango Delta mokoro. Day 3: Moremi game drive. Day 4: Chobe River cruise. Day 5: Savuti marsh. Day 6: Khama Rhino Sanctuary. Day 7: Departure.', 'https://images.unsplash.com/photo-1523805009345-7448845a9e53?w=800&h=500&fit=crop'),
(4, 'Kruger Big Five Safari Week', 15, 8900, '2026-07-05', '2026-07-11', 'Day 1: Arrive at Safari Lodge. Day 2: Morning drive, afternoon at waterhole. Day 3: Full-day Big Five tracking. Day 4: Bush walk with ranger. Day 5: Panorama Route day trip. Day 6: Night drive & stargazing. Day 7: Departure.', 'https://images.unsplash.com/photo-1534177616072-ef7dc120449d?w=800&h=500&fit=crop'),
(4, 'Okavango Delta Luxury', 8, 22000, '2026-08-15', '2026-08-20', 'Day 1: Fly to Maun, charter to camp. Day 2: Mokoro ride at dawn. Day 3: Walking safari. Day 4: Helicopter scenic flight. Day 5: Sunset cruise. Day 6: Departure.', 'https://images.unsplash.com/photo-1518509562904-e7ef99cdcc86?w=800&h=500&fit=crop'),
(4, 'Rwanda Gorilla Trek', 6, 18000, '2026-09-01', '2026-09-05', 'Day 1: Arrive Kigali. Day 2: Transfer to Volcanoes NP. Day 3: Gorilla trekking. Day 4: Golden monkey trek. Day 5: Departure.', 'https://images.unsplash.com/photo-1557008075-7f2c5efa4cfd?w=800&h=500&fit=crop'),
(5, 'Namib Desert Stars', 12, 9500, '2026-07-25', '2026-07-31', 'Day 1: Arrive Windhoek. Day 2-3: Sossusvlei red dunes. Day 4: Swakopmund adventure. Day 5: Skeleton Coast flight. Day 6: Etosha waterholes. Day 7: Departure.', 'https://images.unsplash.com/photo-1509316785289-025f5b846b35?w=800&h=500&fit=crop'),
(5, 'Ethiopian Highlands Trek', 10, 7800, '2026-09-10', '2026-09-18', 'Day 1: Arrive Addis Ababa. Day 2-3: Lalibela churches. Day 4-6: Simien Mountains trek. Day 7: Gondar castles. Day 8: Lake Tana. Day 9: Departure.', 'https://images.unsplash.com/photo-1528716321680-815a1bafb8c6?w=800&h=500&fit=crop'),
(5, 'Seychelles Island Escape', 10, 12500, '2026-10-10', '2026-10-17', 'Day 1: Arrive Mahe. Day 2-3: Praslin & Valle de Mai. Day 4-5: La Digue beaches. Day 6: Curieuse Island tortoises. Day 7: Snorkelling. Day 8: Departure.', 'https://images.unsplash.com/photo-1590523743276-41e07b2fd2aa?w=800&h=500&fit=crop');

-- Reviews (50)
INSERT INTO review (StarRating, Feedback, PackageID, DestinationID, RestaurantID, AccommodationID, TravellerID) VALUES
(5, 'Absolutely incredible safari experience! Saw the Big Five on day 2.', 1, NULL, NULL, NULL, 1),
(4, 'Zanzibar was magical. The beach resort was stunning.', 2, NULL, NULL, NULL, 2),
(5, 'Perfect coastal getaway. Loved every moment in Durban.', 3, NULL, NULL, NULL, 3),
(4, 'Garden Route is breathtaking. Every stop was picture-perfect.', 4, NULL, NULL, NULL, 1),
(5, 'The cultural immersion was eye-opening. Highly recommend.', 5, NULL, NULL, NULL, 2),
(5, 'Morocco to Tanzania - best decision ever! Two countries, one epic trip.', 6, NULL, NULL, NULL, 3),
(4, 'Victoria Falls left me speechless. The bridge walk was thrilling.', 7, NULL, NULL, NULL, 4),
(5, 'Kilimanjaro summit at sunrise - tears of joy!', 8, NULL, NULL, NULL, 5),
(4, 'The Nile cruise was unforgettable. Luxor temples are majestic.', 9, NULL, NULL, NULL, 1),
(5, 'Madagascar wildlife is like nowhere else on earth.', 10, NULL, NULL, NULL, 2),
(4, 'Cape Town wine tour was divine. Stellenbosch stole my heart.', 11, NULL, NULL, NULL, 3),
(3, 'Quick trip but packed with highlights. Good value.', 12, NULL, NULL, NULL, 4),
(4, 'Joburg surprised me. Maboneng is so vibrant and artsy.', 13, NULL, NULL, NULL, 5),
(5, 'Drakensberg weekend was exactly what I needed. Fresh air and epic views.', 14, NULL, NULL, NULL, 1),
(4, 'Botswana on a budget actually works! The delta is magic.', 15, NULL, NULL, NULL, 2),
(5, 'Two weeks in Mauritius felt like a dream. The villa was paradise.', 16, NULL, NULL, NULL, 3),
(5, 'Kruger AND Victoria Falls in one trip? Yes please!', 17, NULL, NULL, NULL, 4),
(5, 'Witnessing the wildebeest migration was on my bucket list forever.', 18, NULL, NULL, NULL, 5),
(4, 'Namibia is underrated. Those red dunes are from another planet.', 19, NULL, NULL, NULL, 1),
(5, 'Okavango Delta luxury camp was worth every cent. Pure wilderness.', 20, NULL, NULL, NULL, 2),
(4, 'Ethiopian highlands trek challenged me but the views paid off.', 21, NULL, NULL, NULL, 3),
(5, 'Gorilla encounter in Rwanda - life changing. I cried when we found them.', 22, NULL, NULL, NULL, 4),
(5, 'Seychelles island hopping was pure romance. La Digue beaches are unreal.', 23, NULL, NULL, NULL, 5),
(4, 'Zambezi rafting is INTENSE. Best adrenaline rush of my life.', 24, NULL, NULL, NULL, 1),
(5, 'Mozambique dhow safari was the most peaceful week ever.', 25, NULL, NULL, NULL, 2),
(5, 'Cape Town is the most beautiful city I have ever visited. Table Mountain takes your breath away.', NULL, 1, NULL, NULL, 1),
(4, 'Kruger National Park is a wildlife paradise. Saw lions, elephants and leopards.', NULL, 2, NULL, NULL, 2),
(5, 'Victoria Falls is one of the natural wonders for a reason. The mist alone is magical.', NULL, 3, NULL, NULL, 3),
(5, 'Zanzibar beaches are like something from a postcard. Stone Town has such rich history.', NULL, 4, NULL, NULL, 4),
(4, 'Marrakech is sensory overload in the best way. The markets, the food, the colours!', NULL, 5, NULL, NULL, 5),
(5, 'Serengeti is the safari destination. Endless plains and incredible wildlife density.', NULL, 6, NULL, NULL, 1),
(4, 'Mauritius is the perfect island getaway. Beaches, food and friendly locals.', NULL, 7, NULL, NULL, 2),
(5, 'Test Kitchen is world-class. Every dish was a work of art. Worth the hype.', NULL, NULL, 1, NULL, 3),
(4, 'Kloof Street House has amazing ambiance. The courtyard dining is magical.', NULL, NULL, 2, NULL, 4),
(4, 'Cattle Baron steaks are legendary. Best grill in Kruger area hands down.', NULL, NULL, 3, NULL, 5),
(5, 'The Boma dinner and drum show was the highlight of our Vic Falls evening.', NULL, NULL, 4, NULL, 1),
(4, 'Lukmaan is authentic Swahili food at great prices. The biryani is a must.', NULL, NULL, 5, NULL, 2),
(5, 'Nomad in Marrakech serves the best tagine I have ever tasted. Rooftop views too!', NULL, NULL, 6, NULL, 3),
(4, 'Lake Duluti Serena has a beautiful setting. Perfect lunch stop between safaris.', NULL, NULL, 7, NULL, 4),
(5, 'La Table du Chateau is fine dining at its best. The seafood platter was divine.', NULL, NULL, 8, NULL, 5),
(5, 'V&A Waterfront Hotel has the best location in Cape Town. Rooms are luxurious.', NULL, NULL, NULL, 1, 1),
(4, 'Table Bay Suites is elegant and comfortable. Great value for the price.', NULL, NULL, NULL, 2, 2),
(4, 'Kruger Rest Camp is basic but perfect for safari. You hear lions at night!', NULL, NULL, NULL, 3, 3),
(5, 'Safari Lodge is pure luxury in the bush. The private deck overlooking the waterhole is incredible.', NULL, NULL, NULL, 4, 4),
(4, 'Victoria Falls Hotel is grand and historic. Walking distance to the falls.', NULL, NULL, NULL, 5, 5),
(3, 'Stone Town Inn is charming but basic. Great for budget travellers.', NULL, NULL, NULL, 6, 1),
(5, 'Beach Resort Zanzibar is paradise. Infinity pool meets the Indian Ocean.', NULL, NULL, NULL, 7, 2),
(4, 'Riad Marrakech is an oasis in the medina. The courtyard is stunning.', NULL, NULL, NULL, 8, 3),
(4, 'Serengeti Tented Camp feels like old-world safari. Canvas walls, five-star service.', NULL, NULL, NULL, 9, 4),
(5, 'Mauritius Beach Villa is the ultimate luxury escape. Private beach access and butler service.', NULL, NULL, NULL, 10, 5);


>>>>>>> develop
