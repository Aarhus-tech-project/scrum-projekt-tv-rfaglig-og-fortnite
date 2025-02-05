USE classroomdatabase;

CREATE TABLE `rooms` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(64) NOT NULL,
  `lat` DOUBLE NOT NULL,
  `lon` DOUBLE NOT NULL,
  `alt` DOUBLE NOT NULL,
  `level` INT NOT NULL,
  `site` VARCHAR(128) DEFAULT NULL,
  PRIMARY KEY (`id`)
)