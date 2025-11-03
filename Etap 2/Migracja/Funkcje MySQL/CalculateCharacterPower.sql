DELIMITER $$
CREATE FUNCTION fn_CalculateCharacterPower(p_character_name VARCHAR(10))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_power_level INT DEFAULT 0;
    DECLARE v_base_stats_power INT DEFAULT 0;
    DECLARE v_item_bonuses_power INT DEFAULT 0;
    DECLARE v_character_level INT;
    DECLARE v_total_race_bonus INT;

    SELECT
        c.Level,
        (SELECT SUM(r.FightBonus + r.MagicBonus)
         FROM race_character rc
         JOIN race r ON rc.Race_Name = r.Name
         WHERE rc.Character_Name = c.Name)
    INTO
        v_character_level,
        v_total_race_bonus
    FROM
        `character` c
    WHERE
        c.Name = p_character_name;

    SET v_base_stats_power = (v_character_level * 10) + (COALESCE(v_total_race_bonus, 0) * 5);

    SELECT
        COALESCE(SUM(i.AtackBonus + i.DefenceBonus + i.MagicBonus), 0)
    INTO
        v_item_bonuses_power
    FROM
        iteam_character ic
    JOIN
        iteam i ON ic.Iteam_IteamID = i.IteamID
    WHERE
        ic.Character_Name = p_character_name;

    SET v_power_level = v_base_stats_power + v_item_bonuses_power;

    RETURN v_power_level;
END$$
DELIMITER ;