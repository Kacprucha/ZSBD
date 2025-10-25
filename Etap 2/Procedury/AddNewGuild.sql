SET search_path TO game_data;

CREATE PROCEDURE sp_CreateGuild(
    p_guild_name VARCHAR(20),
    p_leader_name VARCHAR(10),
    p_min_level INT
) AS $$
DECLARE
    v_leader_exists INT;
    v_leader_in_guild INT;
    v_member_status_id INT;
BEGIN
    SELECT COUNT(*) INTO v_leader_exists FROM Character WHERE Name = p_leader_name AND IsNPC = FALSE;
    IF v_leader_exists = 0 THEN
        RAISE EXCEPTION 'Character "%" does not exist or is an NPC and cannot lead a guild.', p_leader_name;
    END IF;

    SELECT COUNT(*) INTO v_leader_in_guild FROM GuildMember WHERE Character_Name = p_leader_name;
    IF v_leader_in_guild > 0 THEN
        RAISE EXCEPTION 'Character "%" is already a member of a guild and cannot lead another guild.', p_leader_name;
    END IF;

    INSERT INTO Guild (Name, Leader_Name, MinLevel)
    VALUES (p_guild_name, p_leader_name, p_min_level);

    SELECT MemberStatusID INTO v_member_status_id FROM MemberStatus WHERE MemberStatus = 'Leader';
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Member status "Leader" some how does not exist in the database.';
    END IF;

    INSERT INTO GuildMember (Character_Name, Guild_Name, MemberStatus_StatusID, IsBand, Contribution)
    VALUES (p_leader_name, p_guild_name, v_member_status_id, FALSE, 0);

    RAISE NOTICE 'Guild "%" has been successfully created with leader "%".', p_guild_name, p_leader_name;
END;
$$ LANGUAGE plpgsql;