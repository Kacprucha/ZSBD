DELIMITER $$
CREATE PROCEDURE sp_CreateCharacter(
    IN p_player_username VARCHAR(10),
    IN p_character_name VARCHAR(10),
    IN p_race_names_csv TEXT,
    IN p_class_name VARCHAR(10)
)
BEGIN
    DECLARE v_base_health INT;
    DECLARE v_base_mana INT;
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_race_name VARCHAR(10);
    DECLARE race_cursor CURSOR FOR
        SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(p_race_names_csv, ',', n.n), ',', -1)) AS race
        FROM (
            SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
        ) n
        WHERE n.n <= 1 + LENGTH(p_race_names_csv) - LENGTH(REPLACE(p_race_names_csv, ',', ''));

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    IF p_race_names_csv IS NULL OR p_race_names_csv = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'At least one race must be specified.';
    END IF;

    SELECT BaseHealth, BaseMana INTO v_base_health, v_base_mana
    FROM class WHERE Name = p_class_name;
    
    INSERT INTO `character` (Name, IsNPC, Level, MaxHitPoints, MaxMana, Gold, Experience, Player_Userame)
    VALUES (p_character_name, FALSE, 1, v_base_health, v_base_mana, 50, 0, p_player_username);

    INSERT INTO character_class (Character_Name, Class_Name)
    VALUES (p_character_name, p_class_name);

    OPEN race_cursor;
    read_loop: LOOP
        FETCH race_cursor INTO v_race_name;
        IF done THEN
            LEAVE read_loop;
        END IF;
        INSERT INTO race_character (Race_Name, Character_Name) VALUES (v_race_name, p_character_name);
    END LOOP;
    CLOSE race_cursor;
END$$
DELIMITER ;