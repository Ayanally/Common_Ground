-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: new_user
-- ------------------------------------------------------
-- Server version	8.0.44

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
-- Table structure for table `eventslist`
--

DROP TABLE IF EXISTS `eventslist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eventslist` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `eventDate` varchar(30) DEFAULT NULL,
  `eventTime` varchar(30) DEFAULT NULL,
  `sports` varchar(30) DEFAULT NULL,
  `level` varchar(30) DEFAULT NULL,
  `description` text,
  `address` varchar(255) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `pincode` varchar(10) DEFAULT NULL,
  `user_name` varchar(30) DEFAULT NULL,
  `user_city` varchar(30) DEFAULT NULL,
  `user_level` varchar(30) DEFAULT NULL,
  `userId` int DEFAULT NULL,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eventslist`
--

LOCK TABLES `eventslist` WRITE;
/*!40000 ALTER TABLE `eventslist` DISABLE KEYS */;
INSERT INTO `eventslist` VALUES (1,'GPL','2026-04-17','16:41','Cricket','Advanced','good','Gokuldham Socity','Mumbai','400011',NULL,NULL,NULL,1,19.076,72.8777),(4,'Gpl3','2026-04-18','02:04','Basketball','Beginner','good','MG Road','Mumbai','400001',NULL,NULL,NULL,1,19.076,72.8777),(5,'GPL league','2026-04-09','04:39','Cricket','Beginner','good sport','Gokuldham society, mg road','Mumbai','400101',NULL,NULL,NULL,1,19.076,72.8777),(6,'Salvi league','2026-04-09','04:56','Football','Intermediate','','Indraprastha','Kandivali','100123','Atharva Salvi',NULL,'Beginner',1,19.2048,72.862),(7,'gpl','2026-04-11','07:19','Cricket','Beginner','good','saw','mumbai','400101','Atharva Salvi',NULL,'Beginner',1,19.076,72.8777),(8,'Indian Premiere Leager','2026-04-09','05:27','Cricket','Advanced','Its about game, its about power','Wankhade, Bandra','Mumbai','400101','Atharva Salvi',NULL,'Beginner',1,19.076,72.8777),(9,'Gpl4','2026-04-18','','Cricket','','good good','MG Road','Mumbai','400001','Ayaan Shaikh','Thane','Beginner',1,19.076,72.8777),(10,'Gpl8','2026-04-18','','Cricket','','hhghhhg','MG Road bhayander','Mumbai','400001','Ayaan Shaikh','Thane','Advanced',1,19.076,72.8777),(13,'Francis Football League','2026-04-17','12:17','Football','Beginner','francis time','St francis ground','mumbai','400011','Ayan Shetty',NULL,'Beginner',8,19.076,72.8777),(14,'Gpl8','2026-04-18','','Football','Beginner','','MG Road bhayander','Bhayander','401101','Atharva Salvi',NULL,'Advanced',1,19.301517408067543,72.85085091615852),(15,'Gpl8','2026-04-30','06:15','Football','Beginner','ffff','MG Road bhayander','Bhayander','401101','Atharva Salvi',NULL,'Advanced',1,19.301466,72.850857),(16,'Gpl8','2026-04-16','00:42','Football','Beginner','good game','MG Road bhayander','Mumbai','400001','Ayaan Shaikh','Thane','Advanced',13,19.30130205810088,72.85072610696436),(17,'Gpl8','2026-05-14','00:44','Badminton','Beginner','goat','MG Road bhayander','Mumbai','400001','Ayan Shaikh',NULL,'Beginner',11,19.301466,72.850857);
/*!40000 ALTER TABLE `eventslist` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-22 21:24:29
