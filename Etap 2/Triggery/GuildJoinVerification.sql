SET search_path TO game_data;

CREATE FUNCTION fn_CheckGuildLevel()
RETURNS TRIGGER AS $$
DECLARE
    v_char_level INT;
    v_guild_min_level INT;
BEGIN
    SELECT Level INTO v_char_level FROM Character WHERE Name = NEW.Character_Name;
    SELECT MinLevel INTO v_guild_min_level FROM Guild WHERE Name = NEW.Guild_Name;

    IF v_char_level < v_guild_min_level THEN
        RAISE EXCEPTION 'Character "%" (Level: %) canot join guild "%", the minimum level to join it is: %.',
            NEW.Character_Name, v_char_level, NEW.Guild_Name, v_guild_min_level;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_GuildLevelCheck
BEFORE INSERT ON GuildMember
FOR EACH ROW
EXECUTE FUNCTION fn_CheckGuildLevel();