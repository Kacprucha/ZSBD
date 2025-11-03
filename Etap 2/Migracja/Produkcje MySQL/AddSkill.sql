DELIMITER $$
CREATE PROCEDURE sp_CreateSkill(
    IN p_name VARCHAR(20),
    IN p_description VARCHAR(70),
    IN p_damage INT,
    IN p_cooldown INT,
    IN p_mana_cost INT
)
BEGIN
    DECLARE v_skill_exists INT DEFAULT 0;

    IF p_damage < 0 OR p_cooldown < 0 OR p_mana_cost < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Skill attributes cannot be negative.';
    END IF;

    SELECT COUNT(*) INTO v_skill_exists
    FROM skill WHERE Name = p_name;

    IF v_skill_exists > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Skill with this name already exists. No action taken.';
    END IF;

    INSERT INTO skill (Name, Description, Damage, CoolDown, ManaCost)
    VALUES (p_name, p_description, p_damage, p_cooldown, p_mana_cost);
END$$
DELIMITER ;