DELIMITER $$
CREATE PROCEDURE sp_AddClassToCharacter(
    IN p_character_name VARCHAR(10),
    IN p_new_class_name VARCHAR(10)
)
BEGIN
    DECLARE v_character_exists INT DEFAULT 0;
    DECLARE v_class_exists INT DEFAULT 0;

    SELECT COUNT(*) INTO v_character_exists FROM `character` WHERE Name = p_character_name;
    IF v_character_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Character with the specified name does not exist.';
    END IF;

    SELECT COUNT(*) INTO v_class_exists FROM class WHERE Name = p_new_class_name;
    IF v_race_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Class with the specified name does not exist.';
    END IF;

    INSERT IGNORE INTO character_class (Character_Name, Class_Name)
    VALUES (p_character_name, p_new_class_name);

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Character already has this class. No action taken.';
    END IF;
END$$
DELIMITER ;