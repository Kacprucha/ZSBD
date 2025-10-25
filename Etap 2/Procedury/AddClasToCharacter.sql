SET search_path TO game_data;

CREATE PROCEDURE sp_AddClassToCharacter(
    p_character_name VARCHAR(10),
    p_new_class_name VARCHAR(10)
) AS $$
DECLARE
    v_character_exists BOOLEAN;
    v_class_exists BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM Character WHERE Name = p_character_name) INTO v_character_exists;
    SELECT EXISTS(SELECT 1 FROM Class WHERE Name = p_new_class_name) INTO v_class_exists;

    IF NOT v_character_exists THEN
        RAISE EXCEPTION 'Character with name "%" does not exist.', p_character_name;
    END IF;

    IF NOT v_class_exists THEN
        RAISE EXCEPTION 'Class with name "%" does not exist.', p_new_class_name;
    END IF;

    PERFORM 1 FROM Character_Class 
    WHERE Character_Name = p_character_name AND Class_Name = p_new_class_name;
    IF FOUND THEN
        RAISE EXCEPTION 'Character "%" already has class "%". No action taken.', p_character_name, p_new_class_name;
    END IF;

    INSERT INTO Character_Class (Character_Name, Class_Name)
    VALUES (p_character_name, p_new_class_name)
    ON CONFLICT (Character_Name, Class_Name) DO NOTHING;

    RAISE NOTICE 'Class "%" has been successfully added to character "%".', p_new_class_name, p_character_name;
END;
$$ LANGUAGE plpgsql;