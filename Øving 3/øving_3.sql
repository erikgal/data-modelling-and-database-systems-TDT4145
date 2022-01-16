-- MySQL dump 10.13  Distrib 8.0.23, for Win64 (x86_64)
--
-- Host: localhost    Database: oving3
-- ------------------------------------------------------
-- Server version	8.0.23

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `film`
--

DROP TABLE IF EXISTS `film`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `film` (
  `FilmID` int NOT NULL,
  `Tittel` varchar(30) DEFAULT NULL,
  `Produksjonsår` int DEFAULT NULL,
  `RegissørID` int NOT NULL,
  PRIMARY KEY (`FilmID`),
  KEY `Film_FK` (`RegissørID`),
  CONSTRAINT `Film_FK` FOREIGN KEY (`RegissørID`) REFERENCES `regissør` (`RegissørID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `film`
--

LOCK TABLES `film` WRITE;
/*!40000 ALTER TABLE `film` DISABLE KEYS */;
INSERT INTO `film` VALUES (1,'Yes Man',2008,1),(2,'Ace Ventura: When Nature Calls',1995,3),(3,'Ace Ventura: Pet Detective',1994,2),(4,'Bruce Almighty',2003,2),(5,'The Dark Knight',2008,4),(6,'Batman Begins',2005,4),(7,'En eksamenvakts dagbok',2014,5);
/*!40000 ALTER TABLE `film` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `regissør`
--

DROP TABLE IF EXISTS `regissør`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `regissør` (
  `RegissørID` int NOT NULL,
  `Navn` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`RegissørID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `regissør`
--

LOCK TABLES `regissør` WRITE;
/*!40000 ALTER TABLE `regissør` DISABLE KEYS */;
INSERT INTO `regissør` VALUES (1,'Peyton Redd'),(2,'Tom Shadyac'),(3,'Steve Oedekerk'),(4,'Christopher Nolan'),(5,'Gunhild Nordmann');
/*!40000 ALTER TABLE `regissør` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sjanger`
--

DROP TABLE IF EXISTS `sjanger`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sjanger` (
  `SjangerID` int NOT NULL,
  `Navn` varchar(40) DEFAULT NULL,
  `Beskrivelse` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`SjangerID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sjanger`
--

LOCK TABLES `sjanger` WRITE;
/*!40000 ALTER TABLE `sjanger` DISABLE KEYS */;
INSERT INTO `sjanger` VALUES (1,'Komedie','Får deg til å skratte, humre og knegge. Du vil føle deg levende.'),(2,'Romantikk','Varmer hjertet.'),(3,'Eventyr','Det gjelder å oppdage for å oppleve.'),(4,'Krim',NULL),(5,'Fantasi','Hvor går grensene?'),(6,'Drama','Dramatikk.'),(7,'Action','Fyr og flamme.'),(8,'Thriller','Filmer som forårsaker (behagelige) gys og en spennende opplevelse.');
/*!40000 ALTER TABLE `sjanger` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sjangerforfilm`
--

DROP TABLE IF EXISTS `sjangerforfilm`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sjangerforfilm` (
  `SjangerID` int NOT NULL,
  `FilmID` int NOT NULL,
  PRIMARY KEY (`FilmID`,`SjangerID`),
  KEY `sff_FK2` (`SjangerID`),
  CONSTRAINT `sff_FK1` FOREIGN KEY (`FilmID`) REFERENCES `film` (`FilmID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sff_FK2` FOREIGN KEY (`SjangerID`) REFERENCES `sjanger` (`SjangerID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sjangerforfilm`
--

LOCK TABLES `sjangerforfilm` WRITE;
/*!40000 ALTER TABLE `sjangerforfilm` DISABLE KEYS */;
INSERT INTO `sjangerforfilm` VALUES (1,1),(1,2),(1,3),(1,4),(1,7),(2,1),(2,7),(3,2),(3,6),(3,7),(4,2),(4,5),(4,7),(5,4),(5,7),(6,4),(6,5),(6,7),(7,5),(7,6),(7,7),(8,6);
/*!40000 ALTER TABLE `sjangerforfilm` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `skuespiller`
--

DROP TABLE IF EXISTS `skuespiller`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `skuespiller` (
  `SkuespillerID` int NOT NULL,
  `Navn` varchar(40) DEFAULT NULL,
  `Fødselsår` int DEFAULT NULL,
  PRIMARY KEY (`SkuespillerID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `skuespiller`
--

LOCK TABLES `skuespiller` WRITE;
/*!40000 ALTER TABLE `skuespiller` DISABLE KEYS */;
INSERT INTO `skuespiller` VALUES (1,'Jim Carrey',1962),(2,'Zooey Deschanel',1980),(3,'Bradley Cooper',1975),(4,'John Michael Higgins',1963),(5,'Rhys Darby',1974),(6,'Ian McNeice',1950),(7,'Simon Callow',1949),(8,'Maynard Eziashi',1965),(9,'Bob Gunton',1945),(10,'Courtney Cox',1964),(11,'Sean Young',1959),(12,'Tone Loc',1966),(13,'Dan Marino',1961),(14,'Morgan Freeman',1937),(15,'Jennifer Aniston',1969),(16,'Philip Baker Hall',1931),(17,'Catherine Bell',1968),(18,'Christian Bale',1974),(19,'Heath Ledger',1979),(20,'Aaron Eckhart',1968),(21,'Michael Caine',1933),(22,'Liam Neeson',1952),(23,'Katie Holmes',1978),(24,'Gary Oldman',1958),(25,'Gunhild Nordmann',1941),(26,'Gunhild Nordmann',1941);
/*!40000 ALTER TABLE `skuespiller` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `skuespillerifilm`
--

DROP TABLE IF EXISTS `skuespillerifilm`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `skuespillerifilm` (
  `FilmID` int NOT NULL,
  `SkuespillerID` int NOT NULL,
  `Rolle` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`FilmID`,`SkuespillerID`),
  KEY `sif_FK2` (`SkuespillerID`),
  CONSTRAINT `sif_FK1` FOREIGN KEY (`FilmID`) REFERENCES `film` (`FilmID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sif_FK2` FOREIGN KEY (`SkuespillerID`) REFERENCES `skuespiller` (`SkuespillerID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `skuespillerifilm`
--

LOCK TABLES `skuespillerifilm` WRITE;
/*!40000 ALTER TABLE `skuespillerifilm` DISABLE KEYS */;
INSERT INTO `skuespillerifilm` VALUES (1,1,'Carl'),(1,2,'Allison'),(1,3,'Peter'),(1,4,'Nick'),(1,5,'Norman'),(2,1,'Ace Ventura'),(2,6,'Fulton Greenwall'),(2,7,'Vincent Cadby'),(2,8,'Ouda'),(2,9,'Burton Quinn'),(3,1,'Ace Ventura'),(3,10,'Melissa'),(3,11,'Lt. Lois Einhorn'),(3,12,'Emilio'),(3,13,'Dan Marino'),(4,1,'Bruce Nolan'),(4,14,'God'),(4,15,'Grace'),(4,16,'Jack'),(4,17,'Susan'),(5,14,'Lucius Fox'),(5,18,'Bruce Wayne'),(5,19,'Joker'),(5,20,'Harvey Dent'),(5,21,'Alfred'),(5,24,'Gordon'),(6,14,'Lucius Fox'),(6,18,'Bruce Wayne'),(6,21,'Alfred'),(6,22,'Ducard'),(6,23,'Rachel Dawes'),(6,24,'Gordon'),(7,25,'Hovedperson'),(7,26,'Biperson');
/*!40000 ALTER TABLE `skuespillerifilm` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-02-18 17:33:08
