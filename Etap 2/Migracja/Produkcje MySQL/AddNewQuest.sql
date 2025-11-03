DELIMITER $$
CREATE PROCEDURE sp_CreateQuest(
    IN p_name VARCHAR(25),
    IN p_description VARCHAR(70),
    IN p_giver VARCHAR(15),
    IN p_gold_reward INT,
    IN p_location_name VARCHAR(15),
    IN p_reward_item_name VARCHAR(25)
)
BEGIN
    DECLARE v_location_id INT;
    DECLARE v_item_id INT DEFAULT NULL;

    SELECT LocationID INTO v_location_id FROM `location` WHERE Name = p_location_name;
    IF v_location_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Location with the specified name does not exist.';
    END IF;

    IF p_reward_item_name IS NOT NULL AND p_reward_item_name != '' THEN
        SELECT IteamID INTO v_item_id FROM iteam WHERE Name = p_reward_item_name;
        IF v_item_id IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Item with the specified name does not exist.';
        END IF;
    END IF;

    INSERT INTO quest(Name, Description, Giver, GoldReward, Location_LocationID, Iteam_IteamID)
    VALUES (p_name, p_description, p_giver, p_gold_reward, v_location_id, v_item_id);
END$$
DELIMITER ;