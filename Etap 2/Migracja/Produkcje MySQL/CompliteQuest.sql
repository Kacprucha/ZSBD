DELIMITER $$
CREATE PROCEDURE sp_CompleteQuest(
    IN p_character_name VARCHAR(10),
    IN p_quest_id INT
)
BEGIN
    DECLARE v_questlog_id INT;
    DECLARE v_current_status_id INT;
    DECLARE v_status_in_progress_id INT;
    DECLARE v_status_completed_id INT;
    DECLARE v_gold_reward INT;
    DECLARE v_exp_reward INT DEFAULT 100;
    DECLARE v_reward_item_id INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'An error occurred, transaction rolled back.';
    END;

    SELECT StatusID INTO v_status_in_progress_id FROM queststatus WHERE StatusName = 'In_Progress';
    SELECT StatusID INTO v_status_completed_id FROM queststatus WHERE StatusName = 'Completed';

    SELECT QuestLogID, QuestStatus_StatusID INTO v_questlog_id, v_current_status_id
    FROM questlog
    WHERE Character_Name = p_character_name AND Quest_QuestID = p_quest_id
    ORDER BY StartTime DESC LIMIT 1;

    IF v_questlog_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Character has not started this quest.';
    END IF;

    IF v_current_status_id <> v_status_in_progress_id THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Quest is not in "In_Progres" status.';
    END IF;

    SELECT GoldReward, Iteam_IteamID INTO v_gold_reward, v_reward_item_id
    FROM quest WHERE QuestID = p_quest_id;

    START TRANSACTION;

    UPDATE questlog
    SET QuestStatus_StatusID = v_status_completed_id, EndTime = NOW()
    WHERE QuestLogID = v_questlog_id;

    UPDATE `character`
    SET Gold = Gold + v_gold_reward, Experience = Experience + v_exp_reward
    WHERE Name = p_character_name;

    IF v_reward_item_id IS NOT NULL THEN
        INSERT INTO iteam_character (Character_Name, Iteam_IteamID)
        VALUES (p_character_name, v_reward_item_id);
    END IF;

    COMMIT;
END$$
DELIMITER ;