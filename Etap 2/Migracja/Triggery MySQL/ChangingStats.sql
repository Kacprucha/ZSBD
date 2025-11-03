-- INSERT Trigger
DELIMITER $$
CREATE TRIGGER trg_character_stats_check
BEFORE INSERT ON `character`
FOR EACH ROW
BEGIN
    DECLARE v_base_health INT;
    DECLARE v_base_mana INT;
    DECLARE v_class_name VARCHAR(10);

    SELECT Class_Name INTO v_class_name
    FROM character_class WHERE Character_Name = NEW.Name;
    
    SELECT BaseHealth, BaseMana INTO v_base_health, v_base_mana
    FROM class WHERE Name = v_class_name;

    IF NEW.MaxHitPoints < v_base_health OR NEW.MaxMana < v_base_mana THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Character stats cannot be lower than class base stats.';
    END IF;
END$$
DELIMITER ;

-- UPDATE Trigger
DELIMITER $$
CREATE TRIGGER trg_character_stats_check_update
BEFORE UPDATE ON `character`
FOR EACH ROW
BEGIN
    DECLARE v_base_health INT;
    DECLARE v_base_mana INT;
    DECLARE v_class_name VARCHAR(10);

    IF NEW.MaxHitPoints <> OLD.MaxHitPoints OR NEW.MaxMana <> OLD.MaxMana THEN
        SELECT Class_Name INTO v_class_name
        FROM character_class WHERE Character_Name = NEW.Name;
        
        SELECT BaseHealth, BaseMana INTO v_base_health, v_base_mana
        FROM class WHERE Name = v_class_name;

        IF NEW.MaxHitPoints < v_base_health OR NEW.MaxMana < v_base_mana THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Character stats cannot be lower than class base stats.';
        END IF;
    END IF;
END$$
DELIMITER ;