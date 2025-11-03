DELIMITER $$
CREATE FUNCTION fn_CanCharacterJoinGuild(
    p_character_name VARCHAR(10),
    p_guild_name VARCHAR(20)
)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE v_character_level INT;
    DECLARE v_min_guild_level INT;

    SELECT Level INTO v_character_level
    FROM `character` WHERE Name = p_character_name;

    SELECT MinLevel INTO v_min_guild_level
    FROM guild WHERE Name = p_guild_name;

    IF v_character_level >= v_min_guild_level THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END$$
DELIMITER ;