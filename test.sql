/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-12.2.2-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: triptistry
-- ------------------------------------------------------
-- Server version	12.2.2-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `accommodation`
--

DROP TABLE IF EXISTS `accommodation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `accommodation` (
  `AccommodationID` int(11) NOT NULL AUTO_INCREMENT,
  `Location` varchar(255) NOT NULL,
  `Price` decimal(10,2) DEFAULT NULL CHECK (`Price` >= 0),
  PRIMARY KEY (`AccommodationID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accommodation`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `accommodation` WRITE;
/*!40000 ALTER TABLE `accommodation` DISABLE KEYS */;
INSERT INTO `accommodation` VALUES
(1,'Downtown London - 5 min from Buckingham Palace',250.00),
(2,'Paris City Center - Near Eiffel Tower',320.00),
(3,'Dubai Marina - Close to Burj Khalifa',450.00),
(4,'Sydney Harbour View - Walking distance to Opera House',380.00),
(5,'Singapore Orchard Road - Central shopping district',210.00);
/*!40000 ALTER TABLE `accommodation` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `agency`
--

DROP TABLE IF EXISTS `agency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `agency` (
  `AgencyID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `Website` varchar(255) DEFAULT NULL,
  `Rating` decimal(2,1) DEFAULT NULL CHECK (`Rating` >= 0 and `Rating` <= 5),
  `Type` enum('Full Service','Boutique','OTA') NOT NULL,
  `CreatedAt` date NOT NULL,
  PRIMARY KEY (`AgencyID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agency`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `agency` WRITE;
/*!40000 ALTER TABLE `agency` DISABLE KEYS */;
INSERT INTO `agency` VALUES
(1,'Wanderlust Travel Co.','www.wanderlust.com',4.8,'Full Service','2024-01-15'),
(2,'Boutique Escapes','www.boutiqueescapes.com',4.9,'Boutique','2024-02-20'),
(3,'TravelGenie','www.travelgenie.com',4.5,'OTA','2024-03-10'),
(4,'Global Concierge','www.globalconcierge.com',4.7,'Full Service','2024-04-05'),
(5,'Luxury Hideaways','www.luxuryhideaways.com',5.0,'Boutique','2024-05-12');
/*!40000 ALTER TABLE `agency` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `airline`
--

DROP TABLE IF EXISTS `airline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `airline` (
  `AirlineID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `Country` varchar(100) NOT NULL,
  PRIMARY KEY (`AirlineID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `airline`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `airline` WRITE;
/*!40000 ALTER TABLE `airline` DISABLE KEYS */;
INSERT INTO `airline` VALUES
(1,'Delta Air Lines','USA'),
(2,'Emirates','UAE'),
(3,'Singapore Airlines','Singapore'),
(4,'British Airways','United Kingdom'),
(5,'Qantas Airways','Australia');
/*!40000 ALTER TABLE `airline` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `apartment`
--

DROP TABLE IF EXISTS `apartment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `apartment` (
  `AccommodationID` int(11) NOT NULL,
  `NumberOfBedrooms` int(11) NOT NULL CHECK (`NumberOfBedrooms` > 0),
  `KitchenType` varchar(50) DEFAULT NULL,
  `FloorNumber` int(11) DEFAULT NULL CHECK (`FloorNumber` >= 0),
  `HasWashingMachine` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`AccommodationID`),
  CONSTRAINT `1` FOREIGN KEY (`AccommodationID`) REFERENCES `accommodation` (`AccommodationID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apartment`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `apartment` WRITE;
/*!40000 ALTER TABLE `apartment` DISABLE KEYS */;
INSERT INTO `apartment` VALUES
(1,2,'Full Kitchen',8,1),
(4,2,'Full Kitchen',5,1);
/*!40000 ALTER TABLE `apartment` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `book_acc`
--

DROP TABLE IF EXISTS `book_acc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_acc` (
  `TravelerID` int(11) NOT NULL,
  `AccommodationID` int(11) NOT NULL,
  PRIMARY KEY (`TravelerID`,`AccommodationID`),
  KEY `AccommodationID` (`AccommodationID`),
  CONSTRAINT `1` FOREIGN KEY (`TravelerID`) REFERENCES `traveler` (`TravelerID`) ON DELETE CASCADE,
  CONSTRAINT `2` FOREIGN KEY (`AccommodationID`) REFERENCES `accommodation` (`AccommodationID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_acc`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `book_acc` WRITE;
/*!40000 ALTER TABLE `book_acc` DISABLE KEYS */;
INSERT INTO `book_acc` VALUES
(1,1),
(2,2),
(4,2),
(3,3),
(5,5);
/*!40000 ALTER TABLE `book_acc` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `booking`
--

DROP TABLE IF EXISTS `booking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking` (
  `TravellerID` int(11) NOT NULL,
  `Status` enum('Pending','Processing','Completed') NOT NULL,
  `BookingDate` datetime NOT NULL DEFAULT current_timestamp(),
  KEY `TravellerID` (`TravellerID`),
  CONSTRAINT `1` FOREIGN KEY (`TravellerID`) REFERENCES `traveler` (`TravelerID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `booking` WRITE;
/*!40000 ALTER TABLE `booking` DISABLE KEYS */;
INSERT INTO `booking` VALUES
(1,'Completed','2026-01-15 10:30:00'),
(2,'Completed','2026-02-20 14:15:00'),
(3,'Processing','2026-03-10 09:45:00'),
(4,'Pending','2026-04-05 16:20:00'),
(5,'Completed','2026-05-12 11:00:00');
/*!40000 ALTER TABLE `booking` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `destination`
--

DROP TABLE IF EXISTS `destination`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `destination` (
  `DestinationID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `Country` varchar(100) NOT NULL,
  `Region` varchar(100) NOT NULL,
  `Description` text DEFAULT NULL,
  PRIMARY KEY (`DestinationID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `destination`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `destination` WRITE;
/*!40000 ALTER TABLE `destination` DISABLE KEYS */;
INSERT INTO `destination` VALUES
(1,'Paris','France','Western Europe','The City of Light, known for the Eiffel Tower, Louvre Museum, and romantic atmosphere'),
(2,'Tokyo','Japan','East Asia','A bustling metropolis blending ultramodern with traditional Japanese culture'),
(3,'New York City','USA','North America','The Big Apple - iconic skyline, Broadway, Times Square, and Central Park'),
(4,'Cape Town','South Africa','Southern Africa','Stunning coastal city with Table Mountain, beautiful beaches, and rich history'),
(5,'Bali','Indonesia','Southeast Asia','Island paradise known for volcanic mountains, rice terraces, beaches, and spiritual retreats');
/*!40000 ALTER TABLE `destination` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `enrolled_in`
--

DROP TABLE IF EXISTS `enrolled_in`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `enrolled_in` (
  `TravelerID` int(11) NOT NULL,
  `GroupTripID` int(11) NOT NULL,
  PRIMARY KEY (`TravelerID`,`GroupTripID`),
  KEY `GroupTripID` (`GroupTripID`),
  CONSTRAINT `1` FOREIGN KEY (`TravelerID`) REFERENCES `traveler` (`TravelerID`) ON DELETE CASCADE,
  CONSTRAINT `2` FOREIGN KEY (`GroupTripID`) REFERENCES `grouptrip` (`GroupTripID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enrolled_in`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `enrolled_in` WRITE;
/*!40000 ALTER TABLE `enrolled_in` DISABLE KEYS */;
INSERT INTO `enrolled_in` VALUES
(1,1),
(4,1),
(2,2),
(3,3),
(5,5);
/*!40000 ALTER TABLE `enrolled_in` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `flight`
--

DROP TABLE IF EXISTS `flight`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `flight` (
  `FlightID` int(11) NOT NULL AUTO_INCREMENT,
  `Origin` varchar(100) NOT NULL,
  `Destination` varchar(100) NOT NULL,
  `DepartureTime` datetime NOT NULL,
  `ArrivalTime` datetime NOT NULL,
  `Fare` decimal(10,2) NOT NULL CHECK (`Fare` >= 0),
  `AirlineID` int(11) DEFAULT NULL,
  PRIMARY KEY (`FlightID`),
  KEY `AirlineID` (`AirlineID`),
  CONSTRAINT `1` FOREIGN KEY (`AirlineID`) REFERENCES `airline` (`AirlineID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `CONSTRAINT_1` CHECK (`ArrivalTime` > `DepartureTime`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flight`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `flight` WRITE;
/*!40000 ALTER TABLE `flight` DISABLE KEYS */;
INSERT INTO `flight` VALUES
(1,'New York (JFK)','London (LHR)','2026-06-15 18:30:00','2026-06-16 06:45:00',850.00,1),
(2,'London (LHR)','Paris (CDG)','2026-06-20 08:00:00','2026-06-20 09:15:00',150.00,4),
(3,'Dubai (DXB)','Tokyo (HND)','2026-07-05 23:55:00','2026-07-06 13:20:00',1200.00,2),
(4,'Los Angeles (LAX)','Sydney (SYD)','2026-07-10 21:30:00','2026-07-12 05:45:00',1650.00,5),
(5,'Singapore (SIN)','Mumbai (BOM)','2026-08-01 10:15:00','2026-08-01 13:30:00',450.00,3);
/*!40000 ALTER TABLE `flight` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `flightbookings`
--

DROP TABLE IF EXISTS `flightbookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `flightbookings` (
  `TravelerID` int(11) NOT NULL,
  `FlightID` int(11) NOT NULL,
  PRIMARY KEY (`TravelerID`,`FlightID`),
  KEY `FlightID` (`FlightID`),
  CONSTRAINT `1` FOREIGN KEY (`TravelerID`) REFERENCES `traveler` (`TravelerID`) ON DELETE CASCADE,
  CONSTRAINT `2` FOREIGN KEY (`FlightID`) REFERENCES `flight` (`FlightID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flightbookings`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `flightbookings` WRITE;
/*!40000 ALTER TABLE `flightbookings` DISABLE KEYS */;
INSERT INTO `flightbookings` VALUES
(1,1),
(4,2),
(2,3),
(3,4),
(5,5);
/*!40000 ALTER TABLE `flightbookings` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `grouptrip`
--

DROP TABLE IF EXISTS `grouptrip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `grouptrip` (
  `GroupTripID` int(11) NOT NULL AUTO_INCREMENT,
  `MaxSize` int(11) NOT NULL CHECK (`MaxSize` > 0),
  `CurrentEnrolment` int(11) DEFAULT 0 CHECK (`CurrentEnrolment` >= 0),
  `Itinerary` text DEFAULT NULL,
  `StartDate` date NOT NULL,
  `EndDate` date NOT NULL,
  `AgencyID` int(11) DEFAULT NULL,
  PRIMARY KEY (`GroupTripID`),
  KEY `AgencyID` (`AgencyID`),
  CONSTRAINT `1` FOREIGN KEY (`AgencyID`) REFERENCES `agency` (`AgencyID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `CONSTRAINT_1` CHECK (`EndDate` >= `StartDate`),
  CONSTRAINT `CONSTRAINT_2` CHECK (`CurrentEnrolment` <= `MaxSize`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grouptrip`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `grouptrip` WRITE;
/*!40000 ALTER TABLE `grouptrip` DISABLE KEYS */;
INSERT INTO `grouptrip` VALUES
(1,20,15,'Day 1: Arrive London, Welcome dinner. Day 2: Buckingham Palace, Westminster Abbey. Day 3: British Museum, Tower of London. Day 4: London Eye, River Thames cruise. Day 5: Free day, Farewell dinner.','2026-06-20','2026-06-25',1),
(2,15,12,'Day 1: Check-in Paris hotel. Day 2: Eiffel Tower, Seine River cruise. Day 3: Louvre Museum, Notre Dame. Day 4: Versailles Palace tour. Day 5: Montmartre, Sacré-Cœur. Day 6: Champagne tasting tour. Day 7: Departure.','2026-07-01','2026-07-08',2),
(3,25,22,'Day 1: Arrive Dubai. Day 2: Burj Khalifa, Dubai Mall. Day 3: Desert safari with BBQ dinner. Day 4: Palm Jumeirah, Atlantis Aquaventure. Day 5: Abu Dhabi Grand Mosque, Ferrari World. Day 6: Free day for shopping. Day 7-10: Optional excursions.','2026-07-15','2026-07-25',3),
(4,12,8,'Day 1: Sydney arrival, Harbour cruise. Day 2: Sydney Opera House tour, The Rocks. Day 3: Blue Mountains day trip. Day 4: Bondi Beach, coastal walk. Day 5: Taronga Zoo. Day 6-14: Great Barrier Reef excursion (optional add-on).','2026-08-05','2026-08-19',5),
(5,30,28,'Day 1: Singapore arrival, Marina Bay Sands light show. Day 2: Gardens by the Bay, Sentosa Island. Day 3: Fly to Kuala Lumpur, Batu Caves. Day 4: Petronas Towers, local markets. Day 5: Fly to Bangkok, Grand Palace. Day 6: Floating markets, Wat Arun. Day 7-8: Free days for shopping and exploration.','2026-09-10','2026-09-18',4);
/*!40000 ALTER TABLE `grouptrip` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `hotel`
--

DROP TABLE IF EXISTS `hotel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hotel` (
  `AccommodationID` int(11) NOT NULL,
  `BedType` enum('Single','Double','Queen','King','Twin','Sofa Bed','Bunk Bed') NOT NULL,
  `BreakfastIncluded` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`AccommodationID`),
  CONSTRAINT `1` FOREIGN KEY (`AccommodationID`) REFERENCES `accommodation` (`AccommodationID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hotel`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `hotel` WRITE;
/*!40000 ALTER TABLE `hotel` DISABLE KEYS */;
INSERT INTO `hotel` VALUES
(2,'Queen',1),
(5,'Queen',1);
/*!40000 ALTER TABLE `hotel` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `includes`
--

DROP TABLE IF EXISTS `includes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `includes` (
  `PackageID` int(11) NOT NULL,
  `FlightID` int(11) NOT NULL,
  PRIMARY KEY (`PackageID`,`FlightID`),
  KEY `FlightID` (`FlightID`),
  CONSTRAINT `1` FOREIGN KEY (`PackageID`) REFERENCES `travelpackage` (`PackageID`) ON DELETE CASCADE,
  CONSTRAINT `2` FOREIGN KEY (`FlightID`) REFERENCES `flight` (`FlightID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `includes`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `includes` WRITE;
/*!40000 ALTER TABLE `includes` DISABLE KEYS */;
INSERT INTO `includes` VALUES
(1,1),
(1,2),
(3,2),
(5,4),
(4,5);
/*!40000 ALTER TABLE `includes` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `interacts_with`
--

DROP TABLE IF EXISTS `interacts_with`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `interacts_with` (
  `TravelerID` int(11) NOT NULL,
  `AgencyID` int(11) NOT NULL,
  PRIMARY KEY (`TravelerID`,`AgencyID`),
  KEY `AgencyID` (`AgencyID`),
  CONSTRAINT `1` FOREIGN KEY (`TravelerID`) REFERENCES `traveler` (`TravelerID`) ON DELETE CASCADE,
  CONSTRAINT `2` FOREIGN KEY (`AgencyID`) REFERENCES `agency` (`AgencyID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interacts_with`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `interacts_with` WRITE;
/*!40000 ALTER TABLE `interacts_with` DISABLE KEYS */;
INSERT INTO `interacts_with` VALUES
(1,1),
(4,1),
(1,2),
(2,2),
(5,3),
(3,5);
/*!40000 ALTER TABLE `interacts_with` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `package_attr`
--

DROP TABLE IF EXISTS `package_attr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `package_attr` (
  `AttractionID` int(11) NOT NULL,
  `PackageID` int(11) NOT NULL,
  PRIMARY KEY (`AttractionID`,`PackageID`),
  KEY `PackageID` (`PackageID`),
  CONSTRAINT `1` FOREIGN KEY (`AttractionID`) REFERENCES `touristattraction` (`AttractionID`) ON DELETE CASCADE,
  CONSTRAINT `2` FOREIGN KEY (`PackageID`) REFERENCES `travelpackage` (`PackageID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `package_attr`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `package_attr` WRITE;
/*!40000 ALTER TABLE `package_attr` DISABLE KEYS */;
INSERT INTO `package_attr` VALUES
(2,1),
(3,1),
(1,3),
(5,4),
(4,5);
/*!40000 ALTER TABLE `package_attr` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `package_destination_accommodation`
--

DROP TABLE IF EXISTS `package_destination_accommodation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `package_destination_accommodation` (
  `PackageID` int(11) NOT NULL,
  `DestinationID` int(11) NOT NULL,
  `AccommodationID` int(11) NOT NULL,
  PRIMARY KEY (`PackageID`,`DestinationID`,`AccommodationID`),
  KEY `DestinationID` (`DestinationID`),
  KEY `AccommodationID` (`AccommodationID`),
  CONSTRAINT `1` FOREIGN KEY (`PackageID`) REFERENCES `travelpackage` (`PackageID`) ON DELETE CASCADE,
  CONSTRAINT `2` FOREIGN KEY (`DestinationID`) REFERENCES `destination` (`DestinationID`) ON DELETE CASCADE,
  CONSTRAINT `3` FOREIGN KEY (`AccommodationID`) REFERENCES `accommodation` (`AccommodationID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `package_destination_accommodation`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `package_destination_accommodation` WRITE;
/*!40000 ALTER TABLE `package_destination_accommodation` DISABLE KEYS */;
INSERT INTO `package_destination_accommodation` VALUES
(3,1,2),
(1,2,2),
(2,3,1),
(5,4,5),
(4,5,5);
/*!40000 ALTER TABLE `package_destination_accommodation` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `package_rest`
--

DROP TABLE IF EXISTS `package_rest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `package_rest` (
  `RestaurantID` int(11) NOT NULL,
  `PackageID` int(11) NOT NULL,
  PRIMARY KEY (`RestaurantID`,`PackageID`),
  KEY `PackageID` (`PackageID`),
  CONSTRAINT `1` FOREIGN KEY (`RestaurantID`) REFERENCES `restaurant` (`RestaurantID`) ON DELETE CASCADE,
  CONSTRAINT `2` FOREIGN KEY (`PackageID`) REFERENCES `travelpackage` (`PackageID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `package_rest`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `package_rest` WRITE;
/*!40000 ALTER TABLE `package_rest` DISABLE KEYS */;
INSERT INTO `package_rest` VALUES
(1,1),
(4,2),
(1,3),
(2,3),
(5,4),
(3,5);
/*!40000 ALTER TABLE `package_rest` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `packages`
--

DROP TABLE IF EXISTS `packages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `packages` (
  `TravelerID` int(11) NOT NULL,
  `PackageID` int(11) NOT NULL,
  PRIMARY KEY (`TravelerID`,`PackageID`),
  KEY `PackageID` (`PackageID`),
  CONSTRAINT `1` FOREIGN KEY (`TravelerID`) REFERENCES `traveler` (`TravelerID`) ON DELETE CASCADE,
  CONSTRAINT `2` FOREIGN KEY (`PackageID`) REFERENCES `travelpackage` (`PackageID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `packages`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `packages` WRITE;
/*!40000 ALTER TABLE `packages` DISABLE KEYS */;
INSERT INTO `packages` VALUES
(1,1),
(1,2),
(4,2),
(2,3),
(5,4),
(3,5);
/*!40000 ALTER TABLE `packages` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `resort`
--

DROP TABLE IF EXISTS `resort`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `resort` (
  `AccommodationID` int(11) NOT NULL,
  `ResortType` varchar(100) NOT NULL,
  `KidsClubAvailable` tinyint(1) DEFAULT 0,
  `PrivateBeachAccess` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`AccommodationID`),
  CONSTRAINT `1` FOREIGN KEY (`AccommodationID`) REFERENCES `accommodation` (`AccommodationID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resort`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `resort` WRITE;
/*!40000 ALTER TABLE `resort` DISABLE KEYS */;
INSERT INTO `resort` VALUES
(3,'Luxury Beach Resort',1,1);
/*!40000 ALTER TABLE `resort` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `restaurant`
--

DROP TABLE IF EXISTS `restaurant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurant` (
  `RestaurantID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `PriceRange` varchar(50) DEFAULT NULL,
  `DestinationID` int(11) DEFAULT NULL,
  PRIMARY KEY (`RestaurantID`),
  KEY `DestinationID` (`DestinationID`),
  CONSTRAINT `1` FOREIGN KEY (`DestinationID`) REFERENCES `destination` (`DestinationID`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurant`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `restaurant` WRITE;
/*!40000 ALTER TABLE `restaurant` DISABLE KEYS */;
INSERT INTO `restaurant` VALUES
(1,'Le Jules Verne','$$$$',1),
(2,'The Ritz Restaurant','$$$$',1),
(3,'Sukiyabashi Jiro','$$$$',2),
(4,'Katz\'s Delicatessen','$$',3),
(5,'Mama San','$$$',5);
/*!40000 ALTER TABLE `restaurant` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `restaurant_cuisinetype`
--

DROP TABLE IF EXISTS `restaurant_cuisinetype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurant_cuisinetype` (
  `RestaurantID` int(11) NOT NULL,
  `CuisineType` varchar(100) NOT NULL,
  PRIMARY KEY (`RestaurantID`,`CuisineType`),
  CONSTRAINT `1` FOREIGN KEY (`RestaurantID`) REFERENCES `restaurant` (`RestaurantID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurant_cuisinetype`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `restaurant_cuisinetype` WRITE;
/*!40000 ALTER TABLE `restaurant_cuisinetype` DISABLE KEYS */;
INSERT INTO `restaurant_cuisinetype` VALUES
(1,'European'),
(1,'French'),
(2,'European'),
(2,'Fine Dining'),
(2,'French'),
(3,'Japanese'),
(3,'Seafood'),
(3,'Sushi'),
(4,'American'),
(4,'Deli'),
(4,'Jewish'),
(5,'Asian'),
(5,'Fusion'),
(5,'Indonesian'),
(5,'Thai');
/*!40000 ALTER TABLE `restaurant_cuisinetype` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `restaurant_location`
--

DROP TABLE IF EXISTS `restaurant_location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurant_location` (
  `RestaurantID` int(11) NOT NULL,
  `Location` varchar(100) NOT NULL,
  PRIMARY KEY (`RestaurantID`,`Location`),
  CONSTRAINT `1` FOREIGN KEY (`RestaurantID`) REFERENCES `restaurant` (`RestaurantID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurant_location`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `restaurant_location` WRITE;
/*!40000 ALTER TABLE `restaurant_location` DISABLE KEYS */;
INSERT INTO `restaurant_location` VALUES
(1,'Champs-Élysées, Paris, France'),
(1,'Eiffel Tower, Paris, France'),
(2,'Knightsbridge, London, UK'),
(2,'Mayfair, London, UK'),
(2,'Piccadilly, London, UK'),
(3,'Ginza, Tokyo, Japan'),
(4,'Brooklyn, New York, USA'),
(4,'Lower East Side, New York, USA'),
(5,'Canggu, Bali, Indonesia'),
(5,'Seminyak, Bali, Indonesia'),
(5,'Ubud, Bali, Indonesia');
/*!40000 ALTER TABLE `restaurant_location` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `review`
--

DROP TABLE IF EXISTS `review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `review` (
  `ReviewID` int(11) NOT NULL AUTO_INCREMENT,
  `StarRating` int(11) NOT NULL CHECK (`StarRating` >= 1 and `StarRating` <= 5),
  `DateSubmitted` date NOT NULL DEFAULT curdate(),
  `Feedback` text DEFAULT NULL,
  `TravelerID` int(11) DEFAULT NULL,
  `RestaurantID` int(11) DEFAULT NULL,
  `DestinationID` int(11) DEFAULT NULL,
  `AccommodationID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ReviewID`),
  KEY `TravelerID` (`TravelerID`),
  KEY `RestaurantID` (`RestaurantID`),
  KEY `DestinationID` (`DestinationID`),
  KEY `AccommodationID` (`AccommodationID`),
  CONSTRAINT `1` FOREIGN KEY (`TravelerID`) REFERENCES `traveler` (`TravelerID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `2` FOREIGN KEY (`RestaurantID`) REFERENCES `restaurant` (`RestaurantID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `3` FOREIGN KEY (`DestinationID`) REFERENCES `destination` (`DestinationID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `4` FOREIGN KEY (`AccommodationID`) REFERENCES `accommodation` (`AccommodationID`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `review` WRITE;
/*!40000 ALTER TABLE `review` DISABLE KEYS */;
INSERT INTO `review` VALUES
(1,5,'2026-01-15','Amazing experience! The Eiffel Tower view from the restaurant was breathtaking. Highly recommend!',1,1,1,NULL),
(2,4,'2026-02-20','Great museum with incredible artifacts. Spent the whole day here and still couldn\'t see everything. Free entry is a bonus!',2,NULL,2,NULL),
(3,5,'2026-03-10','The Dubai Marina resort was absolutely luxurious. Private beach access made the trip unforgettable.',3,NULL,NULL,3),
(4,3,'2026-04-05','Decent hotel but expected more for the price. Location is great though, very central.',4,NULL,NULL,2),
(5,4,'2026-05-12','Katz\'s Deli lived up to the hype! Best pastrami sandwich I\'ve ever had. Will definitely return.',5,4,3,NULL);
/*!40000 ALTER TABLE `review` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `touristattraction`
--

DROP TABLE IF EXISTS `touristattraction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `touristattraction` (
  `AttractionID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `Type` varchar(100) NOT NULL,
  `Location` varchar(255) NOT NULL,
  `Price` decimal(10,2) DEFAULT NULL CHECK (`Price` >= 0),
  PRIMARY KEY (`AttractionID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `touristattraction`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `touristattraction` WRITE;
/*!40000 ALTER TABLE `touristattraction` DISABLE KEYS */;
INSERT INTO `touristattraction` VALUES
(1,'Eiffel Tower','Landmark','Paris, France',25.00),
(2,'British Museum','Museum','London, UK',0.00),
(3,'Burj Khalifa','Skyscraper','Dubai, UAE',35.00),
(4,'Sydney Opera House','Cultural','Sydney, Australia',42.00),
(5,'Marina Bay Sands','Entertainment','Singapore',30.00);
/*!40000 ALTER TABLE `touristattraction` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `traveler`
--

DROP TABLE IF EXISTS `traveler`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `traveler` (
  `TravelerID` int(11) NOT NULL AUTO_INCREMENT,
  `PhoneNumber` varchar(20) NOT NULL,
  `Name` varchar(100) NOT NULL,
  `Lname` varchar(100) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `PassportNumber` varchar(50) NOT NULL,
  `PasswordHash` varchar(255) NOT NULL,
  `DOB` date NOT NULL,
  `CreatedAt` date NOT NULL,
  PRIMARY KEY (`TravelerID`),
  UNIQUE KEY `PhoneNumber` (`PhoneNumber`),
  UNIQUE KEY `Email` (`Email`),
  UNIQUE KEY `PassportNumber` (`PassportNumber`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `traveler`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `traveler` WRITE;
/*!40000 ALTER TABLE `traveler` DISABLE KEYS */;
INSERT INTO `traveler` VALUES
(1,'+14155550101','John','Smith','john.smith@email.com','P12345678','hash_john123','1985-06-15','2024-01-20'),
(2,'+14155550102','Maria','Garcia','maria.garcia@email.com','P87654321','hash_maria456','1992-03-22','2024-02-15'),
(3,'+14155550103','David','Kim','david.kim@email.com','P98765432','hash_david789','1998-11-10','2024-03-10'),
(4,'+14155550104','Sarah','Johnson','sarah.johnson@email.com','P54321987','hash_sarah321','1989-09-03','2024-04-05'),
(5,'+14155550105','Ahmed','Patel','ahmed.patel@email.com','P13579246','hash_ahmed654','1995-07-18','2024-05-12');
/*!40000 ALTER TABLE `traveler` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `travelpackage`
--

DROP TABLE IF EXISTS `travelpackage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `travelpackage` (
  `PackageID` int(11) NOT NULL AUTO_INCREMENT,
  `Type` enum('Bundled','Individual') NOT NULL,
  `Price` decimal(10,2) NOT NULL CHECK (`Price` >= 0),
  `IncludesLodging` tinyint(1) NOT NULL,
  `IncludesService` tinyint(1) NOT NULL,
  `IncludesActivities` tinyint(1) NOT NULL,
  `AgencyID` int(11) DEFAULT NULL,
  PRIMARY KEY (`PackageID`),
  KEY `AgencyID` (`AgencyID`),
  CONSTRAINT `1` FOREIGN KEY (`AgencyID`) REFERENCES `agency` (`AgencyID`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `travelpackage`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `travelpackage` WRITE;
/*!40000 ALTER TABLE `travelpackage` DISABLE KEYS */;
INSERT INTO `travelpackage` VALUES
(1,'Bundled',2500.00,1,1,1,1),
(2,'Individual',850.00,0,1,0,1),
(3,'Bundled',3200.00,1,1,1,2),
(4,'Individual',450.00,0,0,1,3),
(5,'Bundled',5000.00,1,1,1,5);
/*!40000 ALTER TABLE `travelpackage` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-05-18 10:32:55
