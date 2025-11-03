DELIMITER $$
CREATE PROCEDURE sp_AddCharacterToGuild(
    IN p_character_name VARCHAR(10),
    IN p_guild_name VARCHAR(20)
)
BEGIN
    DECLARE v_member_status_id INT;

    IF fn_CanCharacterJoinGuild(p_character_name, p_guild_name) = FALSE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Character does not meet the minimum level requirement to join this guild.';
    END IF;

    SELECT MemberStatusID INTO v_member_status_id
    FROM memberstatus WHERE MemberStatus = 'Member';

    IF v_member_status_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Member status "Member" for some reason does not exist in the database.';
    END IF;

    INSERT INTO GuildMember(Character_Name, Guild_Name, MemberStatus_StatusID, IsBand)
    VALUES (p_character_name, p_guild_name, v_member_status_id, 0);
END$$
DELIMITER ;