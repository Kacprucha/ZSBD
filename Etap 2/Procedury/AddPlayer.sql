SET search_path TO game_data;

CREATE PROCEDURE sp_RegisterPlayer(
    p_username VARCHAR(10),
    p_email VARCHAR(20),
    p_password_text VARCHAR 
) AS $$
DECLARE
    v_active_status_id INT;
BEGIN
    PERFORM Username FROM Player WHERE Username = p_username;
    IF FOUND THEN
        RAISE EXCEPTION 'Username "%" is already taken. Choose a different username.', p_username;
    END IF;

    SELECT StatusID INTO v_active_status_id FROM AccountStatus WHERE StatusName = 'Active';
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Somehow, the "Active" account status does not exist. Cannot register new player.';
    END IF;

    INSERT INTO Player (Username, Email, Password_hash, AccountStatus_StatusID)
    VALUES (p_username, p_email, convert_to(p_password_text, 'UTF8'), v_active_status_id);

    RAISE NOTICE 'Player "%" has been successfully registered.', p_username;
END;
$$ LANGUAGE plpgsql;