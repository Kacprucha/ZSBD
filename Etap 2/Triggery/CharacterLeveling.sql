SET search_path TO game_data;

CREATE FUNCTION fn_AutoLevelUp()
RETURNS TRIGGER AS $$
DECLARE
    v_exp_needed_for_next_level INT;
BEGIN
    IF NEW.Experience > OLD.Experience THEN
        v_exp_needed_for_next_level := NEW.Level * 1000;

        WHILE NEW.Experience >= v_exp_needed_for_next_level LOOP
            NEW.Level := NEW.Level + 1;
            NEW.Experience := NEW.Experience - v_exp_needed_for_next_level;
            NEW.MaxHitPoints := NEW.MaxHitPoints + 10;
            NEW.MaxMana := NEW.MaxMana + 5;

            RAISE NOTICE 'Character % lvel-up to % level!', NEW.Name, NEW.Level;

            v_exp_needed_for_next_level := NEW.Level * 1000;
        END LOOP;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_CharacterLevelUp
BEFORE UPDATE ON Character
FOR EACH ROW
EXECUTE FUNCTION fn_AutoLevelUp();