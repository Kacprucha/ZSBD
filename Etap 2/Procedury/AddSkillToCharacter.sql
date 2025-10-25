SET search_path TO game_data;

CREATE PROCEDURE sp_LearnSkill(p_character_name VARCHAR, p_skill_id INT)
AS $$
DECLARE
    v_cant_learn BOOLEAN := FALSE;
    v_skill_name VARCHAR;
BEGIN
    SELECT EXISTS (
        SELECT 1 
        FROM Class_Skill cs 
        WHERE cs.Skill_SkillID = p_skill_id AND cs.Class_Name NOT IN (
            SELECT Class_Name 
            FROM Character_Class 
            WHERE Character_Name = p_character_name
        ) 
    )
    AND NOT EXISTS (
        SELECT 1 
        FROM Class_Skill cs JOIN Character_Class cc ON cs.Class_Name = cc.Class_Name 
        WHERE cc.Character_Name = p_character_name AND cs.Skill_SkillID = p_skill_id
    )
    INTO v_cant_learn;


    IF v_cant_learn THEN
        RAISE EXCEPTION 'Character "%" canot learn skill that is associated with classes they do not belong to.', p_character_name;
    END IF;

    SELECT Name FROM Skill WHERE SkillID = p_skill_id INTO v_skill_name;

    PERFORM 1 FROM Skill_Character
    WHERE Character_Name=p_character_name AND Skill_SkillID=p_skill_id;
    IF FOUND THEN
        RAISE EXCEPTION 'Character "%" already knows skill %.', p_character_name, v_skill_name;

    END IF;

    INSERT INTO Skill_Character(Skill_SkillID, Character_Name)
    VALUES (p_skill_id, p_character_name)
    ON CONFLICT (Skill_SkillID, Character_Name) DO NOTHING;

    RAISE NOTICE 'Character "%" has successfully learned skill %.', p_character_name, v_skill_name;
END;
$$ LANGUAGE plpgsql;