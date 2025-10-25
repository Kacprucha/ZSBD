SET search_path TO game_data;

CREATE FUNCTION fn_CheckCharacterStats()
RETURNS TRIGGER AS $$
DECLARE
    v_base_health INT;
    v_base_mana INT;
    v_class_name VARCHAR;
BEGIN
    IF (TG_OP = 'UPDATE') THEN
        IF NEW.MaxHitPoints = OLD.MaxHitPoints AND NEW.MaxMana = OLD.MaxMana THEN
            RETURN NEW;
        END IF;
    END IF;

    SELECT Class_Name INTO v_class_name
    FROM game_data.Character_Class WHERE Character_Name = NEW.Name;

    SELECT BaseHealth, BaseMana INTO v_base_health, v_base_mana
    FROM game_data.Class WHERE Name = v_class_name;
    
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