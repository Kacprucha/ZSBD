SET search_path TO game_data;

CREATE FUNCTION fn_GetCharacterWinRate(p_character_name VARCHAR)
RETURNS NUMERIC AS $$
DECLARE
    v_total_fights INT;
    v_victories INT;
BEGIN
    SELECT COUNT(*) INTO v_total_fights FROM game_data.CombatLog WHERE Character_Name = p_character_name;

    IF v_total_fights = 0 THEN
        RETURN 0.00;
    END IF;

    SELECT COUNT(*) INTO v_victories FROM game_data.CombatLog WHERE Character_Name = p_character_name AND Victory = TRUE;

    RETURN (v_victories::NUMERIC * 100.0 / v_total_fights)::NUMERIC(5, 2);
END;
$$ LANGUAGE plpgsql;