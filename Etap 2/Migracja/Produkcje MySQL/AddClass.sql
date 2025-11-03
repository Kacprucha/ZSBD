DELIMITER $$
CREATE PROCEDURE sp_CreateClass(
    IN p_name VARCHAR(10),
    IN p_description VARCHAR(70),
    IN p_base_health INT,
    IN p_base_mana INT
)
BEGIN
    DECLARE v_class_exists INT DEFAULT 0;

    IF p_base_health <= 0 OR p_base_mana < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Base health must be positive and base mana cannot be negative.';
    END IF;

    SELECT COUNT(*) INTO v_class_exists
    FROM class WHERE Name = p_name;

    IF v_class_exists > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Class with this name already exists. No action taken.';
    END IF;

    INSERT INTO class (Name, Description, BaseHealth, BaseMana)
    VALUES (p_name, p_description, p_base_health, p_base_mana);
END$$
DELIMITER ;