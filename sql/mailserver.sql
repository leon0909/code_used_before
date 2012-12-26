-- MySQL dump 10.13  Distrib 5.5.19, for linux2.6 (i686)
--
-- Host: localhost    Database: mailserver
-- ------------------------------------------------------
-- Server version	5.5.19-log

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
-- Table structure for table `autoresponder`
--

DROP TABLE IF EXISTS `autoresponder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `autoresponder` (
  `email` varchar(255) NOT NULL DEFAULT '',
  `descname` varchar(255) DEFAULT NULL,
  `from` date NOT NULL DEFAULT '0000-00-00',
  `to` date NOT NULL DEFAULT '0000-00-00',
  `message` text NOT NULL,
  `enabled` tinyint(4) NOT NULL DEFAULT '0',
  `subject` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`email`),
  FULLTEXT KEY `message` (`message`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `autoresponder`
--

LOCK TABLES `autoresponder` WRITE;
/*!40000 ALTER TABLE `autoresponder` DISABLE KEYS */;
INSERT INTO `autoresponder` VALUES ('dominique.poulain@fens.org','','0000-00-00','0000-00-00','I am currently not in the office and will reply to your e-mails as soon as possible after my return on',0,''),('birgit.jarchow@fens.org','','0000-00-00','0000-00-00','I am currently not in the office and will reply to your e-mails as soon as possible after my return on',0,''),('helmut.kettenman@fens.org','','0000-00-00','0000-00-00','I am currently not in the office and will reply to your e-mails as soon as possible after my return on ..',0,''),('neurotrain@fens.org','','0000-00-00','0000-00-00','I am currently not in the office and will reply to your e-mails as soon as possible after my return on ..',0,''),('clemens.webert@fens.org','','0000-00-00','0000-00-00','I am currently not in the office and will reply to your e-mails as soon as possible after my return on ..',0,''),('david.speck@fens.org','','0000-00-00','0000-00-00','I am currently not in the office and will reply to your e-mails as soon as possible after my return on ..',0,''),('tanja.butzek@fens.org','','2012-02-03','2012-02-06','I am away from my office and will reply to your e-mails as soon as possible after my return. \r\n\r\nIn case you should have problems registering for the FENS Forum, please send your request to the registration office of our congress organiser:\r\n\r\nDaniela Wizen <dwizen@kenes.com>\r\n                                   ',0,'out of the office'),('schools@fens.org','','2011-12-23','2012-01-04','I am away from my office and will reply to your e-mails as soon as possible after my return on Wednesday, January 4th. \r\n\r\nIn urgent cases please contact my colleague Britta.Morich@fens.org or Meino.Gibson@fens.org\r\n\r\nWishing you a Merry X-mas and a Happy New Year!\r\n\r\n',0,'out of the office'),('nens@fens.org','','2010-12-13','2010-12-16','Hello,\r\n\r\nI will be back in the office on December 16, 2010.\r\n\r\nBest regards,\r\nBritta Morich   ',0,'out of the office'),('awards@fens.org','','2010-12-13','0000-00-00','   Hello,\r\n\r\nI will be back in the office on December 16, 2010.\r\n\r\nBest regards,\r\nBritta Morich',0,'out of the office'),('stipends@fens.org','','2011-08-18','2011-08-21','I am currently not in the office and will reply to your e-mails as soon as possible after my return on Monday, August 22nd. \r\n\r\nIn urgent cases please contact my colleague Meino.Gibson@fens.org\r\n\r\nThanks!          ',0,'out of the office'),('leonid.heidt@fens.org','','2011-12-29','2012-01-06','I am currently not in the office and will reply to your e-mails as soon as possible after my return on 06.01.2012      ',0,'on vacations until 06.01.12'),('britta.morich@fens.org','','2011-11-04','2011-11-27','Hello,\r\n\r\nThank you for your email.\r\n\r\nI will be back in the office on November 28, 2011.\r\n\r\nIn urgent cases please contact my colleague Meino Gibson at meino.gibson@fens.org or Tanja Butzek at tanja.butzek@fens.org.\r\n\r\nRegards,\r\nBritta Morich\r\n                                                      ',0,'Out of the office'),('meino.gibson@fens.org','','2012-02-03','2012-02-06','I am away from my office and will reply to your e-mails as soon as possible after my return. \r\n\r\nIn case you should have problems registering for the FENS Forum, please send your request to the registration office of our congress organiser:\r\n\r\nDaniela Wizen <dwizen@kenes.com>\r\n             ',0,'Out of the office');
/*!40000 ALTER TABLE `autoresponder` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_admins`
--

DROP TABLE IF EXISTS `domain_admins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `domain_admins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_admins`
--

LOCK TABLES `domain_admins` WRITE;
/*!40000 ALTER TABLE `domain_admins` DISABLE KEYS */;
INSERT INTO `domain_admins` VALUES (1,0,0),(2,0,10);
/*!40000 ALTER TABLE `domain_admins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `expires`
--

