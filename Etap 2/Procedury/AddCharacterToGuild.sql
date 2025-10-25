SET search_path TO game_data;

CREATE PROCEDURE sp_AddCharacterToGuild(p_character_name VARCHAR, p_guild_name VARCHAR)
AS $$
DECLARE
    v_member_status_id INT;
BEGIN
    IF NOT fn_CanCharacterJoinGuild(p_character_name, p_guild_name) THEN
        RAISE EXCEPTION 'Character "%" does not meet the requirements to join guild "%".', p_character_name, p_guild_name;
    END IF;

    SELECT MemberStatusID INTO v_member_status_id FROM MemberStatus WHERE MemberStatus = 'Member';
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Member status "Member" for some reason does not exist in the database.';
    END IF;

    INSERT INTO GuildMember(Character_Name, Guild_Name, MemberStatus_StatusID, IsBand)
    VALUES (p_character_name, p_guild_name, v_member_status_id, FALSE);

    RAISE NOTICE 'Character "%" has been successfully added to guild "%".', p_character_name, p_guild_name;
END;
$$ LANGUAGE plpgsql;