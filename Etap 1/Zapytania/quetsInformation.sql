-- Informacje o questach wraz z ich statystykami
-- oraz nagrodami w postaci przedmiotów oraz złota
SELECT 
    q.Name AS quest_name,
    q.Description,
    q.GoldReward,
    COUNT(DISTINCT ql.Character_Name) AS total_attempts,
    SUM(CASE WHEN qs.StatusName = 'Completed' THEN 1 ELSE 0 END) AS completed_count,
    SUM(CASE WHEN qs.StatusName = 'In_Progress' THEN 1 ELSE 0 END) AS in_progress,
    SUM(CASE WHEN qs.StatusName = 'Failed' THEN 1 ELSE 0 END) AS failed_count,
    ROUND(
        CAST(SUM(CASE WHEN qs.StatusName = 'Completed' THEN 1 ELSE 0 END) AS DECIMAL) / 
        NULLIF(COUNT(DISTINCT ql.Character_Name), 0) * 100,
        2
    ) AS completion_rate,
    ROUND(AVG(
        CASE 
            WHEN qs.StatusName = 'Completed' AND ql.EndTime IS NOT NULL 
            THEN EXTRACT(EPOCH FROM (ql.EndTime - ql.StartTime)) / 3600
            ELSE NULL 
        END
    ), 2) AS avg_completion_hours,
    STRING_AGG(DISTINCT it.Name, ', ') AS reward_items
FROM 
    game_data.Quest q
    LEFT JOIN game_data.QuestLog ql ON q.QuestID = ql.Quest_QuestID
    LEFT JOIN game_data.QuestStatus qs ON ql.QuestStatus_StatusID = qs.StatusID
    LEFT JOIN game_data.Iteam it ON q.Iteam_IteamID = it.IteamID
GROUP BY 
    q.QuestID, q.Name, q.Description, q.GoldReward
ORDER BY 
    completed_count DESC, total_attempts DESC;