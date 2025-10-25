SET search_path TO game_data;

CREATE PROCEDURE sp_CreateNPC(
    p_character_name VARCHAR(10),
    p_race_name VARCHAR(10),
    p_class_name VARCHAR(10),
    p_health INT DEFAULT 0,
    p_mana INT DEFAULT 0,
    p_level INT DEFAULT 1,
    p_gold INT DEFAULT 50,
    p_experience INT DEFAULT 0,
    p_iteams INT[] DEFAULT ARRAY[]::INT[]
) AS $$
DECLARE
    v_base_health INT;
    v_base_mana INT;
    v_iteam_id INT;
    v_item_count INT;
BEGIN
    PERFORM Name FROM Character WHERE Name = p_character_name;
    IF FOUND THEN
        RAISE EXCEPTION 'Character "%" already exists. Choose a different name.', p_character_name;
    END IF;

    SELECT BaseHealth, BaseMana INTO v_base_health, v_base_mana FROM Class WHERE Name = p_class_name;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Class "%" not not exist. Cannot create character.', p_class_name;
    END IF;

    IF cardinality(p_iteams) > 0 THEN
        SELECT COUNT(*) INTO v_item_count FROM Iteam WHERE IteamID = ANY(p_iteams);
        IF v_item_count <> cardinality(p_iteams) THEN
            RAISE EXCEPTION 'One or more items in the provided list do not exist. Cannot create character with invalid items.';
        END IF;
    END IF;

    IF p_health >= v_base_health THEN
        v_base_health := p_health;
    END IF;

    IF p_mana >= v_base_mana THEN
        v_base_mana := p_mana;
    END IF;

    INSERT INTO Character (Name, IsNPC, Level, MaxHitPoints, MaxMana, Gold, Experience, Player_Userame)
    VALUES (
        p_character_name,
        TRUE,          
        p_level,              
        v_base_health,  
        v_base_mana,    
        p_gold,             
        p_experience,              
        NULL
    );

    INSERT INTO Race_Character (Race_Name, Character_Name)
    VALUES (p_race_name, p_character_name);

    INSERT INTO Character_Class (Character_Name, Class_Name)
    VALUES (p_character_name, p_class_name);

    FOREACH v_iteam_id IN ARRAY p_iteams LOOP
        INSERT INTO Iteam_Character (Iteam_IteamID, Character_Name)
        VALUES (v_iteam_id, p_character_name);
    END LOOP;

    RAISE NOTICE 'NPC % was successfully created.', p_character_name;
END;
$$ LANGUAGE plpgsql;