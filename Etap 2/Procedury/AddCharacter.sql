SET search_path TO game_data;

CREATE PROCEDURE sp_CreateCharacter(
    p_player_username VARCHAR(10),
    p_character_name VARCHAR(10),
    p_race_names VARCHAR(10)[],
    p_class_name VARCHAR(10)
) AS $$
DECLARE
    v_base_health INT;
    v_base_mana INT;
    v_race_name VARCHAR;
BEGIN
    PERFORM Name FROM game_data.Character WHERE Name = p_character_name;
    IF FOUND THEN
        RAISE EXCEPTION 'Character "%" already exists. Choose a different name.', p_character_name;
    END IF;

    SELECT BaseHealth, BaseMana INTO v_base_health, v_base_mana FROM game_data.Class WHERE Name = p_class_name;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Class "%" not not exist. Cannot create character.', p_class_name;
    END IF;

    IF cardinality(p_race_names) = 0 THEN
        RAISE EXCEPTION 'At least one race must be specified to create a character.';
    END IF;

    FOREACH v_race_name IN ARRAY p_race_names
    LOOP
        IF NOT EXISTS (SELECT 1 FROM game_data.Race WHERE Name = v_race_name) THEN
            RAISE EXCEPTION 'Race "%" does not exist. Cannot create character with invalid races.', v_race_name;
        END IF;
    END LOOP;

    INSERT INTO game_data.Character (Name, IsNPC, Level, MaxHitPoints, MaxMana, Gold, Experience, Player_Userame)
    VALUES (
        p_character_name,
        FALSE,          
        1,              
        v_base_health,  
        v_base_mana,    
        50,             
        0,              
        p_player_username
    );

    INSERT INTO game_data.Character_Class (Character_Name, Class_Name)
    VALUES (p_character_name, p_class_name);

    FOREACH v_race_name IN ARRAY p_race_names
    LOOP
        INSERT INTO game_data.Race_Character (Race_Name, Character_Name)
        VALUES (v_race_name, p_character_name);
    END LOOP;

    RAISE NOTICE 'Character % was successfully created for player %.', p_character_name, p_player_username;
END;
$$ LANGUAGE plpgsql;