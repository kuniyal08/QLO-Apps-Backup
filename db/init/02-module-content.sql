-- QloApps demo module content (fhdiscover blog/regions, qhr reviews, CMS pages).
-- Data exported from the dev stack DB; idempotent (CREATE IF NOT EXISTS / INSERT IGNORE).
/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.18-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: qloapps
-- ------------------------------------------------------
-- Server version	10.11.18-MariaDB-ubu2204

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
-- Table structure for table `qlo_fhdiscover_blog_category`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `qlo_fhdiscover_blog_category` (
  `id_blog_category` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `position` int(10) unsigned NOT NULL DEFAULT 0,
  `active` tinyint(1) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_blog_category`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qlo_fhdiscover_blog_category`
--

/*!40000 ALTER TABLE `qlo_fhdiscover_blog_category` DISABLE KEYS */;
INSERT IGNORE INTO `qlo_fhdiscover_blog_category` VALUES
(1,1,1),
(2,2,1),
(3,3,1),
(4,4,1);
/*!40000 ALTER TABLE `qlo_fhdiscover_blog_category` ENABLE KEYS */;

--
-- Table structure for table `qlo_fhdiscover_blog_category_lang`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `qlo_fhdiscover_blog_category_lang` (
  `id_blog_category` int(10) unsigned NOT NULL,
  `id_lang` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id_blog_category`,`id_lang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qlo_fhdiscover_blog_category_lang`
--

/*!40000 ALTER TABLE `qlo_fhdiscover_blog_category_lang` DISABLE KEYS */;
INSERT IGNORE INTO `qlo_fhdiscover_blog_category_lang` VALUES
(1,1,'Farmstay Stories'),
(2,1,'Village Guides'),
(3,1,'Activities'),
(4,1,'Government & Policy');
/*!40000 ALTER TABLE `qlo_fhdiscover_blog_category_lang` ENABLE KEYS */;

--
-- Table structure for table `qlo_fhdiscover_blog_post`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `qlo_fhdiscover_blog_post` (
  `id_blog_post` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_blog_category` int(10) unsigned NOT NULL,
  `cover` varchar(255) NOT NULL DEFAULT '',
  `active` tinyint(1) unsigned NOT NULL DEFAULT 1,
  `date_add` datetime NOT NULL,
  `date_upd` datetime NOT NULL,
  PRIMARY KEY (`id_blog_post`),
  KEY `fhdiscover_blog_post_active` (`active`,`date_add`),
  KEY `fhdiscover_blog_post_category` (`id_blog_category`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qlo_fhdiscover_blog_post`
--

/*!40000 ALTER TABLE `qlo_fhdiscover_blog_post` DISABLE KEYS */;
INSERT IGNORE INTO `qlo_fhdiscover_blog_post` VALUES
(1,1,'story-night-farm.jpg',1,'2026-08-06 04:05:29','2026-08-06 04:05:29'),
(2,2,'story-weaving.jpg',1,'2026-07-30 04:05:29','2026-07-30 04:05:29'),
(3,3,'story-ploughing.jpg',1,'2026-07-23 04:05:29','2026-07-23 04:05:29'),
(4,4,'story-farmstay-policy.jpg',1,'2026-07-16 04:05:29','2026-07-16 04:05:29');
/*!40000 ALTER TABLE `qlo_fhdiscover_blog_post` ENABLE KEYS */;

--
-- Table structure for table `qlo_fhdiscover_blog_post_lang`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `qlo_fhdiscover_blog_post_lang` (
  `id_blog_post` int(10) unsigned NOT NULL,
  `id_lang` int(10) unsigned NOT NULL,
  `title` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `excerpt` text NOT NULL,
  `content` mediumtext NOT NULL,
  `author` varchar(255) NOT NULL,
  `meta_title` varchar(255) NOT NULL,
  `meta_description` varchar(255) NOT NULL,
  PRIMARY KEY (`id_blog_post`,`id_lang`),
  KEY `fhdiscover_blog_post_lang_slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qlo_fhdiscover_blog_post_lang`
--

/*!40000 ALTER TABLE `qlo_fhdiscover_blog_post_lang` DISABLE KEYS */;
INSERT IGNORE INTO `qlo_fhdiscover_blog_post_lang` VALUES
(1,1,'A night on a Bundelkhand farm','a-night-on-a-bundelkhand-farm','Fireflies over the pond, millet rotis on a clay stove and the quiet of a working farm - one traveller\'s first farmstay.','The lane to the farmhouse ends at a kothi painted pale blue, facing a pond that glows green with lotus in the evenings. Our host, a retired teacher, walks us through the mustard crop before dark and hands us the churn for the evening\'s buttermilk.Supper is millet rotis cooked on a clay stove, dal from the family plot and a mango pickle older than our host\'s grandchildren. There is no television. There is no hurry.At dawn the farm wakes with the birds - parakeets stripping the guava trees, a pair of sarus cranes in the far field. This is the whole point of a farmstay: to live, for a night, inside the rhythm you normally only read about.','The QloApps Editorial Desk','A night on a Bundelkhand farm','Fireflies over the pond, millet rotis on a clay stove and the quiet of a working farm - one traveller\'s first farmstay.'),
(2,1,'Village guide: Chanderi\'s weaving country','village-guide-chanderi-weaving-country','The handloom belt of Bundelkhand, where muslin is woven to the rhythm of the village loom - and where to stay while you watch.','Chanderi\'s muslin has been woven for centuries, but the living part of it happens in the lanes around the town, where every third house has a loom in the courtyard.Visitors can sit with weavers for an afternoon, trace the pattern book of a nine-yard sari, and buy directly from the family that made it. The nearest farmstays are a short drive into the countryside - book two nights and pace the silk district and the fort on separate days.','The QloApps Editorial Desk','Village guide: Chanderi\'s weaving country','The handloom belt of Bundelkhand, where muslin is woven to the rhythm of the village loom - and where to stay while you watch.'),
(3,1,'Five farm activities you can actually join','five-farm-activities-you-can-actually-join','From churning butter to night birdwatching - the experiences UP farmstays now offer, and what each involves.','Farm stays in Uttar Pradesh now bundle stays with real farm life. The five activities guests join most:1. Morning milking and churning. Dairy is the heart of most farmstays - guests milk the cows at dawn and churn butter for breakfast.2. Field-to-plate cooking. Harvest what is in season, then cook it on a clay stove with the family.3. Fishpond afternoons. Many farms have rearing ponds; the catch becomes dinner.4. Farm walks with a guide. Crop cycles, soil and the economics of a working farm, explained by the people who run it.5. Night birdwatching. The terai wetlands and village ponds are among northern India\'s best - carry binoculars.','The QloApps Editorial Desk','Five farm activities you can actually join','From churning butter to night birdwatching - the experiences UP farmstays now offer, and what each involves.'),
(4,1,'Understanding UP\'s farm stay policy','understanding-ups-farm-stay-policy','The 2025 farm stay investment drive and B&B/homestay policy explained - and what it means for the properties you stay in.','In late 2025, the Government of Uttar Pradesh launched an investment drive for farm stays: rural properties with at least two lettable rooms, a reception area and a menu of farm activities - agri-farming, horticulture, fishponds, dairy and farm tours - eligible for capital-subsidy support.The parallel B&B/Homestay Policy 2025 streamlines registration under the state tourism portal, making small rural operators eligible to host guests formally, with single-window approvals.For travellers this means the supply of genuine, registered farm stays is growing fast across the state - and for operators it means a clear legal route to hosting. Every property on this platform follows these frameworks, and stays are booked directly with the property, with no third-party commission mark-ups.','The QloApps Editorial Desk','Understanding UP\'s farm stay policy','The 2025 farm stay investment drive and B&B/homestay policy explained - and what it means for the properties you stay in.');
/*!40000 ALTER TABLE `qlo_fhdiscover_blog_post_lang` ENABLE KEYS */;

--
-- Table structure for table `qlo_fhdiscover_region`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `qlo_fhdiscover_region` (
  `id_region` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `active` tinyint(1) unsigned NOT NULL DEFAULT 1,
  `position` int(10) unsigned NOT NULL DEFAULT 0,
  `cover` varchar(255) NOT NULL DEFAULT '',
  `date_add` datetime NOT NULL,
  `date_upd` datetime NOT NULL,
  PRIMARY KEY (`id_region`),
  KEY `fhdiscover_region_active` (`active`,`position`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qlo_fhdiscover_region`
--

/*!40000 ALTER TABLE `qlo_fhdiscover_region` DISABLE KEYS */;
INSERT IGNORE INTO `qlo_fhdiscover_region` VALUES
(1,1,1,'demo-region-bundelkhand.jpg','2026-08-12 04:04:45','2026-08-13 18:54:18'),
(2,1,2,'demo-region-awadh.jpg','2026-08-12 04:04:45','2026-08-13 18:54:18'),
(3,1,3,'demo-region-braj.jpg','2026-08-12 04:04:45','2026-08-13 18:54:18'),
(4,1,4,'demo-region-purvanchal.jpg','2026-08-12 04:04:45','2026-08-13 18:54:18'),
(5,1,5,'demo-region-rohilkhand.jpg','2026-08-12 04:04:45','2026-08-13 18:54:18'),
(6,1,6,'demo-region-kashi.jpg','2026-08-12 04:04:45','2026-08-13 18:54:18');
/*!40000 ALTER TABLE `qlo_fhdiscover_region` ENABLE KEYS */;

--
-- Table structure for table `qlo_fhdiscover_region_activity`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `qlo_fhdiscover_region_activity` (
  `id_region` int(10) unsigned NOT NULL,
  `id_rural_activity` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id_region`,`id_rural_activity`),
  KEY `fhdiscover_region_activity_activity` (`id_rural_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qlo_fhdiscover_region_activity`
--

/*!40000 ALTER TABLE `qlo_fhdiscover_region_activity` DISABLE KEYS */;
INSERT IGNORE INTO `qlo_fhdiscover_region_activity` VALUES
(1,1),
(1,2),
(1,3),
(1,4),
(1,5),
(1,6);
/*!40000 ALTER TABLE `qlo_fhdiscover_region_activity` ENABLE KEYS */;

--
-- Table structure for table `qlo_fhdiscover_region_hotel`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `qlo_fhdiscover_region_hotel` (
  `id_region` int(10) unsigned NOT NULL,
  `id_hotel` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id_region`,`id_hotel`),
  KEY `fhdiscover_region_hotel_hotel` (`id_hotel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qlo_fhdiscover_region_hotel`
--

/*!40000 ALTER TABLE `qlo_fhdiscover_region_hotel` DISABLE KEYS */;
INSERT IGNORE INTO `qlo_fhdiscover_region_hotel` VALUES
(1,3),
(2,2),
(3,4),
(4,5),
(5,6),
(6,7);
/*!40000 ALTER TABLE `qlo_fhdiscover_region_hotel` ENABLE KEYS */;

--
-- Table structure for table `qlo_fhdiscover_region_lang`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `qlo_fhdiscover_region_lang` (
  `id_region` int(10) unsigned NOT NULL,
  `id_lang` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `blurb` text NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`id_region`,`id_lang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qlo_fhdiscover_region_lang`
--

/*!40000 ALTER TABLE `qlo_fhdiscover_region_lang` DISABLE KEYS */;
INSERT IGNORE INTO `qlo_fhdiscover_region_lang` VALUES
(1,1,'Bundelkhand','Bundelkhand\'s rock-cut landscapes, forest fringes and fort towns - quiet farmstays between orchards and ravines.','Bundelkhand is the heartland of central Uttar Pradesh - undulating granite country, dense golden-hair forests and the storied forts of Jhansi, Kalinjar and Mahoba. Farmstays here sit between citrus orchards, millet fields and village ponds, with easy day trips to Panna\'s wildlife corridor and the Ken-Betwa river country.'),
(2,1,'Awadh','The nawabi heartland around Lucknow - mango orchards, riverine villages and the fine arts of chikan and cuisine.','Awadh, the country around Lucknow and the Gomti river, pairs refined nawabi culture with a slow rural rhythm. Stay in orchard farmhouses, learn chikan embroidery in village workshops and eat from the region\'s famous dum-style kitchens.'),
(3,1,'Braj','Krishna\'s country - Mathura, Vrindavan and the ghat towns of the Yamuna, ringed by pastoral villages.','Braj is the sacred pastoral landscape of Krishna\'s childhood - the ghats of Mathura and Vrindavan, the Govardhan hill and hundreds of hamlets tied to a living tradition of devotion and craft. Farmstays offer temple walks, village art and the sweets of the region.'),
(4,1,'Purvanchal','Eastern UP\'s river plains - the Ghaghra and the Ganga, mango groves, weavers and the holy cities of the Sarayu.','Purvanchal stretches from Ayodhya on the Sarayu eastwards across the Ghaghra plain. It is a country of mango orchards, handloom weavers and river ghats - slower, older and deeply connected to the holy rivers that shape it.'),
(5,1,'Rohilkhand','The green belt of Bareilly and Pilibhit - sugar-cane country, tiger forests and the terai wetlands.','Rohilkhand is the fertile northern plain where sugarcane, mangoes and the terai forests meet. Pilibhit\'s tiger reserve and the wetlands of the Surai river make it one of Uttar Pradesh\'s best birdwatching territories, with farmstays on working cane farms.'),
(6,1,'Kashi','The Varanasi country - ghats of the Ganga, Banarasi silk and sarnath\'s calm, ringed by weaving villages.','The Varanasi region is Uttar Pradesh\'s most visited landscape - the ghats of Kashi, the deer park of Sarnath and the silk-weaving villages of the Gangetic plain. Stay outside the city in farmhouses and walk into the weaving looms that make Banarasi silk.');
/*!40000 ALTER TABLE `qlo_fhdiscover_region_lang` ENABLE KEYS */;

--
-- Table structure for table `qlo_qhr_hotel_review`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `qlo_qhr_hotel_review` (
  `id_hotel_review` int(10) NOT NULL AUTO_INCREMENT,
  `id_hotel` int(10) NOT NULL,
  `id_order` int(10) NOT NULL,
  `rating` float unsigned NOT NULL,
  `subject` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `status_abusive` tinyint(1) DEFAULT 0,
  `status` tinyint(1) DEFAULT 0,
  `date_add` datetime NOT NULL,
  `date_upd` datetime NOT NULL,
  PRIMARY KEY (`id_hotel_review`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qlo_qhr_hotel_review`
--

/*!40000 ALTER TABLE `qlo_qhr_hotel_review` DISABLE KEYS */;
INSERT IGNORE INTO `qlo_qhr_hotel_review` VALUES
(1,1,0,4.5,'FHRB-TEST','temp',0,3,'2026-08-11 17:37:19','2026-08-11 17:37:19'),
(2,1,0,5,'FHRB-TEST','temp',0,3,'2026-08-11 17:37:19','2026-08-11 17:37:19'),
(3,1,0,4,'FHRB-TEST','temp',0,3,'2026-08-11 17:37:19','2026-08-11 17:37:19');
/*!40000 ALTER TABLE `qlo_qhr_hotel_review` ENABLE KEYS */;

--
-- Table structure for table `qlo_qhr_review_category_rating`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `qlo_qhr_review_category_rating` (
  `id_hotel_review` int(10) NOT NULL,
  `id_category` int(10) NOT NULL,
  `rating` float unsigned NOT NULL,
  PRIMARY KEY (`id_hotel_review`,`id_category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qlo_qhr_review_category_rating`
--

/*!40000 ALTER TABLE `qlo_qhr_review_category_rating` DISABLE KEYS */;
/*!40000 ALTER TABLE `qlo_qhr_review_category_rating` ENABLE KEYS */;

--
-- Table structure for table `qlo_qhr_review_reply`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `qlo_qhr_review_reply` (
  `id_review_reply` int(10) NOT NULL AUTO_INCREMENT,
  `id_hotel_review` int(10) NOT NULL,
  `id_employee` int(10) NOT NULL DEFAULT 0,
  `message` text NOT NULL,
  `date_add` datetime NOT NULL,
  PRIMARY KEY (`id_review_reply`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qlo_qhr_review_reply`
--

/*!40000 ALTER TABLE `qlo_qhr_review_reply` DISABLE KEYS */;
/*!40000 ALTER TABLE `qlo_qhr_review_reply` ENABLE KEYS */;

--
-- Table structure for table `qlo_qhr_review_report`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `qlo_qhr_review_report` (
  `id_hotel_review` int(10) NOT NULL,
  `id_customer` int(10) NOT NULL,
  PRIMARY KEY (`id_hotel_review`,`id_customer`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qlo_qhr_review_report`
--

/*!40000 ALTER TABLE `qlo_qhr_review_report` DISABLE KEYS */;
/*!40000 ALTER TABLE `qlo_qhr_review_report` ENABLE KEYS */;

--
-- Table structure for table `qlo_qhr_review_usefulness`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `qlo_qhr_review_usefulness` (
  `id_hotel_review` int(10) NOT NULL,
  `id_customer` int(10) NOT NULL,
  PRIMARY KEY (`id_hotel_review`,`id_customer`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qlo_qhr_review_usefulness`
--

/*!40000 ALTER TABLE `qlo_qhr_review_usefulness` DISABLE KEYS */;
/*!40000 ALTER TABLE `qlo_qhr_review_usefulness` ENABLE KEYS */;

--
-- Table structure for table `qlo_cms`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `qlo_cms` (
  `id_cms` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_cms_category` int(10) unsigned NOT NULL,
  `position` int(10) unsigned NOT NULL DEFAULT 0,
  `active` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `indexation` tinyint(1) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_cms`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qlo_cms`
--

/*!40000 ALTER TABLE `qlo_cms` DISABLE KEYS */;
INSERT IGNORE INTO `qlo_cms` VALUES
(1,1,0,1,0),
(2,1,1,1,0),
(3,1,2,1,0),
(4,1,3,1,0),
(5,1,4,1,0),
(6,1,99,1,1);
/*!40000 ALTER TABLE `qlo_cms` ENABLE KEYS */;

--
-- Table structure for table `qlo_cms_lang`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `qlo_cms_lang` (
  `id_cms` int(10) unsigned NOT NULL,
  `id_lang` int(10) unsigned NOT NULL,
  `id_shop` int(10) unsigned NOT NULL DEFAULT 1,
  `meta_title` varchar(128) NOT NULL,
  `meta_description` varchar(255) DEFAULT NULL,
  `meta_keywords` varchar(255) DEFAULT NULL,
  `content` longtext DEFAULT NULL,
  `link_rewrite` varchar(128) NOT NULL,
  PRIMARY KEY (`id_cms`,`id_shop`,`id_lang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qlo_cms_lang`
--

/*!40000 ALTER TABLE `qlo_cms_lang` DISABLE KEYS */;
INSERT IGNORE INTO `qlo_cms_lang` VALUES
(1,1,1,'Policies','Our policies of hotel bookings','conditions, policy, guidelines, protocol, rule','<h2 class=\"page-heading bottom-indent\">Policies</h2>\n      <div>\n      <p style=\"border-left:2px solid #808080;padding-left:5px;\">This page contains demo content for illustrative purposes only. Any resemblance to actual products, services, or events is purely coincidental. Thank you for your understanding.</p>\n      <hr /></div>\n      <div>\n      <p class=\"page-subheading\">Reservation Policy:</p>\n      <ul class=\"margin-btm-30\">\n      <li class=\"margin-btm-10\">Guests must provide valid credit card details to secure a reservation.</li>\n      <li class=\"margin-btm-10\">Cancellation policies vary based on room type and rate plan.</li>\n      <li class=\"margin-btm-10\">Changes to reservations may be subject to availability and additional charges.</li>\n      </ul>\n      <p class=\"page-subheading\">Check-in and Check-out Times:</p>\n      <ul class=\"margin-btm-30\">\n      <li class=\"margin-btm-10\">Check-in time: 11:00 AM</li>\n      <li class=\"margin-btm-10\">Check-out time: 10:30 AM</li>\n      <li class=\"margin-btm-10\">Early check-in and late check-out requests are subject to availability and may incur additional charges.</li>\n      </ul>\n      <p class=\"page-subheading\">Payment Policy:</p>\n      <ul class=\"margin-btm-30\">\n      <li class=\"margin-btm-10\">Payment for the entire stay is due upon check-in.</li>\n      <li class=\"margin-btm-10\">Acceptable forms of payment: credit cards, cash, etc.</li>\n      <li class=\"margin-btm-10\">A security deposit may be required upon arrival.</li>\n      </ul>\n      <p class=\"page-subheading\">Cancellation and No-show Policy:</p>\n      <ul class=\"margin-btm-30\">\n      <li class=\"margin-btm-10\">Cancellations made 7 days prior to arrival are eligible for a full refund.</li>\n      <li class=\"margin-btm-10\">No-shows will be charged the full amount of the reservation.</li>\n      </ul>\n      <p class=\"page-subheading\">Pet Policy:</p>\n      <ul class=\"margin-btm-30\">\n      <li class=\"margin-btm-10\">Pets are welcome with prior arrangement.</li>\n      <li class=\"margin-btm-10\">Additional charges may apply for pet-friendly accommodations.</li>\n      <li class=\"margin-btm-10\">Guests are responsible for any damages caused by their pets.</li>\n      </ul>\n      <p class=\"page-subheading\">Smoking Policy:</p>\n      <ul class=\"margin-btm-30\">\n      <li class=\"margin-btm-10\">Our hotel is smoke-free. Smoking is strictly prohibited indoors.</li>\n      <li class=\"margin-btm-10\">Designated smoking areas are available outside the premises.</li>\n      </ul>\n      <p class=\"page-subheading\">Privacy Policy:</p>\n      <ul class=\"margin-btm-30\">\n      <li class=\"margin-btm-10\">We are committed to protecting your privacy and personal information.</li>\n      <li class=\"margin-btm-10\">Information collected during booking and stay is used solely for operational purposes.</li>\n      </ul>\n      <p class=\"page-subheading\">Accessibility Policy:</p>\n      <ul class=\"margin-btm-30\">\n      <li class=\"margin-btm-10\">Our hotel is committed to providing accessible accommodations and facilities for guests with disabilities.</li>\n      <li class=\"margin-btm-10\">Please contact us directly for specific accessibility requests.</li>\n      </ul>\n      <p class=\"page-subheading\">Additional Policies:</p>\n      <ul class=\"margin-btm-30\">\n      <li class=\"margin-btm-10\">Use of hotel facilities such as the gym, spa, pool, etc.</li>\n      <li class=\"margin-btm-10\">Conduct and behavior expectations while on hotel premises.</li>\n      </ul>\n      </div>\n    ','policies'),
(2,1,1,'Legal Notice','Legal notice','notice, legal, credits','\n      <h2 class=\"page-heading bottom-indent\"><strong>Legal Notice</strong></h2>\n      <div>\n      <p style=\"border-left:2px solid #808080;padding-left:5px;\">This page contains demo content for illustrative purposes only. Any resemblance to actual products, services, or events is purely coincidental. Thank you for your understanding.</p>\n      <hr /></div>\n      <p class=\"margin-btm-30 page-subheading\">Website Terms of Use:</p>\n      <ul class=\"margin-btm-30\">\n      <li class=\"margin-btm-20\">The content of the pages of this website is for your general information and use only. It is subject to change without notice.</li>\n      <li class=\"margin-btm-20\">Neither we nor any third parties provide any warranty or guarantee as to the accuracy, timeliness, performance, completeness, or suitability of the information and materials found or offered on this website for any particular purpose. You acknowledge that such information and materials may contain inaccuracies or errors, and we expressly exclude liability for any such inaccuracies or errors to the fullest extent permitted by law.</li>\n      <li class=\"margin-btm-20\">Your use of any information or materials on this website is entirely at your own risk, for which we shall not be liable. It shall be your own responsibility to ensure that any products, services, or information available through this website meet your specific requirements.</li>\n      </ul>\n      <p class=\"page-subheading\">Intellectual Property:</p>\n      <ul class=\"margin-btm-30\">\n      <li class=\"margin-btm-20\">This website contains material which is owned by or licensed to us. This material includes, but is not limited to, the design, layout, look, appearance, and graphics. Reproduction is prohibited other than in accordance with the copyright notice, which forms part of these terms and conditions.</li>\n      <li class=\"margin-btm-20\">All trademarks reproduced in this website, which are not the property of, or licensed to the operator, are acknowledged on the website.</li>\n      </ul>\n      <p class=\"page-subheading\">Privacy Policy:</p>\n      <ul class=\"margin-btm-30\">\n      <li class=\"margin-btm-20\">Your privacy is important to us. Please review our Privacy Policy to understand how we collect, use, and disclose information about you.</li>\n      </ul>\n      <p class=\"page-subheading\">Limitation of Liability:</p>\n      <ul class=\"margin-btm-30\">\n      <li class=\"margin-btm-20\">Neither we nor any third parties provide any warranty or guarantee as to the accuracy, timeliness, performance, completeness, or suitability of the information and materials found or offered on this website for any particular purpose. You acknowledge that such information and materials may contain inaccuracies or errors, and we expressly exclude liability for any such inaccuracies or errors to the fullest extent permitted by law.</li>\n      <li class=\"margin-btm-20\">Your use of any information or materials on this website is entirely at your own risk, for which we shall not be liable. It shall be your own responsibility to ensure that any products, services, or information available through this website meet your specific requirements.</li>\n      </ul>\n    ','legal-notice'),
(3,1,1,'Terms and Conditions','Our Terms and Conditions','conditions, terms, use, sell','\n      <h2 class=\"page-heading bottom-indent\">Terms and Conditions</h2>\n      <div>\n      <p style=\"border-left:2px solid #808080;padding-left:5px;\">This page contains demo content for illustrative purposes only. Any resemblance to actual products, services, or events is purely coincidental. Thank you for your understanding.</p>\n      <hr /></div>\n      <div>\n      <h3 class=\"page-subheading\"><strong>Cancellation Policy:</strong></h3>\n      <div>\n      <ul>\n      <li><span>Free Cancellation: Up to 48 hours before arrival for standard rates.</span></li>\n      <li><span>Bookings made with a non-refundable rate cannot be canceled or modified.</span></li>\n      <li><span>Cancellations within 24 hours of arrival will incur a fee of one night\'s stay.</span></li>\n      </ul>\n      </div>\n      <br />\n      <h3 class=\"page-subheading\"><strong>Changes to Bookings:</strong></h3>\n      <div>\n      <ul>\n      <li><span>A fee of $25 may apply to change your reservation dates after booking.</span></li>\n      <li><span>Changes to room type or number of guests are subject to availability at the hotel.</span></li>\n      </ul>\n      </div>\n      <br />\n      <h3 class=\"page-subheading\"><strong>Guest Responsibility:</strong></h3>\n      <div>\n      <ul>\n      <li><span>All guests must present a valid government-issued photo ID at check-in.</span></li>\n      <li><span>The maximum occupancy for the room type is 2 adults.</span></li>\n      <li><span>Smoking and alcohol are strictly prohibited in all guest rooms and public areas.</span></li>\n      </ul>\n      </div>\n      </div>\n    ','terms-and-conditions-of-use'),
(4,1,1,'About Us','Learn more about us','about us, informations','<h2 class=\"page-heading bottom-indent\">About Us</h2><div>\n      <p style=\"border-left:2px solid #7a9b62;padding-left:5px;\">My Farmhouse Hotel is a family-run farmhouse stay where nature meets comfort. We welcome guests who want to slow down, breathe fresh air, and enjoy simple pleasures.</p>\n      <hr /></div>\n      <div class=\"row\">\n      <div class=\"col-xs-12 col-sm-8\">\n      <div class=\"cms-block\">\n      <div class=\"margin-btm-30\">\n      <p class=\"dark\">Nestled among green fields, orchards and quiet country lanes, our farmhouse offers cozy rooms, home-style meals, and plenty of open space to relax.</p>\n      </div>\n      <div class=\"margin-btm-30\">\n      <p class=\"page-subheading\">Our Story</p>\n      <p>What began as a simple family farm has grown into a welcoming stay for travelers. We believe in warm hospitality, honest food, and the calm that only nature can bring.</p>\n      </div>\n      <div class=\"margin-btm-30\">\n      <p class=\"page-subheading\">Our Promise</p>\n      <p>Fresh air, comfort and care. From farm-fresh breakfasts to cozy rooms with garden views, everything here is made to help you unwind.</p>\n      </div>\n      <div class=\"margin-btm-30\">\n      <p class=\"page-subheading\">What You Will Find</p>\n      <p>Comfortable rooms and cottages, home-style dining with farm-grown produce, lush lawns for play and picnics, bonfire evenings, and warm, attentive hosts.</p>\n      </div>\n      <div class=\"margin-btm-30\">\n      <p class=\"page-subheading\">Our Team</p>\n      <p>Our small team lives on the farm too. We take pride in greeting each guest personally and making sure your stay feels like coming home.</p>\n      </div>\n      <div class=\"margin-btm-30\">\n      <p class=\"page-subheading\">Join Us</p>\n      <p>Escape the city for a day or a week. Book your stay at My Farmhouse Hotel and discover how peaceful life can be.</p>\n      </div>\n      </div>\n      </div>\n      <div class=\"col-xs-12 col-sm-4\">\n      <div class=\"cms-box\">\n      <p class=\"page-subheading\">Testimonials</p>\n      <div class=\"testimonials\">\n      <div class=\"inner\"><span class=\"before\">&ldquo;</span>We spent a weekend at the farmhouse and it was exactly what our family needed. The kids loved the open lawns and the meals were home-made and delicious. We will be back.<span class=\"after\">&rdquo;</span></div>\n      </div>\n      <p><strong class=\"dark\">Maya &amp; Raj</strong></p>\n      <div class=\"testimonials\">\n      <div class=\"inner\"><span class=\"before\">&ldquo;</span>A peaceful stay with lovely hosts. Waking up to birdsong and fresh air beats any city hotel. Highly recommended for a quiet break.<span class=\"after\">&rdquo;</span></div>\n      </div>\n      <p><strong class=\"dark\">Sarah Klein</strong></p>\n      </div>\n      </div>\n      </div>','about-us'),
(5,1,1,'Secure payment','Our secure payment method','secure payment, ssl, visa, mastercard, paypal','<h2 class=\"page-heading bottom-indent\">Secure payment</h2>\n      <div>\n      <p style=\"border-left:2px solid #808080;padding-left:5px;\">This page contains demo content for illustrative purposes only. Any resemblance to actual products, services, or events is purely coincidental. Thank you for your understanding.</p>\n      <hr /></div>\n      <div>We prioritize your security. All transactions made on our website are encrypted using Secure Socket Layer (SSL) technology to ensure your personal information and payment details are protected. We accept major credit cards and provide a secure environment for a seamless booking experience. For any inquiries regarding payment security, feel free to contact our customer support team.</div>\n    ','secure-payment'),
(6,1,1,'Our Properties | Rural UP','Browse the Rural UP farmstay collection: six demo stays across Awadh, Bundelkhand, Braj, Purvanchal, Rohilkhand and Kashi.','','Our PropertiesSix demonstration farmstays across Uttar Pradesh, each with its own region story, rooms and rates. Every listing is demo content with representative imagery — replace with client-approved material before production.Gomti Mango House — MalihabadOrchard Ridge Farmstay — JhansiYamuna Courtyard Farmstay — MathuraSarayu Fields Retreat — AyodhyaTerai Wetlands Farmstay — PilibhitGanga Looms Country House — VaranasiBack to search','our-properties');
/*!40000 ALTER TABLE `qlo_cms_lang` ENABLE KEYS */;

--
-- Table structure for table `qlo_cms_shop`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `qlo_cms_shop` (
  `id_cms` int(11) unsigned NOT NULL,
  `id_shop` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id_cms`,`id_shop`),
  KEY `id_shop` (`id_shop`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qlo_cms_shop`
--

/*!40000 ALTER TABLE `qlo_cms_shop` DISABLE KEYS */;
INSERT IGNORE INTO `qlo_cms_shop` VALUES
(1,1),
(2,1),
(3,1),
(4,1),
(5,1);
/*!40000 ALTER TABLE `qlo_cms_shop` ENABLE KEYS */;

--
-- Table structure for table `qlo_cms_category`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `qlo_cms_category` (
  `id_cms_category` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_parent` int(10) unsigned NOT NULL,
  `level_depth` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `active` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `date_add` datetime NOT NULL,
  `date_upd` datetime NOT NULL,
  `position` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_cms_category`),
  KEY `category_parent` (`id_parent`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qlo_cms_category`
--

/*!40000 ALTER TABLE `qlo_cms_category` DISABLE KEYS */;
INSERT IGNORE INTO `qlo_cms_category` VALUES
(1,0,1,1,'2026-08-05 18:22:32','2026-08-05 18:22:32',0);
/*!40000 ALTER TABLE `qlo_cms_category` ENABLE KEYS */;

--
-- Table structure for table `qlo_cms_category_lang`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `qlo_cms_category_lang` (
  `id_cms_category` int(10) unsigned NOT NULL,
  `id_lang` int(10) unsigned NOT NULL,
  `id_shop` int(10) unsigned NOT NULL DEFAULT 1,
  `name` varchar(128) NOT NULL,
  `description` text DEFAULT NULL,
  `link_rewrite` varchar(128) NOT NULL,
  `meta_title` varchar(128) DEFAULT NULL,
  `meta_keywords` varchar(255) DEFAULT NULL,
  `meta_description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_cms_category`,`id_shop`,`id_lang`),
  KEY `category_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qlo_cms_category_lang`
--

/*!40000 ALTER TABLE `qlo_cms_category_lang` DISABLE KEYS */;
INSERT IGNORE INTO `qlo_cms_category_lang` VALUES
(1,1,1,'Home','','home','','','');
/*!40000 ALTER TABLE `qlo_cms_category_lang` ENABLE KEYS */;

--
-- Table structure for table `qlo_cms_category_shop`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `qlo_cms_category_shop` (
  `id_cms_category` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_shop` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id_cms_category`,`id_shop`),
  KEY `id_shop` (`id_shop`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qlo_cms_category_shop`
--

/*!40000 ALTER TABLE `qlo_cms_category_shop` DISABLE KEYS */;
INSERT IGNORE INTO `qlo_cms_category_shop` VALUES
(1,1);
/*!40000 ALTER TABLE `qlo_cms_category_shop` ENABLE KEYS */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-08-13 20:35:31
