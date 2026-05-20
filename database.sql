-- Tripistry Database Schema & Sample Data
-- COS 221 PA5
-- MariaDB / MySQL

CREATE DATABASE IF NOT EXISTS triptistry;
USE triptistry;

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
    Type ENUM('Full Service', 'Boutique', 'OTA') NOT NULL,
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
    AirlineID INT,
    FOREIGN KEY (AirlineID) REFERENCES airline(AirlineID) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE accommodation (
    AccommodationID INT AUTO_INCREMENT PRIMARY KEY,
    Location VARCHAR(200) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    DestinationID INT,
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
    Price DECIMAL(10,2) DEFAULT 0,
    DestinationID INT,
    FOREIGN KEY (DestinationID) REFERENCES destination(DestinationID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE restaurant (
    RestaurantID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(150) NOT NULL,
    PriceRange VARCHAR(30) DEFAULT NULL,
    DestinationID INT,
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
    Type ENUM('Bundled', 'Individual') NOT NULL DEFAULT 'Bundled',
    Price DECIMAL(10,2) NOT NULL,
    IncludesLodging TINYINT(1) DEFAULT 0,
    IncludesService TINYINT(1) DEFAULT 0,
    IncludesActivities TINYINT(1) DEFAULT 0,
    DurationDays INT DEFAULT 0,
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

CREATE TABLE packages (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    TravelerID INT NOT NULL,
    PackageID INT NOT NULL,
    FOREIGN KEY (TravelerID) REFERENCES traveler(TravelerID) ON DELETE CASCADE,
    FOREIGN KEY (PackageID) REFERENCES travelpackage(PackageID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE booking (
    BookingID INT AUTO_INCREMENT PRIMARY KEY,
    TravellerID INT NOT NULL,
    Status VARCHAR(30) NOT NULL DEFAULT 'Pending',
    BookingDate DATE NOT NULL DEFAULT (CURDATE()),
    FOREIGN KEY (TravellerID) REFERENCES traveler(TravelerID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE review (
    ReviewID INT AUTO_INCREMENT PRIMARY KEY,
    StarRating INT NOT NULL CHECK (StarRating >= 1 AND StarRating <= 5),
    Feedback TEXT DEFAULT NULL,
    DestinationID INT DEFAULT NULL,
    RestaurantID INT DEFAULT NULL,
    AccommodationID INT DEFAULT NULL,
    TravellerID INT NOT NULL,
    DateSubmitted TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (DestinationID) REFERENCES destination(DestinationID) ON DELETE CASCADE,
    FOREIGN KEY (RestaurantID) REFERENCES restaurant(RestaurantID) ON DELETE CASCADE,
    FOREIGN KEY (AccommodationID) REFERENCES accommodation(AccommodationID) ON DELETE CASCADE,
    FOREIGN KEY (TravellerID) REFERENCES traveler(TravelerID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE grouptrip (
    GroupTripID INT AUTO_INCREMENT PRIMARY KEY,
    AgencyID INT NOT NULL,
    MaxSize INT NOT NULL DEFAULT 10,
    StartDate DATE DEFAULT NULL,
    EndDate DATE DEFAULT NULL,
    Itinerary TEXT DEFAULT NULL,
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

-- Package-Flight links
INSERT INTO includes (PackageID, FlightID) VALUES
(1, 1),
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
