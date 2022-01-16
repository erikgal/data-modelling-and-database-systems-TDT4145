-- MySQL dump 10.13  Distrib 8.0.23, for Win64 (x86_64)
--
-- Host: localhost    Database: db1
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
-- Table structure for table `active`
--

DROP TABLE IF EXISTS `active`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `active` (
  `date` date NOT NULL,
  `userID` varchar(30) NOT NULL,
  `dailyCount` int DEFAULT NULL,
  PRIMARY KEY (`date`,`userID`),
  KEY `act_fk` (`userID`),
  CONSTRAINT `act_fk` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `active`
--

LOCK TABLES `active` WRITE;
/*!40000 ALTER TABLE `active` DISABLE KEYS */;
/*!40000 ALTER TABLE `active` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courseforum`
--

DROP TABLE IF EXISTS `courseforum`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `courseforum` (
  `courseCode` varchar(30) NOT NULL,
  `name` varchar(30) DEFAULT NULL,
  `term` varchar(30) NOT NULL,
  `adminID` varchar(30) NOT NULL,
  PRIMARY KEY (`courseCode`,`term`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courseforum`
--

LOCK TABLES `courseforum` WRITE;
/*!40000 ALTER TABLE `courseforum` DISABLE KEYS */;
/*!40000 ALTER TABLE `courseforum` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `folder`
--

DROP TABLE IF EXISTS `folder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `folder` (
  `folderName` varchar(30) NOT NULL,
  `allowAnonymity` tinyint(1) NOT NULL,
  `courseCode` varchar(30) NOT NULL,
  `term` varchar(30) NOT NULL,
  PRIMARY KEY (`folderName`),
  KEY `fol_FK1` (`courseCode`,`term`),
  CONSTRAINT `fol_FK1` FOREIGN KEY (`courseCode`, `term`) REFERENCES `courseforum` (`courseCode`, `term`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `folder`
--

LOCK TABLES `folder` WRITE;
/*!40000 ALTER TABLE `folder` DISABLE KEYS */;
/*!40000 ALTER TABLE `folder` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reply`
--

DROP TABLE IF EXISTS `reply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reply` (
  `replyID` varchar(30) NOT NULL,
  `text` varchar(500) NOT NULL,
  `name` varchar(30) NOT NULL,
  `likes` int DEFAULT NULL,
  `threadID` varchar(30) NOT NULL,
  `userID` varchar(30) NOT NULL,
  `referencedThreadID` varchar(30) NOT NULL,
  PRIMARY KEY (`replyID`),
  KEY `rep_FK1` (`threadID`),
  KEY `cr_FK2_idx` (`userID`),
  KEY `ref_FK3_idx` (`referencedThreadID`),
  CONSTRAINT `cr_FK2` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ref_FK3` FOREIGN KEY (`referencedThreadID`) REFERENCES `thread` (`threadID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `rep_FK1` FOREIGN KEY (`threadID`) REFERENCES `thread` (`threadID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reply`
--

LOCK TABLES `reply` WRITE;
/*!40000 ALTER TABLE `reply` DISABLE KEYS */;
/*!40000 ALTER TABLE `reply` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `replyliked`
--

DROP TABLE IF EXISTS `replyliked`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `replyliked` (
  `userID` varchar(30) NOT NULL,
  `replyID` varchar(30) NOT NULL,
  PRIMARY KEY (`userID`,`replyID`),
  KEY `rusr_FK2` (`replyID`),
  CONSTRAINT `rusr_FK1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `rusr_FK2` FOREIGN KEY (`replyID`) REFERENCES `reply` (`replyID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `replyliked`
--

LOCK TABLES `replyliked` WRITE;
/*!40000 ALTER TABLE `replyliked` DISABLE KEYS */;
/*!40000 ALTER TABLE `replyliked` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subfolder`
--

DROP TABLE IF EXISTS `subfolder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subfolder` (
  `subfolderName` varchar(30) NOT NULL,
  `allowAnonymity` tinyint(1) NOT NULL,
  `superfolderName` varchar(30) NOT NULL,
  PRIMARY KEY (`subfolderName`),
  KEY `subfol_FK1` (`superfolderName`),
  CONSTRAINT `subfol_FK1` FOREIGN KEY (`superfolderName`) REFERENCES `folder` (`folderName`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subfolder`
--

LOCK TABLES `subfolder` WRITE;
/*!40000 ALTER TABLE `subfolder` DISABLE KEYS */;
/*!40000 ALTER TABLE `subfolder` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `thread`
--

DROP TABLE IF EXISTS `thread`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `thread` (
  `threadID` varchar(30) NOT NULL,
  `name` varchar(30) NOT NULL,
  `title` varchar(300) NOT NULL,
  `description` varchar(500) NOT NULL,
  `tag` varchar(30) DEFAULT NULL,
  `likes` int DEFAULT NULL,
  `colorCode` varchar(30) DEFAULT NULL,
  `folderName` varchar(30) DEFAULT NULL,
  `subfolderName` varchar(30) DEFAULT NULL,
  `userID` varchar(30) NOT NULL,
  PRIMARY KEY (`threadID`),
  KEY `tfol_FK1` (`folderName`),
  KEY `tfol_FK2` (`subfolderName`),
  KEY `tuser_FK3_idx` (`userID`),
  CONSTRAINT `tfol_FK1` FOREIGN KEY (`folderName`) REFERENCES `folder` (`folderName`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tfol_FK2` FOREIGN KEY (`subfolderName`) REFERENCES `subfolder` (`subfolderName`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tuser_FK3` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `thread`
--

LOCK TABLES `thread` WRITE;
/*!40000 ALTER TABLE `thread` DISABLE KEYS */;
/*!40000 ALTER TABLE `thread` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `threadviewedliked`
--

DROP TABLE IF EXISTS `threadviewedliked`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `threadviewedliked` (
  `userID` varchar(30) NOT NULL,
  `threadID` varchar(30) NOT NULL,
  PRIMARY KEY (`userID`,`threadID`),
  KEY `tusr_FK2` (`threadID`),
  CONSTRAINT `tusr_FK1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tusr_FK2` FOREIGN KEY (`threadID`) REFERENCES `thread` (`threadID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `threadviewedliked`
--

LOCK TABLES `threadviewedliked` WRITE;
/*!40000 ALTER TABLE `threadviewedliked` DISABLE KEYS */;
/*!40000 ALTER TABLE `threadviewedliked` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `mail` varchar(30) NOT NULL,
  `password` varchar(30) NOT NULL,
  `userID` varchar(30) NOT NULL,
  `type` varchar(30) NOT NULL,
  `name` varchar(30) NOT NULL,
  PRIMARY KEY (`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('nils.martin@gmail.com','heihei','dfs87d9f867asd98f7','Instructor',''),('erikgaller@hotmail.no','123456','fq98tyq943rcuyn18304r','Student',''),('johannes.reinseth@gmail.no','jojo','sd8f5s6dfg75sd76f','Professor','');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userincourse`
--

DROP TABLE IF EXISTS `userincourse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userincourse` (
  `userID` varchar(30) NOT NULL,
  `courseCode` varchar(30) NOT NULL,
  `term` varchar(30) NOT NULL,
  `permissionType` varchar(30) NOT NULL,
  PRIMARY KEY (`userID`,`courseCode`,`term`),
  KEY `uic_FK2` (`courseCode`,`term`),
  CONSTRAINT `uic_FK1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `uic_FK2` FOREIGN KEY (`courseCode`, `term`) REFERENCES `courseforum` (`courseCode`, `term`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userincourse`
--

LOCK TABLES `userincourse` WRITE;
/*!40000 ALTER TABLE `userincourse` DISABLE KEYS */;
/*!40000 ALTER TABLE `userincourse` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-03-11 18:08:24
