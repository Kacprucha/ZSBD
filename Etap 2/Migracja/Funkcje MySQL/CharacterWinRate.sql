DELIMITER $$
CREATE FUNCTION fn_GetCharacterWinRate(
    p_character_name VARCHAR(10)
)
RETURNS DECIMAL(5, 2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_total_fights INT;
    DECLARE v_victories INT;

    SELECT COUNT(*) INTO v_total_fights
    FROM combatlog WHERE Character_Name = p_character_name;

    IF v_total_fights = 0 THEN
        RETURN 0.00;
    END IF;

    SELECT COUNT(*) INTO v_victories
    FROM combatlog WHERE Character_Name = p_character_name AND Victory = 1; -- W MySQL, TRUE to 1

    RETURN (v_victories * 100.0 / v_total_fights);
END$$
DELIMITER ;