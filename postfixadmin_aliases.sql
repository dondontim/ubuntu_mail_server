-- MySQL dump 10.19  Distrib 10.3.31-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: postfixadmin
-- ------------------------------------------------------
-- Server version	10.3.31-MariaDB-0ubuntu0.20.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `alias`
--

DROP TABLE IF EXISTS `alias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alias` (
  `address` varchar(255) NOT NULL,
  `goto` text NOT NULL,
  `domain` varchar(255) NOT NULL,
  `created` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `modified` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`address`),
  KEY `domain` (`domain`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Virtual Aliases';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alias`
--

LOCK TABLES `alias` WRITE;
/*!40000 ALTER TABLE `alias` DISABLE KEYS */;
INSERT INTO `alias` VALUES ('mailer-daemon@justeuro.eu','postmaster@justeuro.eu','justeuro.eu','2000-01-01 00:00:00','2000-01-01 00:00:00',1),('postmaster@justeuro.eu','root@justeuro.eu','justeuro.eu','2000-01-01 00:00:00','2000-01-01 00:00:00',1),('nobody@justeuro.eu','root@justeuro.eu','justeuro.eu','2000-01-01 00:00:00','2000-01-01 00:00:00',1),('hostmaster@justeuro.eu','root@justeuro.eu','justeuro.eu','2000-01-01 00:00:00','2000-01-01 00:00:00',1),('usenet@justeuro.eu','root@justeuro.eu','justeuro.eu','2000-01-01 00:00:00','2000-01-01 00:00:00',1),('news@justeuro.eu','root@justeuro.eu','justeuro.eu','2000-01-01 00:00:00','2000-01-01 00:00:00',1),('webmaster@justeuro.eu','root@justeuro.eu','justeuro.eu','2000-01-01 00:00:00','2000-01-01 00:00:00',1),('www@justeuro.eu','root@justeuro.eu','justeuro.eu','2000-01-01 00:00:00','2000-01-01 00:00:00',1),('ftp@justeuro.eu','root@justeuro.eu','justeuro.eu','2000-01-01 00:00:00','2000-01-01 00:00:00',1),('abuse@justeuro.eu','root@justeuro.eu','justeuro.eu','2000-01-01 00:00:00','2000-01-01 00:00:00',1),('noc@justeuro.eu','root@justeuro.eu','justeuro.eu','2000-01-01 00:00:00','2000-01-01 00:00:00',1),('security@justeuro.eu','root@justeuro.eu','justeuro.eu','2000-01-01 00:00:00','2000-01-01 00:00:00',1),('clamav@justeuro.eu','root@justeuro.eu','justeuro.eu','2000-01-01 00:00:00','2000-01-01 00:00:00',1),('root@justeuro.eu','admin@justeuro.eu','justeuro.eu','2000-01-01 00:00:00','2000-01-01 00:00:00',1);
/*!40000 ALTER TABLE `alias` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-11-26 17:58:34
