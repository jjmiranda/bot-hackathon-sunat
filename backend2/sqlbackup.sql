-- MySQL dump 10.13  Distrib 5.6.32, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: sunat2
-- ------------------------------------------------------
-- Server version	5.6.32-1+deb.sury.org~xenial+0.1

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
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can add group',2,'add_group'),(5,'Can change group',2,'change_group'),(6,'Can delete group',2,'delete_group'),(7,'Can add permission',3,'add_permission'),(8,'Can change permission',3,'change_permission'),(9,'Can delete permission',3,'delete_permission'),(10,'Can add user',4,'add_user'),(11,'Can change user',4,'change_user'),(12,'Can delete user',4,'delete_user'),(13,'Can add content type',5,'add_contenttype'),(14,'Can change content type',5,'change_contenttype'),(15,'Can delete content type',5,'delete_contenttype'),(16,'Can add session',6,'add_session'),(17,'Can change session',6,'change_session'),(18,'Can delete session',6,'delete_session'),(19,'Can add cc diariocab',7,'add_ccdiariocab'),(20,'Can change cc diariocab',7,'change_ccdiariocab'),(21,'Can delete cc diariocab',7,'delete_ccdiariocab'),(22,'Can add cc diariodet',8,'add_ccdiariodet'),(23,'Can change cc diariodet',8,'change_ccdiariodet'),(24,'Can delete cc diariodet',8,'delete_ccdiariodet'),(25,'Can add Carrito de compras',9,'add_carrito'),(26,'Can change Carrito de compras',9,'change_carrito'),(27,'Can delete Carrito de compras',9,'delete_carrito'),(28,'Can add Categoria producto',10,'add_categoriaproducto'),(29,'Can change Categoria producto',10,'change_categoriaproducto'),(30,'Can delete Categoria producto',10,'delete_categoriaproducto'),(31,'Can add Proveedor asignado',11,'add_proveedorproducto'),(32,'Can change Proveedor asignado',11,'change_proveedorproducto'),(33,'Can delete Proveedor asignado',11,'delete_proveedorproducto'),(34,'Can add Persona',12,'add_personanatural'),(35,'Can change Persona',12,'change_personanatural'),(36,'Can delete Persona',12,'delete_personanatural'),(37,'Can add Detalle de orden de compra',13,'add_lineaorden'),(38,'Can change Detalle de orden de compra',13,'change_lineaorden'),(39,'Can delete Detalle de orden de compra',13,'delete_lineaorden'),(40,'Can add Producto',14,'add_producto'),(41,'Can change Producto',14,'change_producto'),(42,'Can delete Producto',14,'delete_producto'),(43,'Can add Microempresa',15,'add_microempresa'),(44,'Can change Microempresa',15,'change_microempresa'),(45,'Can delete Microempresa',15,'delete_microempresa'),(46,'Can add Proveedor',16,'add_proveedor'),(47,'Can change Proveedor',16,'change_proveedor'),(48,'Can delete Proveedor',16,'delete_proveedor'),(49,'Can add Orden de compra',17,'add_orden'),(50,'Can change Orden de compra',17,'change_orden'),(51,'Can delete Orden de compra',17,'delete_orden'),(52,'Can add factura',18,'add_factura'),(53,'Can change factura',18,'change_factura'),(54,'Can delete factura',18,'delete_factura'),(55,'Can add Detalle de carrito de compras',19,'add_lineacarrito'),(56,'Can change Detalle de carrito de compras',19,'change_lineacarrito'),(57,'Can delete Detalle de carrito de compras',19,'delete_lineacarrito'),(58,'Can add Marca',20,'add_marca'),(59,'Can change Marca',20,'change_marca'),(60,'Can delete Marca',20,'delete_marca');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$36000$VadoB5qCoZVt$jSzuU+99bxiF6KnvlCcj7Ov2GDl8e4MXcirpxmKh32w=','2018-06-28 22:23:48.805805',1,'admin','','','dramos@magiadigital.com',1,1,'2018-06-04 23:14:54.121017'),(2,'pbkdf2_sha256$36000$T6cBhbBkhGvy$sW/0o/TwA+rKxhULeLBfAhmcMXr5c5R/5AelZlj1z6Y=','2018-06-28 21:27:28.273101',1,'10706008391','','','',1,1,'2018-06-04 23:39:51.000000'),(3,'pbkdf2_sha256$36000$B831EQT31F4a$FTljwY8+UfHLvnm/nZtVpYiKGql9zeLN44xwlvBv3G4=','2018-06-28 20:40:09.416908',1,'10706008392','','','',1,1,'2018-06-26 00:49:25.000000'),(4,'pbkdf2_sha256$36000$mHhLnOi9HGCS$lZC9sK5zdAOIEvNeWHsy5Iwzl2jYqT5sfxVtOEJjgO8=','2018-06-28 17:01:03.030877',1,'10706008393','','','',1,1,'2018-06-28 16:08:20.000000'),(5,'pbkdf2_sha256$36000$Tc9283XSCsRH$34xil3p524WRusIB/rL5PEAOrbsgQNQAwIq/sOupJHk=','2018-06-28 22:24:38.219041',1,'07873586','','','',1,1,'2018-06-28 20:12:03.000000'),(6,'pbkdf2_sha256$36000$vX2bpgrYMU0V$p3NtDHDMY/aTdqXyR8Lhlkk2jHirOHj+GG6PqfjhFG8=',NULL,1,'70600839','','','',1,1,'2018-06-28 20:37:30.000000');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
INSERT INTO `auth_user_user_permissions` VALUES (1,2,19),(2,2,20),(3,2,21),(4,2,22),(5,2,23),(6,2,24),(7,2,25),(8,2,26),(9,2,27),(10,2,28),(11,2,29),(12,2,30),(13,2,31),(14,2,32),(15,2,33),(16,2,34),(17,2,35),(18,2,36),(19,2,37),(20,2,38),(21,2,39),(22,2,40),(23,2,41),(24,2,42),(25,2,43),(26,2,44),(27,2,45),(28,2,46),(29,2,47),(30,2,48),(31,2,49),(32,2,50),(33,2,51),(34,2,52),(35,2,53),(36,2,54),(37,2,55),(38,2,56),(39,2,57),(40,2,58),(41,2,59),(42,2,60);
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2018-06-04 23:39:51.813392','2','70600839',1,'[{\"added\": {}}]',4,1),(2,'2018-06-04 23:40:18.110163','1','70600839',1,'[{\"added\": {}}]',12,1),(3,'2018-06-04 23:41:12.667619','2','70600839',2,'[{\"changed\": {\"fields\": [\"is_staff\", \"is_superuser\"]}}]',4,1),(4,'2018-06-04 23:41:50.713927','1','MagiaTech',1,'[{\"added\": {}}]',15,2),(5,'2018-06-04 23:42:20.035273','1','Electronico',1,'[{\"added\": {}}]',10,2),(6,'2018-06-04 23:42:28.693424','1','Samsung',1,'[{\"added\": {}}]',20,2),(7,'2018-06-04 23:43:14.612143','2','Comestibles',1,'[{\"added\": {}}]',10,2),(8,'2018-06-04 23:43:30.709899','2','Marca Adams',1,'[{\"added\": {}}]',20,2),(9,'2018-06-04 23:44:00.023393','1','Chicle A',1,'[{\"added\": {}}]',14,2),(10,'2018-06-04 23:44:14.593213','3','El rey',1,'[{\"added\": {}}]',20,2),(11,'2018-06-04 23:44:32.516675','2','Galleta A',1,'[{\"added\": {}}]',14,2),(12,'2018-06-04 23:45:08.979991','3','Galleta B',1,'[{\"added\": {}}]',14,2),(13,'2018-06-04 23:45:30.238323','4','frutal',1,'[{\"added\": {}}]',20,2),(14,'2018-06-04 23:45:44.293799','4','Frugo A',1,'[{\"added\": {}}]',14,2),(15,'2018-06-04 23:46:13.288131','5','Frugo B',1,'[{\"added\": {}}]',14,2),(16,'2018-06-04 23:47:19.544399','5','Chocotasty',1,'[{\"added\": {}}]',20,2),(17,'2018-06-04 23:47:37.819922','6','Chocolate A',1,'[{\"added\": {}}]',14,2),(18,'2018-06-04 23:48:12.579042','6','Go',1,'[{\"added\": {}}]',20,2),(19,'2018-06-04 23:48:28.074322','7','Chocolate B',1,'[{\"added\": {}}]',14,2),(20,'2018-06-04 23:49:02.273470','2','70600839',2,'[{\"changed\": {\"fields\": [\"user_permissions\", \"last_login\"]}}]',4,1),(21,'2018-06-04 23:52:10.069271','1','1',1,'[{\"added\": {}}]',17,2),(22,'2018-06-04 23:52:47.366315','2','2',1,'[{\"added\": {}}]',17,2),(23,'2018-06-04 23:52:56.754282','2','2',2,'[{\"changed\": {\"fields\": [\"numeroDocreceptor\"]}}]',17,2),(24,'2018-06-04 23:53:25.835590','3','3',1,'[{\"added\": {}}]',17,2),(25,'2018-06-04 23:53:59.804587','4','4',1,'[{\"added\": {}}]',17,2),(26,'2018-06-13 21:30:24.959929','1','MagiaTienda',2,'[{\"changed\": {\"fields\": [\"razonSocial\"]}}]',15,1),(27,'2018-06-13 21:43:07.586370','1','1-1',1,'[{\"added\": {}}]',13,2),(28,'2018-06-13 21:43:33.262272','2','2-2',1,'[{\"added\": {}}]',13,2),(29,'2018-06-13 21:44:35.841832','2','2-2',2,'[{\"changed\": {\"fields\": [\"producto\", \"cantidad\", \"subtotal\"]}}]',13,2),(30,'2018-06-13 21:44:48.582700','2','2-2',2,'[]',13,2),(31,'2018-06-13 21:45:07.146402','3','3-3',1,'[{\"added\": {}}]',13,2),(32,'2018-06-13 21:45:49.025731','4','4-4',1,'[{\"added\": {}}]',13,2),(33,'2018-06-13 21:54:34.227568','2','10706008391',2,'[{\"changed\": {\"fields\": [\"username\"]}}]',4,1),(34,'2018-06-13 21:55:56.264100','4','4',2,'[{\"changed\": {\"fields\": [\"razonSocial\"]}}]',17,2),(35,'2018-06-13 21:55:59.292238','3','3',2,'[{\"changed\": {\"fields\": [\"razonSocial\"]}}]',17,2),(36,'2018-06-13 21:56:02.075164','2','2',2,'[]',17,2),(37,'2018-06-13 21:56:04.371803','1','1',2,'[{\"changed\": {\"fields\": [\"razonSocial\"]}}]',17,2),(38,'2018-06-13 21:56:19.165669','1','1',2,'[{\"changed\": {\"fields\": [\"numeroDocreceptor\"]}}]',17,2),(39,'2018-06-13 21:56:20.796009','2','2',2,'[{\"changed\": {\"fields\": [\"numeroDocreceptor\"]}}]',17,2),(40,'2018-06-13 21:56:22.753923','3','3',2,'[{\"changed\": {\"fields\": [\"numeroDocreceptor\"]}}]',17,2),(41,'2018-06-13 21:56:24.407369','4','4',2,'[{\"changed\": {\"fields\": [\"numeroDocreceptor\"]}}]',17,2),(42,'2018-06-26 00:49:25.678105','3','10706008392',1,'[{\"added\": {}}]',4,2),(43,'2018-06-26 00:49:59.272676','3','10706008392',2,'[{\"changed\": {\"fields\": [\"is_staff\", \"is_superuser\"]}}]',4,2),(44,'2018-06-26 00:50:38.755124','2','70600838',1,'[{\"added\": {}}]',12,3),(45,'2018-06-26 00:51:38.064179','2','MagiaFarma',1,'[{\"added\": {}}]',15,3),(46,'2018-06-26 00:52:00.226790','3','Farmaco',1,'[{\"added\": {}}]',10,3),(47,'2018-06-26 00:52:15.699796','7','magialab',1,'[{\"added\": {}}]',20,3),(48,'2018-06-26 00:52:42.322532','8','Magnesol',1,'[{\"added\": {}}]',14,3),(49,'2018-06-26 00:54:18.134021','5','5',1,'[{\"added\": {}}]',17,3),(50,'2018-06-26 00:57:03.226059','5','5',2,'[{\"changed\": {\"fields\": [\"numeroDocreceptor\", \"razonSocial\"]}}]',17,3),(51,'2018-06-26 22:11:19.414837','7','Chocolate B',2,'[{\"changed\": {\"fields\": [\"codigoBarras\"]}}]',14,2),(52,'2018-06-26 22:11:24.554438','6','Chocolate A',2,'[{\"changed\": {\"fields\": [\"codigoBarras\"]}}]',14,2),(53,'2018-06-26 22:11:29.223107','5','Frugo B',2,'[{\"changed\": {\"fields\": [\"codigoBarras\"]}}]',14,2),(54,'2018-06-26 22:11:33.598550','4','Frugo A',2,'[{\"changed\": {\"fields\": [\"codigoBarras\"]}}]',14,2),(55,'2018-06-26 22:11:38.724177','3','Galleta B',2,'[{\"changed\": {\"fields\": [\"codigoBarras\"]}}]',14,2),(56,'2018-06-26 22:11:51.956449','2','Galleta A',2,'[{\"changed\": {\"fields\": [\"codigoBarras\"]}}]',14,2),(57,'2018-06-26 22:11:56.945386','1','Chicle A',2,'[{\"changed\": {\"fields\": [\"codigoBarras\"]}}]',14,2),(58,'2018-06-28 16:08:20.632176','4','10706008393',1,'[{\"added\": {}}]',4,1),(59,'2018-06-28 16:08:48.161019','4','10706008393',2,'[{\"changed\": {\"fields\": [\"is_staff\", \"is_superuser\"]}}]',4,1),(60,'2018-06-28 16:09:44.506997','3','70600837',1,'[{\"added\": {}}]',12,1),(61,'2018-06-28 16:10:25.816430','3','Inca Kola',1,'[{\"added\": {}}]',15,1),(62,'2018-06-28 16:10:53.643238','8','IncaKola',1,'[{\"added\": {}}]',20,4),(63,'2018-06-28 16:11:22.597152','9','Inca Kola 1.5L',1,'[{\"added\": {}}]',14,4),(64,'2018-06-28 16:11:36.384804','9','Inca Kola 1.5L',2,'[]',14,4),(65,'2018-06-28 16:12:57.674653','10','Inca Kola 1.5L',1,'[{\"added\": {}}]',14,2),(66,'2018-06-28 16:13:45.937117','6','6',1,'[{\"added\": {}}]',17,2),(67,'2018-06-28 16:14:07.780240','6','6',2,'[{\"changed\": {\"fields\": [\"numeroDocreceptor\"]}}]',17,2),(68,'2018-06-28 17:01:11.069308','9','Inca Kola 1.5L',2,'[{\"changed\": {\"fields\": [\"codigoBarras\"]}}]',14,4),(69,'2018-06-28 17:08:43.934743','11','11',2,'[{\"changed\": {\"fields\": [\"tipoDocreceptor\", \"razonSocial\"]}}]',17,2),(70,'2018-06-28 20:12:03.269596','5','07873586',1,'[{\"added\": {}}]',4,1),(71,'2018-06-28 20:12:07.435023','5','07873586',2,'[{\"changed\": {\"fields\": [\"is_staff\", \"is_superuser\"]}}]',4,1),(72,'2018-06-28 20:37:30.326086','6','70600839',1,'[{\"added\": {}}]',4,1),(73,'2018-06-28 20:38:07.572230','6','70600839',2,'[{\"changed\": {\"fields\": [\"is_staff\", \"is_superuser\"]}}]',4,1),(74,'2018-06-28 20:38:41.843708','4','70600839',1,'[{\"added\": {}}]',12,1),(75,'2018-06-28 21:27:39.633324','17','17',3,'',17,2),(76,'2018-06-28 21:27:39.637230','16','16',3,'',17,2),(77,'2018-06-28 21:27:39.639923','15','15',3,'',17,2);
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(2,'auth','group'),(3,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(6,'sessions','session'),(9,'tienda','carrito'),(10,'tienda','categoriaproducto'),(7,'tienda','ccdiariocab'),(8,'tienda','ccdiariodet'),(18,'tienda','factura'),(19,'tienda','lineacarrito'),(13,'tienda','lineaorden'),(20,'tienda','marca'),(15,'tienda','microempresa'),(17,'tienda','orden'),(12,'tienda','personanatural'),(14,'tienda','producto'),(16,'tienda','proveedor'),(11,'tienda','proveedorproducto');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2018-06-04 23:11:53.646480'),(2,'auth','0001_initial','2018-06-04 23:11:55.232765'),(3,'admin','0001_initial','2018-06-04 23:11:55.439681'),(4,'admin','0002_logentry_remove_auto_add','2018-06-04 23:11:55.537523'),(5,'contenttypes','0002_remove_content_type_name','2018-06-04 23:11:55.667430'),(6,'auth','0002_alter_permission_name_max_length','2018-06-04 23:11:55.761336'),(7,'auth','0003_alter_user_email_max_length','2018-06-04 23:11:55.839023'),(8,'auth','0004_alter_user_username_opts','2018-06-04 23:11:55.863007'),(9,'auth','0005_alter_user_last_login_null','2018-06-04 23:11:55.940813'),(10,'auth','0006_require_contenttypes_0002','2018-06-04 23:11:55.952163'),(11,'auth','0007_alter_validators_add_error_messages','2018-06-04 23:11:55.973337'),(12,'auth','0008_alter_user_username_max_length','2018-06-04 23:11:56.061653'),(13,'sessions','0001_initial','2018-06-04 23:11:56.130728'),(14,'tienda','0001_initial','2018-06-04 23:11:58.601798');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('9ohqpwykxeax4cohkac43hiv2st4z5eh','ZTBjZWI1ZjRhZmIzNWNmYjFhOWE0OTllNTg1ZDhiYjhiZGE0NGE3YTp7Il9hdXRoX3VzZXJfaGFzaCI6IjlkZmY3ZjY0NjFmMjI5MjVkYWE2NThjMzk2OTMzZWI2OTBhOTc5NzQiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOiIyIn0=','2018-07-09 23:51:33.816546'),('cswpookh2ixg745kjxaaj0veijvperlz','NTE3MzA5NzJkMTRlMTA5YWI5NTdhZmZiMTFmMWZkMjc3YmJhNDA3Njp7Il9hdXRoX3VzZXJfaGFzaCI6ImYwNjhlY2JjMjliMzI2ZjY3YjEyYTQxZmZiNWIzODA2ZmFjMjE1Y2QiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOiIzIn0=','2018-07-12 20:40:09.422807'),('jqgg4p08z5wq28easazhe3h805oeycsd','NTE3MzA5NzJkMTRlMTA5YWI5NTdhZmZiMTFmMWZkMjc3YmJhNDA3Njp7Il9hdXRoX3VzZXJfaGFzaCI6ImYwNjhlY2JjMjliMzI2ZjY3YjEyYTQxZmZiNWIzODA2ZmFjMjE1Y2QiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOiIzIn0=','2018-07-10 00:50:09.752242'),('l19h0gp5gtmqjhrv4x6tlw0gwt10toz0','OTE0YjFiNTBjNzY1ZmQ3ZWZkZTg2MDBiOWZiNDFjYmNmMWRmMTNiYTp7Il9hdXRoX3VzZXJfaGFzaCI6ImMwODdmY2ExNzVkZTgyOGUxOTM1YTM3NDM2YWE5NzUwZWY2MDE4NTAiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOiIxIn0=','2018-07-12 22:23:48.814276'),('pnej3k264leqih7f7pr4umln7uw1m5h3','ZTBjZWI1ZjRhZmIzNWNmYjFhOWE0OTllNTg1ZDhiYjhiZGE0NGE3YTp7Il9hdXRoX3VzZXJfaGFzaCI6IjlkZmY3ZjY0NjFmMjI5MjVkYWE2NThjMzk2OTMzZWI2OTBhOTc5NzQiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOiIyIn0=','2018-07-12 21:27:28.277391'),('saole3dt016qvt5x7csh1sh5dgxspf8o','ZjA0ODE4ZmQ0ZmRlZjQ0NjNkZWJmZWU1ZmQwODM3Y2I3YWE0M2RhOTp7Il9hdXRoX3VzZXJfaGFzaCI6ImJmNGQ3OTJhNGYwODBhMjgwYjllZGVmNjY3NjhiNmNiNzZkNTdkZGQiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOiI1In0=','2018-07-12 22:24:38.263061'),('vv14iazcjngw8rn4y7wf4ia71scvi6wc','ZTBjZWI1ZjRhZmIzNWNmYjFhOWE0OTllNTg1ZDhiYjhiZGE0NGE3YTp7Il9hdXRoX3VzZXJfaGFzaCI6IjlkZmY3ZjY0NjFmMjI5MjVkYWE2NThjMzk2OTMzZWI2OTBhOTc5NzQiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOiIyIn0=','2018-06-18 23:41:16.319402'),('wwsazttq8lk0h95t09vehpn2qg33yvkb','ZTBjZWI1ZjRhZmIzNWNmYjFhOWE0OTllNTg1ZDhiYjhiZGE0NGE3YTp7Il9hdXRoX3VzZXJfaGFzaCI6IjlkZmY3ZjY0NjFmMjI5MjVkYWE2NThjMzk2OTMzZWI2OTBhOTc5NzQiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOiIyIn0=','2018-06-27 21:37:56.975281'),('xu4im3701pum1dtrcgx3gwwp7etuus0f','OTE0YjFiNTBjNzY1ZmQ3ZWZkZTg2MDBiOWZiNDFjYmNmMWRmMTNiYTp7Il9hdXRoX3VzZXJfaGFzaCI6ImMwODdmY2ExNzVkZTgyOGUxOTM1YTM3NDM2YWE5NzUwZWY2MDE4NTAiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOiIxIn0=','2018-06-18 23:15:14.989484');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tienda_carrito`
--

DROP TABLE IF EXISTS `tienda_carrito`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tienda_carrito` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `estado` varchar(1) NOT NULL,
  `total` decimal(6,2) NOT NULL,
  `totalImpuesto` decimal(6,2) NOT NULL,
  `fechaCreacion` date NOT NULL,
  `fechaActualizacion` date NOT NULL,
  `microempresa_id` int(11) NOT NULL,
  `persona_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tienda_carrito_microempresa_id_8700507a_fk_tienda_mi` (`microempresa_id`),
  KEY `tienda_carrito_persona_id_255f21fe_fk_tienda_personanatural_id` (`persona_id`),
  CONSTRAINT `tienda_carrito_microempresa_id_8700507a_fk_tienda_mi` FOREIGN KEY (`microempresa_id`) REFERENCES `tienda_microempresa` (`id`),
  CONSTRAINT `tienda_carrito_persona_id_255f21fe_fk_tienda_personanatural_id` FOREIGN KEY (`persona_id`) REFERENCES `tienda_personanatural` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tienda_carrito`
--

LOCK TABLES `tienda_carrito` WRITE;
/*!40000 ALTER TABLE `tienda_carrito` DISABLE KEYS */;
/*!40000 ALTER TABLE `tienda_carrito` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tienda_categoriaproducto`
--

DROP TABLE IF EXISTS `tienda_categoriaproducto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tienda_categoriaproducto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) NOT NULL,
  `descripcion` longtext,
  `microempresa_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tienda_categoriaprod_microempresa_id_5c744b78_fk_tienda_mi` (`microempresa_id`),
  CONSTRAINT `tienda_categoriaprod_microempresa_id_5c744b78_fk_tienda_mi` FOREIGN KEY (`microempresa_id`) REFERENCES `tienda_microempresa` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tienda_categoriaproducto`
--

LOCK TABLES `tienda_categoriaproducto` WRITE;
/*!40000 ALTER TABLE `tienda_categoriaproducto` DISABLE KEYS */;
INSERT INTO `tienda_categoriaproducto` VALUES (1,'Electronico','',1),(2,'Comestibles','',1),(3,'Farmaco','',2);
/*!40000 ALTER TABLE `tienda_categoriaproducto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tienda_lineacarrito`
--

DROP TABLE IF EXISTS `tienda_lineacarrito`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tienda_lineacarrito` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cantidad` int(11) NOT NULL,
  `subtotal` decimal(6,2) NOT NULL,
  `montoImpuesto` decimal(6,2) NOT NULL,
  `carrito_id` int(11) NOT NULL,
  `microempresa_id` int(11) NOT NULL,
  `producto_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tienda_lineacarrito_carrito_id_b4d3e501_fk_tienda_carrito_id` (`carrito_id`),
  KEY `tienda_lineacarrito_microempresa_id_f0e6ee3e_fk_tienda_mi` (`microempresa_id`),
  KEY `tienda_lineacarrito_producto_id_bdf131b6_fk_tienda_producto_id` (`producto_id`),
  CONSTRAINT `tienda_lineacarrito_carrito_id_b4d3e501_fk_tienda_carrito_id` FOREIGN KEY (`carrito_id`) REFERENCES `tienda_carrito` (`id`),
  CONSTRAINT `tienda_lineacarrito_microempresa_id_f0e6ee3e_fk_tienda_mi` FOREIGN KEY (`microempresa_id`) REFERENCES `tienda_microempresa` (`id`),
  CONSTRAINT `tienda_lineacarrito_producto_id_bdf131b6_fk_tienda_producto_id` FOREIGN KEY (`producto_id`) REFERENCES `tienda_producto` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tienda_lineacarrito`
--

LOCK TABLES `tienda_lineacarrito` WRITE;
/*!40000 ALTER TABLE `tienda_lineacarrito` DISABLE KEYS */;
/*!40000 ALTER TABLE `tienda_lineacarrito` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tienda_lineaorden`
--

DROP TABLE IF EXISTS `tienda_lineaorden`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tienda_lineaorden` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cantidad` int(11) NOT NULL,
  `subtotal` decimal(6,2) NOT NULL,
  `montoImpuesto` decimal(6,2) NOT NULL,
  `microempresa_id` int(11) NOT NULL,
  `orden_id` int(11) NOT NULL,
  `producto_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tienda_lineaorden_microempresa_id_36bff827_fk_tienda_mi` (`microempresa_id`),
  KEY `tienda_lineaorden_orden_id_bb48541d_fk_tienda_orden_id` (`orden_id`),
  KEY `tienda_lineaorden_producto_id_5d98fcbf_fk_tienda_producto_id` (`producto_id`),
  CONSTRAINT `tienda_lineaorden_microempresa_id_36bff827_fk_tienda_mi` FOREIGN KEY (`microempresa_id`) REFERENCES `tienda_microempresa` (`id`),
  CONSTRAINT `tienda_lineaorden_orden_id_bb48541d_fk_tienda_orden_id` FOREIGN KEY (`orden_id`) REFERENCES `tienda_orden` (`id`),
  CONSTRAINT `tienda_lineaorden_producto_id_5d98fcbf_fk_tienda_producto_id` FOREIGN KEY (`producto_id`) REFERENCES `tienda_producto` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tienda_lineaorden`
--

LOCK TABLES `tienda_lineaorden` WRITE;
/*!40000 ALTER TABLE `tienda_lineaorden` DISABLE KEYS */;
INSERT INTO `tienda_lineaorden` VALUES (1,1,0.88,0.12,1,1,2),(2,5,4.00,4.50,1,2,6),(3,5,4.00,4.50,1,3,6),(4,2,8.80,3.20,1,4,5),(5,1,2.10,0.38,1,11,10),(6,1,2.10,0.38,1,14,10),(7,1,2.10,0.38,1,18,10),(8,5,10.50,1.89,1,19,10);
/*!40000 ALTER TABLE `tienda_lineaorden` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tienda_marca`
--

DROP TABLE IF EXISTS `tienda_marca`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tienda_marca` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) NOT NULL,
  `microempresa_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tienda_marca_microempresa_id_bf591e1b_fk_tienda_microempresa_id` (`microempresa_id`),
  CONSTRAINT `tienda_marca_microempresa_id_bf591e1b_fk_tienda_microempresa_id` FOREIGN KEY (`microempresa_id`) REFERENCES `tienda_microempresa` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tienda_marca`
--

LOCK TABLES `tienda_marca` WRITE;
/*!40000 ALTER TABLE `tienda_marca` DISABLE KEYS */;
INSERT INTO `tienda_marca` VALUES (1,'Samsung',1),(2,'Marca Adams',1),(3,'El rey',1),(4,'frutal',1),(5,'Chocotasty',1),(6,'Go',1),(7,'magialab',2),(8,'IncaKola',3);
/*!40000 ALTER TABLE `tienda_marca` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tienda_microempresa`
--

DROP TABLE IF EXISTS `tienda_microempresa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tienda_microempresa` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `razonSocial` varchar(250) NOT NULL,
  `ruc` varchar(15) NOT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `direccion` varchar(250) DEFAULT NULL,
  `correo` varchar(100) NOT NULL,
  `fechaCreacion` date NOT NULL,
  `fechaActualizacion` date NOT NULL,
  `persona_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tienda_microempresa_persona_id_24ab1b97_fk_tienda_pe` (`persona_id`),
  CONSTRAINT `tienda_microempresa_persona_id_24ab1b97_fk_tienda_pe` FOREIGN KEY (`persona_id`) REFERENCES `tienda_personanatural` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tienda_microempresa`
--

LOCK TABLES `tienda_microempresa` WRITE;
/*!40000 ALTER TABLE `tienda_microempresa` DISABLE KEYS */;
INSERT INTO `tienda_microempresa` VALUES (1,'MagiaTienda','10706008391',NULL,NULL,'dramos@magiadigital.com','2018-06-04','2018-06-04',1),(2,'MagiaFarma','10706008392',NULL,NULL,'dramos@magiadigital.com','2018-06-26','2018-06-26',2),(3,'Inca Kola','10706008393',NULL,NULL,'online@incakola.com','2018-06-28','2018-06-28',3);
/*!40000 ALTER TABLE `tienda_microempresa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tienda_orden`
--

DROP TABLE IF EXISTS `tienda_orden`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tienda_orden` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `estado` varchar(1) NOT NULL,
  `tipo` varchar(1) NOT NULL,
  `total` decimal(6,2) NOT NULL,
  `totalImpuesto` decimal(6,2) NOT NULL,
  `fechaCreacion` date NOT NULL,
  `fechaActualizacion` date NOT NULL,
  `numeroDocreceptor` varchar(25) DEFAULT NULL,
  `tipoDocreceptor` varchar(1) NOT NULL,
  `tipoComprobante` varchar(1) NOT NULL,
  `razonSocial` varchar(250) DEFAULT NULL,
  `emailReceptor` varchar(250) DEFAULT NULL,
  `microempresa_id` int(11) NOT NULL,
  `persona_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tienda_orden_microempresa_id_2de1595c_fk_tienda_microempresa_id` (`microempresa_id`),
  KEY `tienda_orden_persona_id_490d88e3_fk_tienda_personanatural_id` (`persona_id`),
  CONSTRAINT `tienda_orden_microempresa_id_2de1595c_fk_tienda_microempresa_id` FOREIGN KEY (`microempresa_id`) REFERENCES `tienda_microempresa` (`id`),
  CONSTRAINT `tienda_orden_persona_id_490d88e3_fk_tienda_personanatural_id` FOREIGN KEY (`persona_id`) REFERENCES `tienda_personanatural` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tienda_orden`
--

LOCK TABLES `tienda_orden` WRITE;
/*!40000 ALTER TABLE `tienda_orden` DISABLE KEYS */;
INSERT INTO `tienda_orden` VALUES (1,'1','2',2.00,0.12,'2018-06-04','2018-06-04','10706008391','1','3','10706008391','dramos@magiadigital.com',1,1),(2,'2','1',10.00,3.50,'2018-06-04','2018-06-04','10706008391','1','1','10706008391','dramos@magiadigital.com',1,1),(3,'3','2',20.00,4.50,'2018-06-04','2018-06-04','10706008391','1','1','10706008391','dramos@magiadigital.com',1,1),(4,'1','2',11.00,3.20,'2018-06-04','2018-06-04','10706008391','1','1','10706008391','dramos@magiadigital.com',1,1),(5,'1','2',2.00,0.78,'2018-06-26','2018-06-26','10706008391','1','1','10706008391','dramos@magiadigital.com',2,2),(6,'1','2',3.50,2.80,'2018-06-28','2018-06-28','10706008391','6','1','10706008391','dramos@magiadigital.com',1,1),(7,'1','2',0.00,0.00,'2018-06-28','2018-06-28','12345678','','1','','Hh@vv.com',1,NULL),(8,'1','2',0.00,0.00,'2018-06-28','2018-06-28','12345678','','1','Hola','Hola@gf.con',1,NULL),(9,'1','2',0.00,0.00,'2018-06-28','2018-06-28','12345678','','1','Hola','Hola@gf.con',1,NULL),(10,'1','2',0.00,0.00,'2018-06-28','2018-06-28','123456488','','1','Hola','Hola@gg.com',1,NULL),(11,'1','2',2.48,0.38,'2018-06-28','2018-06-28','123456488','6','1','10706008391','Hola@gg.com',1,NULL),(12,'1','2',0.00,0.00,'2018-06-28','2018-06-28','10706008391','','1','10706008391','Hola@gg.com',1,NULL),(13,'1','2',0.00,0.00,'2018-06-28','2018-06-28','1234567890','','1','1234567890','Hola@gg.com',1,NULL),(14,'1','2',2.48,0.38,'2018-06-28','2018-06-28','10706008392','','1','10706008392','Hh@gg.com',1,NULL),(18,'1','2',2.48,0.38,'2018-06-28','2018-06-28','07873586','','1','Juan','Jj@gkail.com',1,NULL),(19,'1','2',12.39,1.89,'2018-06-28','2018-06-28','07873586','','1','Jjmiranda','Jjm@jjmiranda.com',1,NULL);
/*!40000 ALTER TABLE `tienda_orden` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tienda_personanatural`
--

DROP TABLE IF EXISTS `tienda_personanatural`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tienda_personanatural` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dni` varchar(8) NOT NULL,
  `celular` varchar(15) DEFAULT NULL,
  `fechaCreacion` date NOT NULL,
  `fechaActualizacion` date NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `tienda_personanatural_user_id_9a6e9507_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tienda_personanatural`
--

LOCK TABLES `tienda_personanatural` WRITE;
/*!40000 ALTER TABLE `tienda_personanatural` DISABLE KEYS */;
INSERT INTO `tienda_personanatural` VALUES (1,'70600839',NULL,'2018-06-04','2018-06-04',2),(2,'70600838',NULL,'2018-06-26','2018-06-26',3),(3,'70600837',NULL,'2018-06-28','2018-06-28',4),(4,'70600839',NULL,'2018-06-28','2018-06-28',6);
/*!40000 ALTER TABLE `tienda_personanatural` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tienda_producto`
--

DROP TABLE IF EXISTS `tienda_producto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tienda_producto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `descripcion` longtext,
  `rating` int(11) NOT NULL,
  `stock` int(11) NOT NULL,
  `precioUnitario` decimal(6,2) NOT NULL,
  `precioCompra` decimal(6,2) NOT NULL,
  `fechaCreacion` date NOT NULL,
  `fechaActualizacion` date NOT NULL,
  `seguimiento` tinyint(1) NOT NULL,
  `unidadMedida` varchar(1) NOT NULL,
  `codigoBarras` varchar(15) NOT NULL,
  `categoria_id` int(11) NOT NULL,
  `marca_id` int(11) NOT NULL,
  `microempresa_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tienda_producto_categoria_id_6dc179b4_fk_tienda_ca` (`categoria_id`),
  KEY `tienda_producto_marca_id_a4add90c_fk_tienda_marca_id` (`marca_id`),
  KEY `tienda_producto_microempresa_id_544ea265_fk_tienda_mi` (`microempresa_id`),
  KEY `tienda_producto_slug_c05859fd` (`slug`),
  CONSTRAINT `tienda_producto_categoria_id_6dc179b4_fk_tienda_ca` FOREIGN KEY (`categoria_id`) REFERENCES `tienda_categoriaproducto` (`id`),
  CONSTRAINT `tienda_producto_marca_id_a4add90c_fk_tienda_marca_id` FOREIGN KEY (`marca_id`) REFERENCES `tienda_marca` (`id`),
  CONSTRAINT `tienda_producto_microempresa_id_544ea265_fk_tienda_mi` FOREIGN KEY (`microempresa_id`) REFERENCES `tienda_microempresa` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tienda_producto`
--

LOCK TABLES `tienda_producto` WRITE;
/*!40000 ALTER TABLE `tienda_producto` DISABLE KEYS */;
INSERT INTO `tienda_producto` VALUES (1,'Chicle A','chicle-a','',0,250,1.20,1.00,'2018-06-04','2018-06-04',0,'1','000000000000007',2,2,1),(2,'Galleta A','galleta-a','',0,149,0.50,0.30,'2018-06-04','2018-06-04',0,'1','000000000000006',2,3,1),(3,'Galleta B','galleta-b','',0,150,1.50,1.20,'2018-06-04','2018-06-04',0,'1','000000000000005',2,3,1),(4,'Frugo A','frugo-a','',0,90,1.20,0.99,'2018-06-04','2018-06-04',0,'1','000000000000004',2,4,1),(5,'Frugo B','frugo-b','',0,120,1.20,1.00,'2018-06-04','2018-06-04',0,'1','000000000000003',2,3,1),(6,'Chocolate A','chocolate-a','',0,45,4.50,3.20,'2018-06-04','2018-06-04',0,'1','000000000000002',2,5,1),(7,'Chocolate B','chocolate-b','',0,120,2.50,2.20,'2018-06-04','2018-06-04',0,'1','000000000000001',2,6,1),(8,'Magnesol','magnesol','',10,100,5.00,4.00,'2018-06-26','2018-06-26',0,'1','000000000000000',3,7,2),(9,'Inca Kola 1.5L','inca-kola-15l','',100,100,3.50,2.10,'2018-06-28','2018-06-28',0,'2','7750236330168',2,8,3),(10,'Inca Kola 1.5L','inca-kola-15l','',100,100,2.10,1.50,'2018-06-28','2018-06-28',0,'1','7750236330169',2,8,1);
/*!40000 ALTER TABLE `tienda_producto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tienda_proveedor`
--

DROP TABLE IF EXISTS `tienda_proveedor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tienda_proveedor` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `razonSocial` varchar(250) NOT NULL,
  `ruc` varchar(15) NOT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `direccion` varchar(250) DEFAULT NULL,
  `correo` varchar(100) NOT NULL,
  `microempresa_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tienda_proveedor_microempresa_id_0a2523aa_fk_tienda_mi` (`microempresa_id`),
  CONSTRAINT `tienda_proveedor_microempresa_id_0a2523aa_fk_tienda_mi` FOREIGN KEY (`microempresa_id`) REFERENCES `tienda_microempresa` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tienda_proveedor`
--

LOCK TABLES `tienda_proveedor` WRITE;
/*!40000 ALTER TABLE `tienda_proveedor` DISABLE KEYS */;
/*!40000 ALTER TABLE `tienda_proveedor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tienda_proveedorproducto`
--

DROP TABLE IF EXISTS `tienda_proveedorproducto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tienda_proveedorproducto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `microempresa_id` int(11) NOT NULL,
  `producto_id` int(11) NOT NULL,
  `proveedor_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tienda_proveedorprod_microempresa_id_0bb6860a_fk_tienda_mi` (`microempresa_id`),
  KEY `tienda_proveedorprod_producto_id_4441856b_fk_tienda_pr` (`producto_id`),
  KEY `tienda_proveedorprod_proveedor_id_73f08e8c_fk_tienda_pr` (`proveedor_id`),
  CONSTRAINT `tienda_proveedorprod_microempresa_id_0bb6860a_fk_tienda_mi` FOREIGN KEY (`microempresa_id`) REFERENCES `tienda_microempresa` (`id`),
  CONSTRAINT `tienda_proveedorprod_producto_id_4441856b_fk_tienda_pr` FOREIGN KEY (`producto_id`) REFERENCES `tienda_producto` (`id`),
  CONSTRAINT `tienda_proveedorprod_proveedor_id_73f08e8c_fk_tienda_pr` FOREIGN KEY (`proveedor_id`) REFERENCES `tienda_proveedor` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tienda_proveedorproducto`
--

LOCK TABLES `tienda_proveedorproducto` WRITE;
/*!40000 ALTER TABLE `tienda_proveedorproducto` DISABLE KEYS */;
/*!40000 ALTER TABLE `tienda_proveedorproducto` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-07-26 17:31:43
