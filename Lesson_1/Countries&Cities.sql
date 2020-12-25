CREATE TABLE `city` (
  `id` int unsigned NOT NULL,
  `city_name` varchar(60) NOT NULL,
  `region_id` int unsigned NOT NULL,
  `district_id` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `region_id_idx` (`region_id`),
  KEY `disctrict_id_idx` (`district_id`),
  CONSTRAINT `disctrict_id` FOREIGN KEY (`district_id`) REFERENCES `district` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `region_id` FOREIGN KEY (`region_id`) REFERENCES `region` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE `country` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `country_name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `country_name_UNIQUE` (`country_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE `district` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `district_name` varchar(120) NOT NULL,
  `region_id` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `region_id_idx` (`region_id`),
  KEY `region_idx` (`region_id`),
  CONSTRAINT `region` FOREIGN KEY (`region_id`) REFERENCES `region` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE `region` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `region_name` varchar(120) NOT NULL,
  `country_id` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `country_id_idx` (`country_id`),
  CONSTRAINT `country_id` FOREIGN KEY (`country_id`) REFERENCES `country` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
