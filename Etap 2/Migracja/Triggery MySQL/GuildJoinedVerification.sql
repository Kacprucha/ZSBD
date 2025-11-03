DELIMITER $$
CREATE TRIGGER trg_GuildLevelCheck
BEFORE INSERT ON guildmember
FOR EACH ROW
BEGIN
    DECLARE v_char_level INT;
    DECLARE v_guild_min_level INT;

    SELECT Level INTO v_char_level
    FROM `character` WHERE Name = NEW.Character_Name;

    SELECT MinLevel INTO v_guild_min_level
    FROM guild WHERE Name = NEW.Guild_Name;

    IF v_char_level IS NULL OR v_guild_min_level IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Character or Guild does not exist.';
    END IF;

    IF v_char_level < v_guild_min_level THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Character does not meet the minimum level requirement to join this guild.';
    END IF;
END$$
DELIMITER ;