-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: checkandfood
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.32-MariaDB

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
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `customer_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone_number` varchar(25) NOT NULL,
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (8,'Jorge','jorge@gmail.com','scrypt:32768:8:1$7pS4MW5uPxzbKmHW$8f9f2b1942057444d99915e54b1623d38b4cf0c6d12e82c76a947e46d0e551e88491e81fa82c31423ce4eb19e55f2edf09cb2201f829bd0fc6903b2af2be1456','500521523');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food`
--

DROP TABLE IF EXISTS `food`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food` (
  `food_id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  PRIMARY KEY (`food_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food`
--

LOCK TABLES `food` WRITE;
/*!40000 ALTER TABLE `food` DISABLE KEYS */;
INSERT INTO `food` VALUES (1,'Mediterranea'),(2,'Española'),(3,'Italiana'),(4,'Japonesa'),(5,'Mexicana'),(6,'Francesa'),(7,'China'),(8,'India'),(9,'Argentina'),(10,'Tailandesa'),(11,'Americana'),(12,'Vegana'),(13,'Coreana'),(14,'Griega'),(15,'Peruana'),(16,'Otras');
/*!40000 ALTER TABLE `food` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reserve`
--

DROP TABLE IF EXISTS `reserve`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reserve` (
  `reserve_id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_id` int(11) NOT NULL,
  `time_slot_id` int(11) NOT NULL,
  `number_of_people` int(4) NOT NULL,
  `reserve_time` date NOT NULL,
  `estatus` enum('pendiente','aceptada','rechazada','cancelada') DEFAULT 'pendiente',
  `restaurant_id` int(11) NOT NULL,
  PRIMARY KEY (`reserve_id`),
  KEY `customer_id` (`customer_id`),
  KEY `time_slot_id` (`time_slot_id`),
  CONSTRAINT `reserve_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `reserve_ibfk_3` FOREIGN KEY (`time_slot_id`) REFERENCES `time_slot` (`time_slot_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reserve`
--

LOCK TABLES `reserve` WRITE;
/*!40000 ALTER TABLE `reserve` DISABLE KEYS */;
INSERT INTO `reserve` VALUES (10,8,24,4,'2025-03-27','rechazada',13),(11,8,27,3,'2025-03-29','cancelada',13),(12,8,28,4,'2025-04-03','rechazada',13),(13,8,26,2,'2025-03-28','rechazada',13),(14,8,33,5,'2025-03-28','pendiente',14);
/*!40000 ALTER TABLE `reserve` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `restaurant`
--

DROP TABLE IF EXISTS `restaurant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurant` (
  `restaurant_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL,
  `password` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `capacity` int(4) NOT NULL,
  `phone_number` varchar(14) NOT NULL,
  `description` tinytext DEFAULT NULL,
  `speciality` tinytext DEFAULT NULL,
  `web` varchar(255) DEFAULT NULL,
  `img_url` varchar(255) DEFAULT NULL,
  `food_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`restaurant_id`),
  UNIQUE KEY `username_UNIQUE` (`email`),
  KEY `food_id` (`food_id`),
  CONSTRAINT `restaurant_ibfk_1` FOREIGN KEY (`food_id`) REFERENCES `food` (`food_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurant`
--

LOCK TABLES `restaurant` WRITE;
/*!40000 ALTER TABLE `restaurant` DISABLE KEYS */;
INSERT INTO `restaurant` VALUES (13,'La Cocina','lacocina@gmail.com','scrypt:32768:8:1$c3BaMzV6ykU7tJEl$995d41251acb3f53509bda02a8918cb1a1e3118a267da48c4a2602c399c51d12588e0fd730881506c26716712f716f8dd2a44d0c120cfdea1c9efc5b4490497f','Calle Mayor 12',40,'600600600','Restaurante mediterráneo con mariscos frescos.','Paella de mariscos','www.lacocina.com	','',1),(14,'La Trattoria','latrattoria@email.com','scrypt:32768:8:1$I0p4O9fFzeD1oCy4$c9e5966c6b94c90c88aaef2fd618ee943106b96ab3eeb9dcf9c4e4455a2153e8d7a62b2f4c3c8c68dff147f060a13223bf374a12f290a20d3157022493de8c06','Calle del Mar, 25, 36201 Vigo, Pontevedra, España',28,'456987123','Comida muy rica','pizza mediterranea','www.latrattoria.com',NULL,1),(15,'Il Napolitano','ilnapolitano@gmail.com','scrypt:32768:8:1$HVd9BJTGNCFFER1r$b4ff6fa09827de213a5299b1eef8b4a38a220c574d6fa6c2207cba15939a6a8478e2c141bde26227f13dabde18c0af566e75155d642ca41359ae63d180dd3f69','C/Mestre Chané Nº12',35,'444444444','sfadsgfdsgfdhhadfhadh h dgadhdfh','spaguetty','www.ilnapolitano.com',NULL,1);
/*!40000 ALTER TABLE `restaurant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `time_slot`
--

DROP TABLE IF EXISTS `time_slot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `time_slot` (
  `time_slot_id` int(11) NOT NULL AUTO_INCREMENT,
  `restaurant_id` int(11) NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `reserve_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`time_slot_id`),
  KEY `restaurant_id` (`restaurant_id`),
  KEY `fk_reserva` (`reserve_id`),
  CONSTRAINT `fk_reserva` FOREIGN KEY (`reserve_id`) REFERENCES `reserve` (`reserve_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `time_slot`
--

LOCK TABLES `time_slot` WRITE;
/*!40000 ALTER TABLE `time_slot` DISABLE KEYS */;
INSERT INTO `time_slot` VALUES (24,13,'12:00:00','13:00:00',NULL),(25,13,'13:00:00','14:00:00',NULL),(26,13,'14:00:00','15:00:00',NULL),(27,13,'20:00:00','21:00:00',NULL),(28,13,'21:00:00','22:00:00',NULL),(29,13,'22:00:00','23:00:00',NULL),(30,14,'12:00:00','13:00:00',NULL),(31,14,'13:00:00','14:00:00',NULL),(32,14,'14:00:00','15:00:00',NULL),(33,14,'15:00:00','16:00:00',NULL),(34,14,'16:00:00','17:00:00',NULL),(35,15,'13:00:00','14:00:00',NULL),(36,15,'14:00:00','15:00:00',NULL),(37,15,'15:00:00','16:00:00',NULL);
/*!40000 ALTER TABLE `time_slot` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-01  1:31:59
