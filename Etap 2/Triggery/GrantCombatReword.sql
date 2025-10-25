SET search_path TO game_data;

CREATE FUNCTION fn_GrantCombatRewards()
RETURNS TRIGGER AS $$
DECLARE
    v_monster_name VARCHAR;
    v_gold_drop INT;
    v_exp_drop INT;
BEGIN
    IF NEW.Victory = TRUE THEN
        SELECT Name, GoldDrop, ExpDrop INTO v_monster_name, v_gold_drop, v_exp_drop
        FROM Monster WHERE MonsterID = NEW.Monster_MonsterID;

        UPDATE Character
        SET Gold = Gold + v_gold_drop,
            Experience = Experience + v_exp_drop
        WHERE Name = NEW.Character_Name;

        RAISE NOTICE 'Character % gained % gold and % EXP for slaying %.', NEW.Character_Name, v_gold_drop, v_exp_drop, v_monster_name;
    END IF;

    RETURN NULL; 
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_combat_log_rewards
AFTER INSERT ON CombatLog
FOR EACH ROW
EXECUTE FUNCTION fn_GrantCombatRewards();