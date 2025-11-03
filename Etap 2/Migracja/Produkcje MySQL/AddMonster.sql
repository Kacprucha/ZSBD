DELIMITER $$
CREATE PROCEDURE sp_CreateMonster(
    IN p_name VARCHAR(20),
    IN p_level INT,
    IN p_hit_points INT,
    IN p_attack INT,
    IN p_defence INT,
    IN p_exp_drop INT,
    IN p_gold_drop INT
)
BEGIN
    DECLARE v_monster_exists INT DEFAULT 0;

    IF p_level < 1 OR p_level > 100 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Level of the monster must be between 1 and 100.';
    END IF;

    IF p_hit_points <= 0 OR p_attack < 0 OR p_defence < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Statistics (Hit Points, Attack, Defence) must be positive values.';
    END IF;

    SELECT COUNT(*) INTO v_monster_exists
    FROM monster WHERE Name = p_name;

    IF v_monster_exists > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Monster with this name already exists.';
    END IF;

    INSERT INTO monster (Name, Level, HitPoints, Atack, Defence, ExpDrop, GoldDrop)
    VALUES (p_name, p_level, p_hit_points, p_attack, p_defence, p_exp_drop, p_gold_drop);

END$$
DELIMITER ;