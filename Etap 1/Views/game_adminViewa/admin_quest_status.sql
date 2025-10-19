SET search_path TO game_data;

CREATE VIEW admin_quest_statistics AS
SELECT
  q.Name AS quest_name,
  l.Name AS location_name,
  l.RecomenedLevel, 
  COALESCE(qs.total_attempts, 0) AS total_attempts,
  COALESCE(qs.unique_characters, 0) AS unique_characters,
  COALESCE(qs.success_count, 0) AS success_count,
  COALESCE(qs.failure_count, 0) AS failure_count,
  COALESCE(qs.in_progress_count, 0) AS in_progress_count,
  CASE
    WHEN qs.total_attempts > 0 THEN (qs.success_count * 100.0 / qs.total_attempts)::numeric(5, 2)
    ELSE 0.00
  END AS success_rate_percent,
  COALESCE(qs.avg_completion_time::text, 'Not atempted') AS avg_completion_time,
  q.GoldReward,
  COALESCE(i.Name || ' (' || r.RarityName || ')', 'No item reward') AS reward_item
FROM
  Quest q
  LEFT JOIN (
    SELECT
      Quest_QuestID,
      COUNT(*) AS total_attempts,
      COUNT(DISTINCT Character_Name) AS unique_characters,
      COUNT(*) FILTER (WHERE QuestStatus_StatusID = (SELECT StatusID FROM QuestStatus WHERE StatusName = 'Completed')) AS success_count,
      COUNT(*) FILTER (WHERE QuestStatus_StatusID = (SELECT StatusID FROM QuestStatus WHERE StatusName = 'Failed')) AS failure_count,
      COUNT(*) FILTER (WHERE QuestStatus_StatusID = (SELECT StatusID FROM QuestStatus WHERE StatusName = 'In_Progres')) AS in_progress_count,
      AVG(EndTime - StartTime) FILTER (WHERE QuestStatus_StatusID = (SELECT StatusID FROM QuestStatus WHERE StatusName = 'Completed')) AS avg_completion_time
    FROM QuestLog
    GROUP BY Quest_QuestID
  ) AS qs ON q.QuestID = qs.Quest_QuestID
  JOIN Location l ON q.Location_LocationID = l.LocationID
  LEFT JOIN Iteam i ON q.Iteam_IteamID = i.IteamID
  LEFT JOIN Rarity r ON i.Rarity_RarityID = r.RarityID;

GRANT SELECT ON admin_quest_statistics TO game_admin;