SET search_path TO game_data;

CREATE PROCEDURE sp_CreateClass(
    p_name VARCHAR(10),
    p_description VARCHAR(70),
    p_base_health INT,
    p_base_mana INT
) AS $$
BEGIN
    IF p_base_health <= 0 OR p_base_mana < 0 THEN
        RAISE EXCEPTION 'Base health must be positive and base mana cannot be negative.';
    END IF;

    PERFORM 1 FROM Class WHERE Name = p_name;
    IF FOUND THEN
        RAISE EXCEPTION 'Class with the name "%" already exists. No action taken.', p_name;
    END IF;

    INSERT INTO Class (Name, Description, BaseHealth, BaseMana)
    VALUES (p_name, p_description, p_base_health, p_base_mana)
    ON CONFLICT (Name) DO NOTHING;

    RAISE NOTICE 'Class "%" has been successfully created.', p_name;
END;
$$ LANGUAGE plpgsql;