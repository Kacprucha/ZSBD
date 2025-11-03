DELIMITER $$
CREATE PROCEDURE sp_CreateGuild(
    IN p_guild_name VARCHAR(20),
    IN p_leader_name VARCHAR(10),
    IN p_min_level INT
)
BEGIN
    DECLARE v_leader_exists INT DEFAULT 0;
    DECLARE v_leader_in_guild INT DEFAULT 0;
    DECLARE v_member_status_id INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    SELECT COUNT(*) INTO v_leader_exists FROM `character` WHERE Name = p_leader_name AND IsNPC = 0;
    IF v_leader_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Character does not exist or is an NPC and cannot lead a guild.';
    END IF;

    SELECT COUNT(*) INTO v_leader_in_guild FROM guildmember WHERE Character_Name = p_leader_name;
    IF v_leader_in_guild > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Character is already a member of a guild and cannot lead another guild.';
    END IF;

    SELECT MemberStatusID INTO v_member_status_id FROM memberstatus WHERE MemberStatus = 'Leader';
    IF v_member_status_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Member status "Leader" some how does not exist in the database.';
    END IF;

    START TRANSACTION;

    INSERT INTO guild (Name, Leader_Name, MinLevel)
    VALUES (p_guild_name, p_leader_name, p_min_level);

    INSERT INTO guildmember (Character_Name, Guild_Name, MemberStatus_StatusID, IsBand, Contribution)
    VALUES (p_leader_name, p_guild_name, v_member_status_id, 0, 0);

    COMMIT;
END$$
DELIMITER ;