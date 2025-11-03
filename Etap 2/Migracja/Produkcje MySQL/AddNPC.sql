DELIMITER $$
CREATE PROCEDURE sp_CreateNPC(
    IN p_character_name VARCHAR(10),
    IN p_race_name VARCHAR(10),
    IN p_class_name VARCHAR(10),
    IN p_health INT,
    IN p_mana INT,
    IN p_level INT,
    IN p_gold INT,
    IN p_experience INT,
    IN p_items_csv TEXT 
)
BEGIN
    DECLARE v_base_health INT;
    DECLARE v_base_mana INT;
    DECLARE v_final_health INT;
    DECLARE v_final_mana INT;
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_item_id INT;
    DECLARE item_cursor CURSOR FOR
        SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(p_items_csv, ',', n.n), ',', -1)) AS item_id
        FROM (
            SELECT a.N + b.N * 10 + 1 n
            FROM (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a
            CROSS JOIN (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b
        ) n
        WHERE n.n <= 1 + LENGTH(p_items_csv) - LENGTH(REPLACE(p_items_csv, ',', ''));
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;

    IF EXISTS (SELECT 1 FROM `character` WHERE Name = p_character_name) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Character with this name already exists.';
    END IF;

    SELECT BaseHealth, BaseMana INTO v_base_health, v_base_mana
    FROM class WHERE Name = p_class_name;
    IF v_base_health IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Class with the specified name does not exist.';
    END IF;

    SET v_final_health = GREATEST(v_base_health, p_health);
    SET v_final_mana = GREATEST(v_base_mana, p_mana);
    
    START TRANSACTION;

    INSERT INTO `character` (Name, IsNPC, Level, MaxHitPoints, MaxMana, Gold, Experience, Player_Userame)
    VALUES (p_character_name, 1, p_level, v_final_health, v_final_mana, p_gold, p_experience, NULL);

    INSERT INTO race_character (Race_Name, Character_Name) VALUES (p_race_name, p_character_name);
    INSERT INTO character_class (Character_Name, Class_Name) VALUES (p_character_name, p_class_name);

    IF p_items_csv IS NOT NULL AND p_items_csv != '' THEN
        OPEN item_cursor;
        read_loop: LOOP
            FETCH item_cursor INTO v_item_id;
            IF done THEN
                LEAVE read_loop;
            END IF;
            INSERT INTO iteam_character (Iteam_IteamID, Character_Name) VALUES (v_item_id, p_character_name);
        END LOOP;
        CLOSE item_cursor;
    END IF;

    COMMIT;
END$$
DELIMITER ;