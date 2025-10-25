SET search_path TO game_data;

CREATE PROCEDURE sp_CreateSkill(
    p_name VARCHAR(20),
    p_description VARCHAR(70),
    p_damage INT DEFAULT 0,
    p_cooldown INT DEFAULT 0,
    p_mana_cost INT DEFAULT 0
) AS $$
BEGIN
    IF p_damage < 0 OR p_cooldown < 0 OR p_mana_cost < 0 THEN
        RAISE EXCEPTION 'Skill attributes cannot be negative.';
    END IF;

    PERFORM 1 FROM Skill WHERE Name = p_name;
    IF FOUND THEN
        RAISE EXCEPTION 'Skill with the name "%" already exists. No action taken.', p_name;
    END IF;

    INSERT INTO Skill (Name, Description, Damage, CoolDown, ManaCost)
    VALUES (p_name, p_description, p_damage, p_cooldown, p_mana_cost);

    RAISE NOTICE 'Skill "%" has been successfully created.', p_name;
END;
$$ LANGUAGE plpgsql;