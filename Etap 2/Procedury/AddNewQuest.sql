SET search_path TO game_data;

CREATE PROCEDURE sp_CreateQuest(
    p_name VARCHAR, p_description VARCHAR, p_giver VARCHAR,
    p_gold_reward INT, p_location_name VARCHAR, p_reward_item_name VARCHAR DEFAULT NULL
) AS $$
DECLARE
    v_location_id INT;
    v_item_id INT;
BEGIN
    SELECT LocationID INTO v_location_id FROM Location WHERE Name = p_location_name;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Location of the name "%" does not exist.', p_location_name;
    END IF;

    IF p_reward_item_name IS NOT NULL THEN
        SELECT IteamID INTO v_item_id FROM Iteam WHERE Name = p_reward_item_name;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Iteam of the name "%" does not exist.', p_reward_item_name;
        END IF;
    END IF;

    INSERT INTO Quest(Name, Description, Giver, GoldReward, Location_LocationID, Iteam_IteamID)
    VALUES (p_name, p_description, p_giver, p_gold_reward, v_location_id, v_item_id);

    RAISE NOTICE 'Quest "%" has been successfully created.', p_name;
END;
$$ LANGUAGE plpgsql;