SET search_path TO game_data;

CREATE PROCEDURE sp_CreateRace(
    p_name VARCHAR(10),
    p_description VARCHAR(70),
    p_fight_bonus INT,
    p_magic_bonus INT
) AS $$
BEGIN
    IF p_fight_bonus < 0 OR p_magic_bonus < 0 THEN
        RAISE EXCEPTION 'Fight bonus and magic bonus cannot be negative.';
    END IF;

    PERFORM 1 FROM Race WHERE Name = p_name;
    IF FOUND THEN
        RAISE EXCEPTION 'Race with the name "%" already exists. No action taken.', p_name;
    END IF;

    INSERT INTO Race (Name, Description, FightBonus, MagicBonus)
    VALUES (p_name, p_description, p_fight_bonus, p_magic_bonus)
    ON CONFLICT (Name) DO NOTHING;

    RAISE NOTICE 'Race "%" has been successfully created.', p_name;
END;
$$ LANGUAGE plpgsql;