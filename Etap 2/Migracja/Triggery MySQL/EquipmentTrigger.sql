DELIMITER $$
CREATE TRIGGER trg_InventoryLimitCheck
BEFORE INSERT ON iteam_character
FOR EACH ROW
BEGIN
    DECLARE v_item_count INT;
    DECLARE v_limit INT DEFAULT 50;

    SELECT COUNT(*) INTO v_item_count
    FROM iteam_character WHERE Character_Name = NEW.Character_Name;

    IF v_item_count >= v_limit THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot add item. Character inventory is full.';
    END IF;
END$$
DELIMITER ;