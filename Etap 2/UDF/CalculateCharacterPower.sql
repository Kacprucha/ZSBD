SET search_path TO game_data;

CREATE FUNCTION fn_CalculateCharacterPower(p_character_name VARCHAR)
RETURNS INT AS $$
DECLARE
    v_power_level INT := 0;
    v_base_stats_power INT := 0;
    v_item_bonuses_power INT := 0;
    v_character_level INT;
    v_race_bonus INT;
BEGIN
    SELECT
        c.Level,
        (SELECT SUM(r.FightBonus + r.MagicBonus)
         FROM game_data.Race_Character rc
         JOIN game_data.Race r ON rc.Race_Name = r.Name
         WHERE rc.Character_Name = c.Name)
    INTO
        v_character_level,
        v_race_bonus
    FROM
        game_data.Character c
    WHERE
        c.Name = p_character_name;

    v_base_stats_power := (v_character_level * 10) + (v_race_bonus * 5);

    SELECT COALESCE(SUM(i.AtackBonus + i.DefenceBonus + i.MagicBonus), 0)
    INTO v_item_bonuses_power
    FROM game_data.Iteam_Character ic
    JOIN game_data.Iteam i ON ic.Iteam_IteamID = i.IteamID
    WHERE ic.Character_Name = p_character_name;

    v_power_level := v_base_stats_power + v_item_bonuses_power;

    RETURN v_power_level;
END;
$$ LANGUAGE plpgsql;