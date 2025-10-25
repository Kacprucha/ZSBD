SET search_path TO game_data;

CREATE FUNCTION fn_CheckCharacterStats()
RETURNS TRIGGER AS $$
DECLARE
    v_base_health INT;
    v_base_mana INT;
    v_class_name VARCHAR;
BEGIN
    SELECT Class_Name INTO v_class_name
    FROM Character_Class WHERE Character_Name = NEW.Name;

    SELECT BaseHealth, BaseMana INTO v_base_health, v_base_mana
    FROM Class WHERE Name = v_class_name;

    IF NEW.MaxHitPoints < v_base_health OR NEW.MaxMana < v_base_mana THEN
        RAISE EXCEPTION 'Statistisc of character (HP: %, Mana: %) canot be lower then base value for the character class (HP: %, Mana: %).',
            NEW.MaxHitPoints, NEW.MaxMana, v_base_health, v_base_mana;
    END IF;

    RETURN NEW; 
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_CharacterStatsCheck
BEFORE INSERT OR UPDATE ON Character
FOR EACH ROW
EXECUTE FUNCTION fn_CheckCharacterStats();