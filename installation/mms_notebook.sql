CREATE TABLE `mms_notebook` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`identifier` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`titel` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`text` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=3
;
