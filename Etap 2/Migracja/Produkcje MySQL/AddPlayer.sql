DELIMITER $$
CREATE PROCEDURE sp_RegisterPlayer(
    IN p_username VARCHAR(10),
    IN p_email VARCHAR(20),
    IN p_password_text VARCHAR(255) 
)
BEGIN
    DECLARE v_active_status_id INT;
    DECLARE v_user_exists INT DEFAULT 0;

    SELECT COUNT(*) INTO v_user_exists FROM player WHERE Username = p_username;
    IF v_user_exists > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Username is already taken. Choose a different username.';
    END IF;

    SELECT StatusID INTO v_active_status_id FROM accountstatus WHERE StatusName = 'Active';
    IF v_active_status_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Somehow, the "Active" account status does not exist. Cannot register new player.';
    END IF;

    INSERT INTO player (Username, Email, Password_hash, AccountStatus_StatusID)
    VALUES (p_username, p_email, p_password_text, v_active_status_id);

END$$

DELIMITER ;