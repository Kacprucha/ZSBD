SET search_path TO game_data;

CREATE PROCEDURE sp_CompleteQuest(
    p_character_name VARCHAR(10),
    p_quest_id INT
) AS $$
DECLARE
    v_questlog_id INT;
    v_current_status_name VARCHAR;
    v_gold_reward INT;
    v_exp_reward INT := 100;
    v_reward_item_id INT;
BEGIN
    PERFORM Name FROM Character WHERE Name = p_character_name;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Character "%" does not exist.', p_character_name;
    END IF;

    PERFORM QuestID FROM Quest WHERE QuestID = p_quest_id;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Quest with ID % does not exist.', p_quest_id;
    END IF;

    SELECT
        ql.QuestLogID,
        qs.StatusName
    INTO
        v_questlog_id,
        v_current_status_name
    FROM QuestLog ql
    JOIN QuestStatus qs ON ql.QuestStatus_StatusID = qs.StatusID
    WHERE ql.Character_Name = p_character_name AND ql.Quest_QuestID = p_quest_id
    ORDER BY ql.StartTime DESC 
    LIMIT 1;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Character "%" never atempted quest with ID % or quest log entry not found.', p_character_name, p_quest_id;
    END IF;

    IF v_current_status_name <> 'In_Progress' THEN
        RAISE EXCEPTION 'Cannot complete quest with ID % for character "%". Current status is "%", expected "In_Progress".', p_quest_id, p_character_name, v_current_status_name;
    END IF;

    SELECT GoldReward, Iteam_IteamID
    INTO v_gold_reward, v_reward_item_id
    FROM Quest
    WHERE QuestID = p_quest_id;

    UPDATE QuestLog
    SET
        QuestStatus_StatusID = (SELECT StatusID FROM QuestStatus WHERE StatusName = 'Completed'),
        EndTime = NOW()
    WHERE QuestLogID = v_questlog_id;

    UPDATE Character
    SET
        Gold = Gold + v_gold_reward,
        Experience = Experience + v_exp_reward
    WHERE Name = p_character_name;

    IF v_reward_item_id IS NOT NULL THEN
        INSERT INTO Iteam_Character (Character_Name, Iteam_IteamID)
        VALUES (p_character_name, v_reward_item_id);
    END IF;

    RAISE NOTICE 'Character "%" has successfully completed quest with ID %. Rewards: % gold, % experience, item ID: %.',
        p_character_name, p_quest_id, v_gold_reward, v_exp_reward,
        COALESCE(v_reward_item_id::TEXT, 'None');

EXCEPTION
    WHEN OTHERS THEN
        RAISE WARNING 'An error occurred while completing the quest for character "%".', p_character_name;
        RAISE WARNING 'SQLSTATE: %, Message: %', SQLSTATE, SQLERRM;
END;
$$ LANGUAGE plpgsql;