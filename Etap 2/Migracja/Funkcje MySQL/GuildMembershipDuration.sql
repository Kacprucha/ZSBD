DELIMITER $$
CREATE FUNCTION fn_GetGuildMembershipDuration(
    p_character_name VARCHAR(10)
)
RETURNS VARCHAR(255) 
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_joined_at DATETIME;
    DECLARE v_days INT;
    DECLARE v_hours INT;
    DECLARE v_minutes INT;
    DECLARE v_total_seconds INT;
    DECLARE v_result VARCHAR(255);

    SELECT JoinedAt INTO v_joined_at
    FROM guildmember
    WHERE Character_Name = p_character_name;

    IF v_joined_at IS NULL THEN
        RETURN 'Not in a guild';
    END IF;

    SET v_total_seconds = TIMESTAMPDIFF(SECOND, v_joined_at, NOW());

    SET v_days = FLOOR(v_total_seconds / (24 * 3600));
    SET v_total_seconds = v_total_seconds % (24 * 3600);
    SET v_hours = FLOOR(v_total_seconds / 3600);
    SET v_total_seconds = v_total_seconds % 3600;
    SET v_minutes = FLOOR(v_total_seconds / 60);

    SET v_result = CONCAT(v_days, ' days, ', v_hours, ' hours, ', v_minutes, ' minutes');

    RETURN v_result;
END$$
DELIMITER ;