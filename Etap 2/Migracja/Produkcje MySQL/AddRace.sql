DELIMITER $$
CREATE PROCEDURE sp_CreateRace(
    IN p_name VARCHAR(10),
    IN p_description VARCHAR(70),
    IN p_fight_bonus INT,
    IN p_magic_bonus INT
)
BEGIN
    DECLARE v_race_exists INT DEFAULT 0;

    IF p_fight_bonus < 0 OR p_magic_bonus < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Fight bonus and magic bonus cannot be negative.';
    END IF;

    SELECT COUNT(*) INTO v_race_exists
    FROM Race WHERE Name = p_name;

    IF v_race_exists > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Race with this name already exists. No action taken.';
    END IF;

    INSERT INTO race (Name, Description, FightBonus, MagicBonus)
    VALUES (p_name, p_description, p_fight_bonus, p_magic_bonus);
END$$
DELIMITER ;