CREATE DATABASE  IF NOT EXISTS `new_user` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `new_user`;
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eventslist`
--

LOCK TABLES `eventslist` WRITE;
/*!40000 ALTER TABLE `eventslist` DISABLE KEYS */;
INSERT INTO `eventslist` VALUES (1,'GPL','2026-04-17','16:41','Cricket','Advanced','good','Gokuldham Socity','Mumbai','400011',NULL,NULL,NULL),(3,'gpl2','2026-04-15','00:00','Badminton','Advanced','with price 1000000',NULL,NULL,NULL,NULL,NULL,NULL),(4,'Gpl3','2026-04-18','02:04','Basketball','Beginner','good','MG Road','Mumbai','400001',NULL,NULL,NULL),(5,'GPL league','2026-04-09','04:39','Cricket','Beginner','good sport','Gokuldham society, mg road','Mumbai','400101',NULL,NULL,NULL),(6,'Salvi league','2026-04-09','04:56','Football','Intermediate','','Indraprastha','Kandivali','100123','Atharva Salvi',NULL,'Beginner'),(7,'gpl','2026-04-11','07:19','Cricket','Beginner','good','saw','mumbai','400101','Atharva Salvi',NULL,'Beginner'),(8,'Indian Premiere Leager','2026-04-09','05:27','Cricket','Advanced','Its about game, its about power','Wankhade, Bandra','Mumbai','400101','Atharva Salvi',NULL,'Beginner');
/*!40000 ALTER TABLE `eventslist` ENABLE KEYS */;
UNLOCK TABLES;

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
  PRIMARY KEY (`id`),
  UNIQUE KEY `Email` (`Email`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userlist`
--

LOCK TABLES `userlist` WRITE;
/*!40000 ALTER TABLE `userlist` DISABLE KEYS */;
INSERT INTO `userlist` VALUES (1,'Atharva Salvi','Salvi360@gmail.com','Salvi360@','Player',NULL,NULL,NULL,'Beginner'),(2,'John Doe','john@gmail.com','123456789','Player',NULL,NULL,NULL,'Beginner'),(7,'Jay Rao','rao@gmail.com','rao12345','Player',NULL,NULL,NULL,'Beginner'),(8,'Ayan Shetty','shetty@gmail.com','12345678','Player',NULL,NULL,NULL,'Beginner'),(9,'Shraddha','salvi78@gmail.com','12345678','Coach',NULL,NULL,NULL,'Beginner'),(10,'Ayan Sheikh','Sheikh@gmail.com','12345678','Player',NULL,NULL,NULL,'Beginner'),(11,'Ayan Shaikh','Shaikh@gmail.com','12345678','Player',NULL,NULL,NULL,'Beginner'),(12,'Ayaan Shaikh','Shaikh121@gmail.com','12345678','Player',NULL,NULL,NULL,'Beginner'),(13,'Ayaan Shaikh','Shaikh221@gmail.com','12345678','Player','dipti apt, room 707','Thane','401101','Beginner'),(14,'Bob ross','ross@gmail.com','12345678','Player','A-Indraprastha, lokhandwala','Mumbai','400101','Beginner');
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

-- Dump completed on 2026-04-05 21:01:34
