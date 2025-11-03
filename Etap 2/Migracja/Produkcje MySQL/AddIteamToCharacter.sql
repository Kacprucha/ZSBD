DELIMITER $$
CREATE PROCEDURE sp_AdminGiveItem(
    IN p_character_name VARCHAR(10),
    IN p_item_id INT,
    IN p_quantity INT
)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE v_item_exists INT DEFAULT 0;
    DECLARE v_character_exists INT DEFAULT 0;

    SELECT COUNT(*) INTO v_item_exists FROM iteam WHERE IteamID = p_item_id;
    IF v_item_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Item with the specified ID does not exist.';
    END IF;

    SELECT COUNT(*) INTO v_character_exists FROM `character` WHERE Name = p_character_name;
    IF v_character_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Character with the specified name does not exist.';
    END IF;
    
    WHILE i <= p_quantity DO
        INSERT INTO iteam_character(Character_Name, Iteam_IteamID)
        VALUES (p_character_name, p_item_id);
        SET i = i + 1;
    END WHILE;
END$$
DELIMITER ;