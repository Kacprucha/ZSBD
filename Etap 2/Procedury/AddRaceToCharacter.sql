SET search_path TO game_data;

CREATE PROCEDURE sp_AddRaceToCharacter(
    p_character_name VARCHAR(10),
    p_new_race_name VARCHAR(10)
) AS $$
DECLARE
    v_character_exists BOOLEAN;
    v_race_exists BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM Character WHERE Name = p_character_name) INTO v_character_exists;
    SELECT EXISTS(SELECT 1 FROM Race WHERE Name = p_new_race_name) INTO v_race_exists;

    IF NOT v_character_exists THEN
        RAISE EXCEPTION 'Character with name "%" does not exist.', p_character_name;
    END IF;

    IF NOT v_race_exists THEN
        RAISE EXCEPTION 'Race with name "%" does not exist.', p_new_race_name;
    END IF;

    PERFORM 1 FROM Race_Character 
    WHERE Character_Name = p_character_name AND Race_Name = p_new_race_name;
    IF FOUND THEN
        RAISE EXCEPTION 'Character "%" already has race heritage "%".', p_character_name, p_new_race_name;
    END IF;

    INSERT INTO Race_Character (Race_Name, Character_Name)
    VALUES (p_new_race_name, p_character_name)
    ON CONFLICT (Race_Name, Character_Name) DO NOTHING;

    RAISE NOTICE 'Race heritage "%" has been successfully added to character "%".', p_new_race_name, p_character_name;
END;
$$ LANGUAGE plpgsql;