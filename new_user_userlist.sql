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
-- Table structure for table `userlist`
--

DROP TABLE IF EXISTS `userlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userlist` (
  `id` int NOT NULL AUTO_INCREMENT,
  `Fname` varchar(50) DEFAULT NULL,
  `Email` varchar(50) DEFAULT NULL,
  `Password` varchar(50) DEFAULT NULL,
  `role` varchar(15) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `pincode` varchar(6) DEFAULT NULL,
  `level` varchar(50) DEFAULT 'Beginner',
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `last_location_update` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Email` (`Email`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userlist`
--

LOCK TABLES `userlist` WRITE;
/*!40000 ALTER TABLE `userlist` DISABLE KEYS */;
INSERT INTO `userlist` VALUES (1,'Atharva Salvi','Salvi360@gmail.com','Salvi360@','Player',NULL,NULL,NULL,'Beginner',19.30146600,72.85085700,'2026-04-08 16:54:11'),(2,'John Doe','john@gmail.com','123456789','Player',NULL,NULL,NULL,'Beginner',NULL,NULL,'2026-04-08 16:54:11'),(7,'Jay Rao','rao@gmail.com','rao12345','Player',NULL,NULL,NULL,'Beginner',NULL,NULL,'2026-04-08 16:54:11'),(8,'Ayan Shetty','shetty@gmail.com','12345678','Player',NULL,NULL,NULL,'Beginner',19.30123655,72.85048855,'2026-04-08 16:54:11'),(9,'Shraddha','salvi78@gmail.com','12345678','Coach',NULL,NULL,NULL,'Beginner',NULL,NULL,'2026-04-08 16:54:11'),(10,'Ayan Sheikh','Sheikh@gmail.com','12345678','Player',NULL,NULL,NULL,'Beginner',NULL,NULL,'2026-04-08 16:54:11'),(11,'Ayan Shaikh','Shaikh@gmail.com','12345678','Player',NULL,NULL,NULL,'Beginner',19.30145000,72.85066400,'2026-04-08 16:54:11'),(12,'Ayaan Shaikh','Shaikh121@gmail.com','12345678','Player',NULL,NULL,NULL,'Beginner',NULL,NULL,'2026-04-08 16:54:11'),(13,'Ayaan Shaikh','Shaikh221@gmail.com','12345678','Player','dipti apt, room 707','Thane','401101','Advanced',19.30141150,72.85063350,'2026-04-08 18:21:47'),(14,'Bob ross','ross@gmail.com','12345678','Player','A-Indraprastha, lokhandwala','Mumbai','400101','Intermediate',19.07600000,72.87770000,'2026-04-08 17:48:38');
/*!40000 ALTER TABLE `userlist` ENABLE KEYS */;
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
