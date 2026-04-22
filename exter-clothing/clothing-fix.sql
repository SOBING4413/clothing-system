-- Migration file for EXISTING databases.
-- Fresh install: use clothing.sql only.

ALTER TABLE `exter_clothing`
    MODIFY COLUMN `customHeadModel` TINYINT(1) NOT NULL DEFAULT 0;

SET @has_unique_cid_slot := (
    SELECT COUNT(1)
    FROM information_schema.statistics
    WHERE table_schema = DATABASE()
      AND table_name = 'exter_outfits'
      AND index_name = 'unique_cid_slot'
);

SET @sql_add_unique_cid_slot := IF(
    @has_unique_cid_slot = 0,
    'ALTER TABLE `exter_outfits` ADD UNIQUE INDEX `unique_cid_slot` (`cid`, `slot`);',
    'SELECT 1;'
);

PREPARE stmt_add_unique_cid_slot FROM @sql_add_unique_cid_slot;
EXECUTE stmt_add_unique_cid_slot;
DEALLOCATE PREPARE stmt_add_unique_cid_slot;