DROP TABLE IF EXISTS `expires`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `expires` (
  `username` varchar(100) NOT NULL,
  `mailbox` varchar(255) NOT NULL,
  `expire_stamp` int(11) NOT NULL,
  PRIMARY KEY (`username`,`mailbox`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expires`
--

LOCK TABLES `expires` WRITE;
/*!40000 ALTER TABLE `expires` DISABLE KEYS */;
/*!40000 ALTER TABLE `expires` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `languages`
--

DROP TABLE IF EXISTS `languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `languages` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=24 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `languages`
--

LOCK TABLES `languages` WRITE;
/*!40000 ALTER TABLE `languages` DISABLE KEYS */;
INSERT INTO `languages` VALUES (1,'English',1),(2,'Deutsch',1);
/*!40000 ALTER TABLE `languages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quota`
--

DROP TABLE IF EXISTS `quota`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quota` (
  `username` varchar(100) NOT NULL,
  `bytes` bigint(20) NOT NULL DEFAULT '0',
  `messages` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quota`
--

LOCK TABLES `quota` WRITE;
/*!40000 ALTER TABLE `quota` DISABLE KEYS */;
/*!40000 ALTER TABLE `quota` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `text`
--

DROP TABLE IF EXISTS `text`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `text` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `mid` int(10) NOT NULL,
  `language_id` int(3) NOT NULL,
  `text` longtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=462 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `text`
--

LOCK TABLES `text` WRITE;
/*!40000 ALTER TABLE `text` DISABLE KEYS */;
INSERT INTO `text` VALUES (1,1,1,'Email adress'),(2,1,2,'Email Adresse'),(3,2,1,'Password'),(4,2,2,'Passwort'),(5,3,1,'is logged in as'),(6,3,2,'ist eingeloggt als'),(7,4,1,'No domain name.'),(8,4,2,'Kein Domainname angegeben.'),(9,5,1,'Domain name is not valid. Please check the rules for domain names.'),(10,5,2,'Domainname ist ungültig. Überprüfen Sie die Regeln für Domainnamen.'),(11,6,1,'Domain name did not change.'),(12,6,2,'Domainname wurde nicht verändert.'),(13,7,1,'New domain name '),(14,7,2,'Neuer Domainname '),(15,8,1,' is not valid. Please check the rules for domain names.'),(16,8,2,' ist ungültig. Überprüfen Sie die Regeln für Domainnamen.'),(17,9,1,'A virtual domain with this name already exists in the database.'),(18,9,2,'Eine virtuelle Domain mit diesem Namen existiert bereits in der Datenbank.'),(19,10,1,'No name for new virtual user.'),(20,10,2,'Kein Name für den neuen virtuellen Benutzer angegeben.'),(21,11,1,'New name '),(22,11,2,'Neuer Name '),(23,12,1,' is not valid. Please check the rules for names in email addresses.'),(24,12,2,' ist ungültig. Überprüfen Sie die Regeln für die Bezeichnung von Emailadressen.'),(25,13,1,'Password '),(26,13,2,'Passwort '),(27,14,1,' is not valid. Please check the rules for passwords.'),(28,14,2,' ist nicht gültig. Bitte überprüfen Sie die Regeln für Passwörter.'),(29,15,1,'A virtual user with this name already exists in this domain.'),(30,15,2,'Ein virtueller Benutzer mit diesem Namen existiet bereits in der Domain.'),(31,16,1,'No name for new virtual user.'),(32,16,2,'Kein Nae für den neuen, virtuellen Benutzer angegeben.'),(33,17,1,'No password for new virtual user.'),(34,17,2,'Kein Passwort für den neuen, virtuellen Benutzer angegeben.'),(35,18,1,'Really delete virtual domain '),(36,18,2,'Soll die Domain '),(37,19,1,'Users of this virtual domain also will be deleted recursivly.'),(38,19,2,'wirklich gelöscht werden? Dabei werden alle virtuellen Benutzer dieser Domain ebenfalls gelöscht.'),(39,20,1,'Really delete user: '),(40,20,2,'Benutzer wirklich löschen:'),(41,21,1,'Really save changes to virtual domain'),(42,21,2,'Änderungen wirklich speichern bei Domain'),(43,22,1,'Users adresses of this virtual domain also will be changed recursivly.'),(44,22,2,'Die Benutzeradressen werden dabei ebenfalls rekursiv angepasst.'),(45,23,1,'Manage virtual domains'),(46,23,2,'Virtuelle Domains verwalten'),(47,24,1,'Manage virtual users'),(48,24,2,'Virtuelle Benutzer verwalten'),(49,25,1,'Virtual Domain Manager'),(50,25,2,'Verwaltung virtueller Domains'),(51,26,1,'Number of domains:'),(52,26,2,'Anzahl Domains:'),(53,27,1,'Number of users:'),(54,27,2,'Anzahl Benutzer:'),(55,28,1,'Add new virtual domain'),(56,28,2,'Virtuelle Domain hinzufügen'),(57,29,1,'New virtual domain'),(58,29,2,'Neue virtuelle Domain'),(59,30,1,'Name of domain (FQDN):'),(60,30,2,'Name der Domain (FQDN):'),(61,31,1,'Save new virtual domain'),(62,31,2,'Neue virtuelle Domain speichern'),(63,32,1,'with validation of name'),(64,32,2,'mit Überprüfung des Namens'),(65,33,1,'Virtual domain list'),(66,33,2,'Liste virtueller Domains'),(67,34,1,'Action'),(68,34,2,'Aktion'),(69,35,1,'Virtual domain name'),(70,35,2,'Name der virtuellen Domain'),(71,36,1,'Save changes'),(72,36,2,'Änderungen speichern'),(73,37,1,'Edit'),(74,37,2,'Ändern'),(75,38,1,'Delete'),(76,38,2,'Löschen'),(77,39,1,'Virtual User Manager'),(78,39,2,'Verwaltung virtueller Benutzer'),(79,40,1,'Select a virtual domain:'),(80,40,2,'Virtuelle Domain auswählen:'),(81,41,1,'Select DomainMasters'),(82,41,2,'Domain Verwalter bestimmen'),(83,42,1,'Add new virtual user to selected domain'),(84,42,2,'Neuen virtuellen Benutzer hinzufügen'),(85,43,1,'DomainMaster?'),(86,43,2,'Domain Verwalter?'),(87,44,1,'Virtual users email address'),(88,44,2,'Benutzer Email Adresse'),(89,45,1,'Save DomainMasters'),(90,45,2,'Domain Verwalter speichern'),(91,46,1,'New virtual user'),(92,46,2,'Neuen Bemnutzer anlegen'),(93,47,1,'Name of virtual user:'),(94,47,2,'Benutzername:'),(95,48,1,'Password (default auto):'),(96,48,2,'Passwort (automatisch):'),(97,49,1,'Save new virtual user'),(98,49,2,'Neuen Benutzer speichern'),(99,50,1,'Create New password'),(100,50,2,'Neues Passwort erstellen'),(101,51,2,'Informationen zur Bedienung des Mail Managers'),(102,51,1,'Information on how to use Mail Manager'),(103,52,2,'Allgemein'),(104,52,1,'Common informations'),(105,53,2,'Mit diesem Interface können virtuelle Domains und deren Benutzer verwaltet werden.<br>Die Rolle des MailMasters berechtigt zum Anlegen, editieren und löschen von virtuellen Domains und deren Benutzer. Weiterhin kann dieser Benutzer DomainMasters bestimmen, die innerhalb ihrer Domain die Benutzer verwalten können. Somit kann die Administration einzelner Domains durch deren berchtigte Personen selbst erfolgen.<br><br>Die Software ist unter GPL - Lizenz veröffentlicht. Es wird keinerlei Garantie gewährt.'),(106,53,1,'With this interface virtual domains and th correspondending users ca be managed.<br>A user with the role of a MailMaster can create, edit or delete virtual domains and their users. He also can decide about who can manage the single domains in the role of a DomainMaster. So the administration of the single domains can be done by the owners of the domain.<br><br>This software is published under GPL license and comes without any warranty.'),(107,54,2,'Virtuelle Domains verwalten'),(108,54,1,'Managing virtual domains'),(109,55,2,'Zugang zur Domainverwaltung haben nur Benutzer mit dem Status MailMaster.<br><br>Beim Erstellen einer virtuellen Domain wird die Gültigkeit des eingegebenen Domainnamens standardmässig überprüft.<br>Sollte es dabei zu Problemen kommen, kann diese Überprüfung auch deaktiviert werden. Jedoch ist dabei auf eine korrekte Namensvergabe zu achten, da ansonsten die virtuelle Domain nicht funktionieren wird.<br>				<br>				Erlaubte Zeichen sind a-z, A-Z, 0-9 und -. Die Mindeszahl der Zeichen vor dem Punkt beträgt 3, nach dem Punkt 2-3 Zeichen.<br><br>Bei Änderungen einer virtuellen Domain werden alle auf dieser Domain registrierten Email Adressen automatisch mitgeändert. Dasselbe gilt für das Löschen einer virtuellen Domain.<br>'),(110,55,1,'The usage of this section is permitted only to MailMasters.<br><br>When creating a new virtual domain, the given name is checked against the platform rules. If problems with the name appear the check can be disabled. If you disable the name check please check the correctness by yourself, otherwise the domain may not function correctly.<br><br>Allowed chars are a-z, A-Z, 0-9 and -. There have to be at least 3 chars before the dot 2-3 chars after the dot.<br><br>If a virtual domain is changed, all of the registered email adresses of this domain are changed too automatically. Also when a domain is deleted, alln users are deleted too.<br>'),(111,56,2,'Virtuelle Benutzer verwalten'),(112,56,1,'Manage virtual users'),(113,57,2,'Zugang zur Domainverwaltung haben Benutzer mit dem Status MailMaster oder DomainMaster, wobei ein DomainMaster auch mehrere Domains verwalten kann.<br><br>Um mit dem Benutzer Manager arbeiten zu können muss zuerst eine Domain ausgewählt werden. Danach können DomainMaster bestimmt, Benutzer angelegt, geändert oder gelöscht werden.<br><br>Eingegebene Namen und Passwörter werden jeweils auf ihre Gültigkeit überprüft.<br>				Erlaubte Zeichen bei Namen sind a-z, A-Z, 0-9 . und -. Die erlaubte Anzahl der Zeichen beträgt 3 - 30.<br>Erlaubte Zeichen bei Passwörtern sind a-z, A-Z, 0-9 $ und @. Die erlaubte Anzahl der Zeichen beträgt 8 - 15.<br>Beim Erstellen und Editieren eines Benutzers wird jeweils ein generiertes Passwort vorgeschlagen, das jedoch überschrieben werden kann.'),(114,57,1,'Usage of this section is peritted to MailMasters and DomainMasters. One DomainMaster can manage 1 or more domains.<br><br>To wok with the user manager first you have to select a virtual domain. After selection of a domain, you will be able to manage DomainMasters and the users of the selected domain. Users can be created, edited or deleted.<br><br>Given name and passwords will be checked against the rules of this platform.<br>Allowed chars for names are a-z, A-Z, 0-9 . and -. A name has to have between 3 and 30 chars.<br>Allowed chars for passwords are a-z, A-Z, 0-9 $ and @. A password has to have between 8 and 15 chars.<br>If you create or edit a virtual user, a generated password will be given. You can overwrite this password but still matching the rules.'),(115,58,1,'Sorry, no permission to this administration area.'),(116,58,2,'Kein Zutritt zu diesem Administrationsbereich'),(117,59,1,'No user with this data. Check your entries.'),(118,59,2,'Kein Benutzer mit diesen Daten. Überprüfen Sie Ihre Angaben.'),(119,60,1,'No password.'),(120,60,2,'Kein Passwort angegeben.'),(121,61,1,'No email adress.'),(122,61,2,'Keine Email Adresse angegeben.'),(123,62,1,'Manage virtual aliases'),(124,62,2,'Virtuelle Aliase verwalten'),(125,63,1,'Invalid email'),(126,63,2,'Ungültige Email Addresse.'),(127,64,1,'Invalid domain.'),(128,64,2,'Ungültige Domain.'),(129,65,1,'Invalid name in email.'),(130,65,2,'Ungültiger Name in der Email Adresse.'),(131,66,1,'You really want to delete this alias?'),(132,66,2,'Soll dieser Alias wirklich gelöscht werden?'),(133,67,1,'This section is permitted to every validated email user.<br><br>You can edit your username and change your password. The corresponding email addresses will be fixed recursivly.<br>You also can add, edit or delete virtual aliases. Every input is validated against the rules and changes are made recursivly.'),(134,67,2,'Dieser Bereich ist für alle registrierten Email Benutzer zugänglich.<br><br>Hier kann man seine Email Adresse ändern oder ein neues Passwort anlegen. Zusätzlich besteht die Möglichkeit Email Aliase (Weierleitungen) anzulegen, zu editieren oder zu löschen.<br>Alle Angaben werden auf ihre Gültigkeit überprüft.'),(135,68,1,'Select a virtual user'),(136,68,2,'Virtuellen Benutzer auswählen'),(137,69,1,' on domain '),(138,69,2,' in Domain '),(139,70,1,'Email alias'),(140,70,2,'Email alias'),(141,71,1,'Forwardings for '),(142,71,2,'Weiterleitungen für '),(143,72,1,'Add virtual alias'),(144,72,2,'Neuen Alias hinzufügen'),(145,73,1,'New alias'),(146,73,2,'Neuer Alias'),(147,74,1,'Save new alias'),(148,74,2,'Neuen Alias speichern'),(149,75,1,'Virtual user name'),(150,75,2,'Virtueller Benutzername'),(151,76,1,'Forwarded to'),(152,76,2,'Weiterleitung nach'),(153,77,1,'Email address'),(154,77,2,'Email Adresse'),(155,78,1,'Add forwarding'),(156,78,2,'Weiterleitung hinzufügen'),(157,79,1,'New forwarding'),(158,79,2,'Neue Weiterleitung'),(159,80,1,'Save new forwarding'),(160,80,2,'Neue Weiterleitung speichern'),(161,81,1,'Virtual alias'),(162,81,2,'Virtueller Alias'),(163,82,1,'User email'),(164,82,2,'Email Adresse'),(165,83,1,'New alias'),(166,83,2,'Neuer Alias'),(167,84,1,'Alias name'),(168,84,2,'Alias Name'),(169,85,1,'Emails forward to'),(170,85,2,'Emails weiterleiten nach'),(171,86,1,'Virtual aliases for '),(172,86,2,'Virtuelle Aliase für '),(173,87,1,' on virtual domain '),(174,87,2,' in Domain '),(175,88,1,'Really want to delete this email forwarding?'),(176,88,2,'Soll diese Weiterleitung wirklich gelöscht werden?'),(177,89,1,'This alias is already in use.'),(178,89,2,'Dieser Alias ist schon vergeben.'),(179,90,1,'Please insert an alias name.'),(180,90,2,'Kein Alias Name angegeben.');
/*!40000 ALTER TABLE `text` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `view_aliases`
--

DROP TABLE IF EXISTS `view_aliases`;
/*!50001 DROP VIEW IF EXISTS `view_aliases`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `view_aliases` (
  `email` varchar(91),
  `destination` varchar(80)
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_users`
--

DROP TABLE IF EXISTS `view_users`;
/*!50001 DROP VIEW IF EXISTS `view_users`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `view_users` (
  `email` varchar(91),
  `domain` varchar(50),
  `password` varchar(32),
  `pw_hashed` varchar(255),
  `proxy_host` varchar(19),
  `proxy_pop3_port` enum('10110','110','10995','995'),
  `proxy_imap_port` enum('10143','143','10993','993')
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `virtual_aliases`
--

DROP TABLE IF EXISTS `virtual_aliases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `virtual_aliases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain_id` int(11) NOT NULL,
  `source` varchar(40) NOT NULL,
  `destination` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `domain_id` (`domain_id`)
) ENGINE=MyISAM AUTO_INCREMENT=71 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `virtual_aliases`
--

LOCK TABLES `virtual_aliases` WRITE;
/*!40000 ALTER TABLE `virtual_aliases` DISABLE KEYS */;
INSERT INTO `virtual_aliases` VALUES (45,0,'clemens.webert','clemens.webert@fens.org'),(44,0,'olga.zvyagintseva','olga.zvyagintseva@fens.org'),(43,0,'events.forum','events.forum@fens.org'),(42,0,'smtp1.mail','smtp1.mail@fens.org'),(6,0,'dominique.poulain','dominique.poulain@fens.org'),(41,0,'pc.com','pc.com@fens.org '),(8,0,'tanja.butzek','tanja.butzek@fens.org'),(10,0,'britta.morich','britta.morich@fens.org'),(40,0,'programme.forum','programme.forum@fens.org '),(39,0,'elections','elections@fens.org'),(37,0,'venus.mail','venus.mail@fens.org'),(14,0,'neurotrain','mgibson@mdc-berlin.de'),(38,0,'office','office@fens.org'),(16,0,'leonid.heidt','leonid.heidt@fens.org'),(35,0,'webmaster','david.speck@fens.org'),(18,0,'helmut.kettenman','helmut.kettenman@fens.org'),(29,0,'meino.gibson','meino.gibson@fens.org'),(30,0,'schools','schools@fens.org'),(31,0,'nens','nens@fens.org'),(32,0,'awards','awards@fens.org'),(24,0,'postmaster','leonid.heidt@fens.org'),(34,0,'david.speck','david.speck@fens.org'),(26,0,'webmaster','clemens.webert@fens.org'),(27,0,'webmaster','leonid.heidt@fens.org'),(49,0,'stipends','stipends@fens.org'),(46,0,'fens.www','fens.www@fens.org'),(47,0,'proposals.forum','proposals.forum@fens.org'),(48,0,'sample.user','sample.user@fens.org'),(57,2,'root','postmaster@fens.org'),(51,0,'root','postmaster@fens.org'),(52,0,'forum2012','forum2012@fens.org'),(53,0,'forum2014','forum2014@fens.org'),(54,0,'forum2016','forum2016@fens.org'),(55,0,'forum2018','forum2018@fens.org'),(56,0,'lars.kristiansen','lars.kristiansen@fens.org'),(58,0,'grants.forum','grants.forum@fens.org'),(59,0,'fens-membership.webservice','korthals@mdc-berlin.de'),(60,0,'fens-membership.webservice','leonid.heidt@fens.org'),(61,0,'nens.webservice','leonid.heidt@fens.org'),(62,0,'nens.webservice','britta.morich@fens.org'),(63,0,'nens.webservice','clemens.webert@fens.org'),(64,0,'www-data','fens.www@fens.org'),(65,3,'postmaster','leonid.heidt@fens.org'),(66,2,'postmaster','leonid.heidt@fens.org'),(67,1,'postmaster','leonid.heidt@fens.org'),(68,0,'smmsp','leonid.heidt@fens.org'),(69,3,'root','leonid.heidt@fens.org'),(70,0,'dbmail.dev','dbmail.dev@fens.org');
/*!40000 ALTER TABLE `virtual_aliases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `virtual_domains`
--

DROP TABLE IF EXISTS `virtual_domains`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `virtual_domains` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `virtual_domains`
--

LOCK TABLES `virtual_domains` WRITE;
/*!40000 ALTER TABLE `virtual_domains` DISABLE KEYS */;
INSERT INTO `virtual_domains` VALUES (0,'fens.org'),(1,'1-fens.org'),(2,'smtp.fens.org'),(3,'mail.fens.org');
/*!40000 ALTER TABLE `virtual_domains` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `virtual_users`
--

DROP TABLE IF EXISTS `virtual_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `virtual_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain_id` int(11) NOT NULL,
  `user` varchar(40) NOT NULL,
  `password` varchar(32) NOT NULL,
  `pw_hashed` varchar(255) NOT NULL,
  `homeDir` varchar(170) CHARACTER SET utf8 NOT NULL,
  `master_user` enum('false','true') NOT NULL DEFAULT 'false',
  `proxy_host` varchar(19) CHARACTER SET utf8 NOT NULL DEFAULT '127.0.0.1',
  `proxy_imap_port` enum('10143','143','10993','993') CHARACTER SET utf8 NOT NULL DEFAULT '10143',
  `proxy_pop3_port` enum('10110','110','10995','995') NOT NULL DEFAULT '10110',
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQUE_EMAIL` (`domain_id`,`user`)
) ENGINE=MyISAM AUTO_INCREMENT=48 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `virtual_users`
--

LOCK TABLES `virtual_users` WRITE;
/*!40000 ALTER TABLE `virtual_users` DISABLE KEYS */;
INSERT INTO `virtual_users` VALUES (2,0,'awards','f4cf420e62ab36f6dbb117f4f18a3476','{CRAM-MD5}082fd88cfb3fec1f1cc55a1c336d114172a889279150ed6ff083b90b2fa7b906','/home/vmail/fens.org/awards','false','127.0.0.1','10143','10110'),(6,0,'dominique.poulain','f579dbbe54c35c979bcfac96e903501f','{CRAM-MD5}97bc75d9dbed710be620209af791d8906f6937da2414b7f97edc487e15a3d912','/home/vmail/fens.org/dominique.poulain','false','127.0.0.1','10143','10110'),(7,0,'tanja.butzek','90b0483ad89b44625803f225567c0190','{HMAC-MD5}b3bb3ab5b3a0a42f2bc7caf089ce0217578d7cda1b66c9e693b9ee370f86ab7b','/home/vmail/fens.org/tanja.butzek','false','127.0.0.1','10143','10110'),(18,0,'birgit.jarchow','f4cf420e62ab36f6dbb117f4f18a3476','{CRAM-MD5}082fd88cfb3fec1f1cc55a1c336d114172a889279150ed6ff083b90b2fa7b906','/home/vmail/fens.org/birgit.jarchow','false','127.0.0.1','10143','10110'),(9,0,'meino.gibson','7b740ac6f95414a23baad99c36d59416','{CRAM-MD5}0d581d6e94f5c3f91df22a646397b5bc26c478e2136e13e1c88dccd416c95d33','/home/vmail/fens.org/meino.gibson','false','127.0.0.1','10143','10110'),(10,0,'leonid.heidt','33cfc4c3bfeec069c76a8b16bc867b0f','{HMAC-MD5}bcc40852e87adb0e388b2571f8cc39f2a64e81abeeda39d6c6fbbecc91e89648','/home/vmail/fens.org/leonid.heidt','false','127.0.0.1','10143','10110'),(11,0,'helmut.kettenman','f4cf420e62ab36f6dbb117f4f18a3476','{CRAM-MD5}082fd88cfb3fec1f1cc55a1c336d114172a889279150ed6ff083b90b2fa7b906','/home/vmail/fens.org/helmut.kettenman','false','127.0.0.1','10143','10110'),(12,0,'nens','f4cf420e62ab36f6dbb117f4f18a3476','{CRAM-MD5}082fd88cfb3fec1f1cc55a1c336d114172a889279150ed6ff083b90b2fa7b906','/home/vmail/fens.org/nens','false','127.0.0.1','10143','10110'),(14,0,'postmaster','8720638d91639bec33caa1ccf9c1f319','{HMAC-MD5}f90fa1e23d32b3a72f68f6486b38e3d5e290534b81b6c3581d4ba7e2fcebc1a7','/home/vmail/fens.org/postmaster','false','127.0.0.1','10143','10110'),(15,0,'schools','2e51d865d87fe9417286b93a02c6da0e','{HMAC-MD5}052c1ac45116a3468cc918fcd94ad2ae74dbf94c27f897f7a43a19645a8a8463','/home/vmail/fens.org/schools','false','127.0.0.1','10143','10110'),(16,0,'webmaster','8720638d91639bec33caa1ccf9c1f319','{HMAC-MD5}f90fa1e23d32b3a72f68f6486b38e3d5e290534b81b6c3581d4ba7e2fcebc1a7','/home/vmail/fens.org/webmaster','false','127.0.0.1','10143','10110'),(8,0,'britta.morich','f4cf420e62ab36f6dbb117f4f18a3476','{CRAM-MD5}082fd88cfb3fec1f1cc55a1c336d114172a889279150ed6ff083b90b2fa7b906','/home/vmail/fens.org/britta.morich','false','127.0.0.1','10143','10110'),(19,0,'neurotrain','f4cf420e62ab36f6dbb117f4f18a3476','{CRAM-MD5}082fd88cfb3fec1f1cc55a1c336d114172a889279150ed6ff083b90b2fa7b906','/home/vmail/fens.org/neurotrain','false','127.0.0.1','10143','10110'),(20,0,'clemens.webert','abee7b0a31f50baa0297e06b1efe9585','{CRAM-MD5}e5a61eea00c4cf1e5a322143eb5c41b012f60c9fd01df509c37d67b03f921541','/home/vmail/fens.org/clemens.webert','false','127.0.0.1','10143','10110'),(21,0,'david.speck','f4cf420e62ab36f6dbb117f4f18a3476','{CRAM-MD5}082fd88cfb3fec1f1cc55a1c336d114172a889279150ed6ff083b90b2fa7b906','/home/vmail/fens.org/david.speck','false','127.0.0.1','10143','10110'),(28,0,'venus.mail','f4cf420e62ab36f6dbb117f4f18a3476','{CRAM-MD5}082fd88cfb3fec1f1cc55a1c336d114172a889279150ed6ff083b90b2fa7b906','/home/vmail/fens.org/venus.mail','false','127.0.0.1','10143','10110'),(23,0,'office','9f0c56dc49d4e3339d75b4e302f6667c','{CRAM-MD5}f80c037a1b4f37671f717d796a3f26c0d36ad487fd012a36634961f602a46de8','/home/vmail/fens.org/office','false','127.0.0.1','10143','10110'),(24,0,'elections','fe6e9bdafaaac058c2f8af5135675d8f','{HMAC-MD5}a76d155b021dd23edacd7d2fae6d26c29aa3781d132f4ddbcdb09f0df8a1c8dc','/home/vmail/fens.org/elections','false','127.0.0.1','10143','10110'),(25,0,'stipends','48ab1243dfc4a8c7b971e0f45b70a9d8','{HMAC-MD5}f1011950e70464ff9228a7d635a59045fccf50009e72222e667a4bbb8333431f','/home/vmail/fens.org/stipends','false','127.0.0.1','10143','10110'),(26,0,'pc.com','d3fa2a0e3d0cc1e580844791ff5e9c82','{HMAC-MD5}e6a2401a6f7605fe602e3223e830a305aea89d286e0a8c1b9176ac8d62fbdd8c','/home/vmail/fens.org/pc.com','false','127.0.0.1','10143','10110'),(27,0,'programme.forum','d3fa2a0e3d0cc1e580844791ff5e9c82','{HMAC-MD5}e6a2401a6f7605fe602e3223e830a305aea89d286e0a8c1b9176ac8d62fbdd8c','/home/vmail/fens.org/programme.forum','false','127.0.0.1','10143','10110'),(32,0,'proposals.forum','22382c4a1b0f6de35d77c7976ecb61fa','{CRAM-MD5}1aee28437b81a854c4258b702fa6609ecd28f48882711611af8bc5fddb4268e6','/home/vmail/fens.org/proposals.forum','false','127.0.0.1','10143','10110'),(31,0,'php.www','5e6ba3092b4e69dbfe1860b6b29b0927','{HMAC-MD5}0b857fced0c1a6bf29bd61ee4603c3cac1823d6e1a121d7e873fbb393b8469b6','/home/vmail/fens.org/php.www','false','127.0.0.1','10143','10110'),(33,0,'events.forum','6e0cbd571e9986bba1ab2feeb2a9bf9a','{CRAM-MD5}8de6f99dcec5408fb06af4a4ec0076f52c6e23ff97d1ffd99d556d3f45d17359','/home/vmail/fens.org/events.forum','false','127.0.0.1','10143','10110'),(36,0,'applications','9f82ab80c038d1cfe2bb9fa4012120aa','{CRAM-MD5}c74b1b7b2a5c704639b90e86b6713d356df5073012e1fb3b05ed8fe64ce42077','/home/vmail/fens.org/applications','false','127.0.0.1','10143','10110'),(35,0,'fens-mars.mdcberlin','9f0c56dc49d4e3339d75b4e302f6667c','{CRAM-MD5}f80c037a1b4f37671f717d796a3f26c0d36ad487fd012a36634961f602a46de8','/home/vmail/fens.org/fens-mars.mdcberlin','false','127.0.0.1','10143','10110'),(37,0,'olga.zvyagintseva','9f82ab80c038d1cfe2bb9fa4012120aa','{CRAM-MD5}c74b1b7b2a5c704639b90e86b6713d356df5073012e1fb3b05ed8fe64ce42077','/home/vmail/fens.org/olga.zvyagintseva','false','127.0.0.1','10143','10110'),(38,0,'fens.www','9f0c56dc49d4e3339d75b4e302f6667c','{CRAM-MD5}f80c037a1b4f37671f717d796a3f26c0d36ad487fd012a36634961f602a46de8','/home/vmail/fens.org/fens.www','false','127.0.0.1','10143','10110'),(47,0,'dbmail.dev','97791f14c7ab0675a38b826bad7ff7fc','{CRAM-MD5}520b8fb7a0f2a7f4abbd7cac6e28f4c7c47b5fec1de4ebda9e485ceed3a4ee21','','false','127.0.0.1','10143','10110'),(40,0,'forum2012','2268ecb5ff61af77aa8d85b708faa62c','{CRAM-MD5}c7afbb0a584dfbdf9a384a8c77a4438fffcaa1e2563c5dba554c7f0d07d858b6','/home/vmail/fens.org/forum2012','false','127.0.0.1','10143','10110'),(41,0,'forum2014','37cb62bd4e165b4141658a5d30df8057','{CRAM-MD5}42cfbe5a0040e8533d8d7a7ef8ac5c3a167906db20c76dc1ef55e32af9550160','/home/vmail/fens.org/forum2014','false','127.0.0.1','10143','10110'),(42,0,'forum2016','f06fe19b4e85809c3a8b932f052dfe21','{CRAM-MD5}5339662b518a77a555cf23742ea763e450604b074810eb0e67af62bb79387441','/home/vmail/fens.org/forum2016','false','127.0.0.1','10143','10110'),(43,0,'forum2018','302e01ff77fe42bcdcc5ed732555b026','{CRAM-MD5}8d71b3c2c649cad8bb2060f45593972a758a832f8bbf041c917d1984b36670b3','/home/vmail/fens.org/forum2018','false','127.0.0.1','10143','10110'),(44,0,'lars.kristiansen','6d863b552c585cc084c1067de207209c','{CRAM-MD5}2ca50942f9a326735485844869dce07c2e78cc884d336dceca1f714daa82574d','/home/vmail/fens.org/lars.kristiansen','false','127.0.0.1','10143','10110'),(45,0,'grants.forum','cf3aa0b1f6fdbdab6e4bd8b2ff2e1d0d','{CRAM-MD5}beff9b10eed2089c38beb1dc401654953ab211f175b483fd3a2b5d8f46777bcc','/home/vmail/fens.org/grants.forum','false','127.0.0.1','10143','10110'),(46,0,'proxy.pass','easyOne','{CRAM-MD5}21b51f53e278d50a5c404d9d9807097ac2f70d192f7fc6cef95887960427e14f','','true','127.0.0.1','10143','10110');
/*!40000 ALTER TABLE `virtual_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `view_aliases`
--

/*!50001 DROP TABLE IF EXISTS `view_aliases`*/;
/*!50001 DROP VIEW IF EXISTS `view_aliases`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_aliases` AS select concat(`virtual_aliases`.`source`,_latin1'@',`virtual_domains`.`name`) AS `email`,`virtual_aliases`.`destination` AS `destination` from (`virtual_aliases` left join `virtual_domains` on((`virtual_aliases`.`domain_id` = `virtual_domains`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_users`
--

/*!50001 DROP TABLE IF EXISTS `view_users`*/;
/*!50001 DROP VIEW IF EXISTS `view_users`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_users` AS select concat(`virtual_users`.`user`,'@',`virtual_domains`.`name`) AS `email`,`virtual_domains`.`name` AS `domain`,`virtual_users`.`password` AS `password`,`virtual_users`.`pw_hashed` AS `pw_hashed`,`virtual_users`.`proxy_host` AS `proxy_host`,`virtual_users`.`proxy_pop3_port` AS `proxy_pop3_port`,`virtual_users`.`proxy_imap_port` AS `proxy_imap_port` from (`virtual_users` left join `virtual_domains` on((`virtual_users`.`domain_id` = `virtual_domains`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-03-26 16:07:51
