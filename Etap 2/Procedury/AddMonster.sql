SET search_path TO game_data;

CREATE PROCEDURE sp_CreateMonster(
    p_name VARCHAR(20),
    p_level INT,
    p_hit_points INT,
    p_attack INT,
    p_defence INT,
    p_exp_drop INT DEFAULT 0,
    p_gold_drop INT DEFAULT 0
) AS $$
BEGIN
    IF p_level < 1 OR p_level > 100 THEN
        RAISE EXCEPTION 'Level of the monster must be between 1 and 100.';
    END IF;

    IF p_hit_points <= 0 OR p_attack < 0 OR p_defence < 0 THEN
        RAISE EXCEPTION 'Statistics (Hit Points, Attack, Defence) must be positive values.';
    END IF;

    IF EXISTS (SELECT 1 FROM Monster WHERE Name = p_name) THEN
        RAISE EXCEPTION 'Monster with the name "%" already exists.', p_name;
    END IF;

    INSERT INTO Monster (Name, Level, HitPoints, Atack, Defence, ExpDrop, GoldDrop)
    VALUES (p_name, p_level, p_hit_points, p_attack, p_defence, p_exp_drop, p_gold_drop);

    RAISE NOTICE 'Monster "%" of level % has been successfully created.', p_name, p_level;
END;
$$ LANGUAGE plpgsql;