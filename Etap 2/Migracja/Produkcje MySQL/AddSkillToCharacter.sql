DELIMITER $$
CREATE PROCEDURE sp_LearnSkill(
    IN p_character_name VARCHAR(10),
    IN p_skill_id INT
)
BEGIN
    DECLARE v_can_learn INT DEFAULT 0;

    SELECT COUNT(*) INTO v_can_learn
    FROM character_class cc
    JOIN class_skill cs ON cc.Class_Name = cs.Class_Name
    WHERE cc.Character_Name = p_character_name AND cs.Skill_SkillID = p_skill_id;

    IF v_can_learn = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Character cannot learn this skill as it is not available for their class(es).';
    END IF;

    INSERT IGNORE INTO skill_character(Skill_SkillID, Character_Name)
    VALUES (p_skill_id, p_character_name);

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Character already knows this skill.';
    END IF;
END$$
DELIMITER ;