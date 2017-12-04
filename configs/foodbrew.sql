-- MySQL dump 10.13  Distrib 5.7.13, for Linux (x86_64)
--
-- Host: localhost    Database:
-- ------------------------------------------------------
-- Server version	5.7.13-0ubuntu0.16.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `fft`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `fft` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `fft`;

--
-- Table structure for table `Address`
--

DROP TABLE IF EXISTS `Address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Address` (
  `address_id` int(11) NOT NULL AUTO_INCREMENT,
  `address_line1` varchar(128) NOT NULL,
  `address_line2` varchar(128) DEFAULT NULL,
  `suburb` varchar(30) NOT NULL,
  `postcode` char(4) NOT NULL,
  `state` varchar(3) NOT NULL,
  `pid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`address_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Address`
--

LOCK TABLES `Address` WRITE;
/*!40000 ALTER TABLE `Address` DISABLE KEYS */;
/*!40000 ALTER TABLE `Address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Agreement`
--

DROP TABLE IF EXISTS `Agreement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Agreement` (
  `agreement_id` int(11) NOT NULL AUTO_INCREMENT,
  `supplier_id` int(11) DEFAULT NULL,
  `collector_id` int(11) DEFAULT NULL,
  `request_made` date DEFAULT NULL,
  `agreement_made` date DEFAULT NULL,
  `cancel_made` date DEFAULT NULL,
  `accepted` tinyint(1) DEFAULT '0',
  `cancel` tinyint(1) DEFAULT '0',
  `rate1` float DEFAULT NULL,
  `review1` varchar(2000) DEFAULT NULL,
  `rate2` float DEFAULT NULL,
  `review2` varchar(2000) DEFAULT NULL,
  `description` varchar(2000) DEFAULT NULL,
  PRIMARY KEY (`agreement_id`),
  KEY `supplier_ind` (`supplier_id`),
  KEY `collector_ind` (`collector_id`),
  CONSTRAINT `Agreement_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `Supplier` (`supplier_id`),
  CONSTRAINT `Agreement_ibfk_2` FOREIGN KEY (`collector_id`) REFERENCES `Collector` (`collector_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Agreement`
--

LOCK TABLES `Agreement` WRITE;
/*!40000 ALTER TABLE `Agreement` DISABLE KEYS */;
/*!40000 ALTER TABLE `Agreement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Collector`
--

DROP TABLE IF EXISTS `Collector`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Collector` (
  `collector_id` int(11) NOT NULL,
  `preferred_items` varchar(2000) DEFAULT NULL,
  PRIMARY KEY (`collector_id`),
  KEY `user_ind` (`collector_id`),
  CONSTRAINT `Collector_ibfk_1` FOREIGN KEY (`collector_id`) REFERENCES `User` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Collector`
--

LOCK TABLES `Collector` WRITE;
/*!40000 ALTER TABLE `Collector` DISABLE KEYS */;
INSERT INTO `Collector` VALUES (2,'Food');
/*!40000 ALTER TABLE `Collector` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Supplier`
--

DROP TABLE IF EXISTS `Supplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Supplier` (
  `supplier_id` int(11) NOT NULL,
  `location_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`supplier_id`),
  KEY `address_ind` (`location_id`),
  KEY `user_ind` (`supplier_id`),
  CONSTRAINT `Supplier_ibfk_1` FOREIGN KEY (`location_id`) REFERENCES `Address` (`address_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Supplier_ibfk_2` FOREIGN KEY (`supplier_id`) REFERENCES `User` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Supplier`
--

LOCK TABLES `Supplier` WRITE;
/*!40000 ALTER TABLE `Supplier` DISABLE KEYS */;
INSERT INTO `Supplier` VALUES (1,NULL),(3,NULL);
/*!40000 ALTER TABLE `Supplier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `User` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `photo` varchar(2048) DEFAULT NULL,
  `phone_number` varchar(30) DEFAULT NULL,
  `email` varchar(512) NOT NULL,
  `website` varchar(2048) DEFAULT NULL,
  `description` varchar(2048) DEFAULT NULL,
  `password` varchar(64) NOT NULL,
  `rating` float unsigned zerofill DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
INSERT INTO `User` VALUES (1,'Woolworths','http://www.hdicon.com/wp-content/uploads/2010/07/Woolworths_2008.png','9341 4200','enquiries@woolworths.com.au','woolworths.com.au','Woolworths is a great Australian brand that sells all kinds of food goods. We are passionate about helping the community and are honoured to be a part of this innovative and thoughtful program. Food For Thought is a great initiative.','pass1234',0000000004.2),(2,'Red Cross','http://www.clipartbest.com/cliparts/nTE/R65/nTER65GTA.png','8345 2343','admin@redcross.org.au','redcross.org.au','Red Cross are a local and international charity that provide aid to those in need. Due to the generous donations of non-perfect food goods, we are able to feed those who need it most.','pass1234',0000000004.6),(3,'Baker\'s Delight','http://logos-vector.com/images/logo/xxl/5/2/2/5222/Baker_s_Delight_e47ef_450x450.png','9834 1232','admin@bakersdelight.com.au','bakersdelight.com.au','We are a local bakery that has a passion for helping out the community. Since joining up with Food For Thought our food wastage has dropped by over 73%. We\'re very excited to continue working with Food For Thought.','pass1234',0000000003.7);
/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;
