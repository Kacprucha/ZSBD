SET search_path TO game_data;

CREATE FUNCTION fn_GetGuildMembershipDuration(p_character_name VARCHAR)
RETURNS INTERVAL AS $$
DECLARE
    v_duration INTERVAL;
BEGIN
    SELECT NOW() - JoinedAt
    INTO v_duration
    FROM game_data.GuildMember
    WHERE Character_Name = p_character_name;

    RETURN v_duration;
END;
$$ LANGUAGE plpgsql;