DELIMITER $$
CREATE PROCEDURE sp_AddRaceToCharacter(
    IN p_character_name VARCHAR(10),
    IN p_new_race_name VARCHAR(10)
)
BEGIN
    DECLARE v_character_exists INT DEFAULT 0;
    DECLARE v_race_exists INT DEFAULT 0;

    SELECT COUNT(*) INTO v_character_exists FROM `Character` WHERE Name = p_character_name;
    IF v_character_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Character with the specified name does not exist.';
    END IF;

    SELECT COUNT(*) INTO v_race_exists FROM Race WHERE Name = p_new_race_name;
    IF v_race_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Race with the specified name does not exist.';
    END IF;

    INSERT IGNORE INTO race_character (Race_Name, Character_Name)
    VALUES (p_new_race_name, p_character_name);

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Character already has this race heritage.';
    END IF;
END$$
DELIMITER ;