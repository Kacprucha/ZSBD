SET search_path TO game_data;

CREATE FUNCTION fn_CanCharacterJoinGuild(p_character_name VARCHAR, p_guild_name VARCHAR)
RETURNS BOOLEAN AS $$
DECLARE
    v_character_level INT;
    v_min_guild_level INT;
BEGIN
    SELECT Level INTO v_character_level
    FROM Character WHERE Name = p_character_name;

    SELECT MinLevel INTO v_min_guild_level
    FROM Guild WHERE Name = p_guild_name;

    RETURN v_character_level >= v_min_guild_level;
END;
$$ LANGUAGE plpgsql;