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
-- Table structure for table `acc_dest`
--

DROP TABLE IF EXISTS `acc_dest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `acc_dest` (
  `DestinationID` int(11) NOT NULL,
  `AccommodationID` int(11) NOT NULL,
  PRIMARY KEY (`DestinationID`,`AccommodationID`),
  KEY `AccommodationID` (`AccommodationID`),
  CONSTRAINT `1` FOREIGN KEY (`DestinationID`) REFERENCES `destination` (`DestinationID`) ON DELETE CASCADE,
  CONSTRAINT `2` FOREIGN KEY (`AccommodationID`) REFERENCES `accommodation` (`AccommodationID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
-- Table structure for table `package_dest`
--

DROP TABLE IF EXISTS `package_dest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `package_dest` (
  `DestinationID` int(11) NOT NULL,
  `PackageID` int(11) NOT NULL,
  PRIMARY KEY (`DestinationID`,`PackageID`),
  KEY `PackageID` (`PackageID`),
  CONSTRAINT `1` FOREIGN KEY (`DestinationID`) REFERENCES `destination` (`DestinationID`) ON DELETE CASCADE,
  CONSTRAINT `2` FOREIGN KEY (`PackageID`) REFERENCES `travelpackage` (`PackageID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-05-12 22:21:38
