DELIMITER $$
CREATE TRIGGER trg_CombatLogRewards
AFTER INSERT ON combatlog
FOR EACH ROW
BEGIN
    DECLARE v_gold_drop INT;
    DECLARE v_exp_drop INT;

    IF NEW.Victory = 1 THEN
        SELECT GoldDrop, ExpDrop INTO v_gold_drop, v_exp_drop
        FROM monster WHERE MonsterID = NEW.Monster_MonsterID;

        IF v_gold_drop IS NOT NULL THEN
            UPDATE `character`
            SET Gold = Gold + v_gold_drop,
                Experience = Experience + v_exp_drop
            WHERE Name = NEW.Character_Name;
        END IF;
    END IF;
END$$
DELIMITER ;