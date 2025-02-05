CREATE TABLE `users` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(64) NOT NULL,
    `email` VARCHAR(128) NOT NULL,
    `passwordhash` VARCHAR(128) NOT NULL,
    `createdat` DATETIME NOT NULL,
    PRIMARY KEY (`id`)
)