SET search_path TO game_data;

CREATE PROCEDURE sp_AdminGiveItem(p_character_name VARCHAR, p_item_id INT, p_quantity INT DEFAULT 1)
AS $$
DECLARE
    i INT;
BEGIN
    PERFORM 1 FROM Iteam WHERE IteamID = p_item_id;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Item with ID % does not exist.', p_item_id;
    END IF;

    PERFORM 1 FROM Character WHERE Name = p_character_name;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Character with name "%" does not exist.', p_character_name;
    END IF;

    FOR i IN 1..p_quantity LOOP
        INSERT INTO Iteam_Character(Character_Name, Iteam_IteamID)
        VALUES (p_character_name, p_item_id);
    END LOOP;

    RAISE NOTICE 'Gave % of item ID % to character "%".', p_quantity, p_item_id, p_character_name;
END;
$$ LANGUAGE plpgsql;
