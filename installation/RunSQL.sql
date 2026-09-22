CREATE TABLE `mms_notebook` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`charID` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb3_general_ci',
	`title` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb3_general_ci',
	`message` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb3_general_ci',
	UNIQUE INDEX `id` (`id`) USING BTREE
)
COLLATE='utf8mb3_general_ci'
ENGINE=InnoDB
;
