DELIMITER $$
CREATE TRIGGER trg_CharacterLevelUp
BEFORE UPDATE ON `character`
FOR EACH ROW
BEGIN
    DECLARE v_exp_needed_for_next_level INT;

    IF NEW.Experience > OLD.Experience THEN
        SET v_exp_needed_for_next_level = NEW.Level * 1000;

        WHILE NEW.Experience >= v_exp_needed_for_next_level DO
            SET NEW.Level = NEW.Level + 1;
            SET NEW.Experience = NEW.Experience - v_exp_needed_for_next_level;
            SET NEW.MaxHitPoints = NEW.MaxHitPoints + 10;
            SET NEW.MaxMana = NEW.MaxMana + 5;

            SET v_exp_needed_for_next_level = NEW.Level * 1000;
        END WHILE;
    END IF;
END$$
DELIMITER ;