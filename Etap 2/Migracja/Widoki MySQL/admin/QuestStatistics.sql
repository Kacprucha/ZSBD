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
    WHEN qs.total_attempts > 0 THEN CAST((qs.success_count * 100.0 / qs.total_attempts) AS DECIMAL(5, 2))
    ELSE 0.00
  END AS success_rate_percent,
  COALESCE(qs.avg_completion_time_text, 'Not attempted') AS avg_completion_time,
  q.GoldReward,
  COALESCE(CONCAT(i.Name, ' (', r.RarityName, ')'), 'No item reward') AS reward_item
FROM
  quest q
  LEFT JOIN (
    SELECT
      Quest_QuestID,
      COUNT(*) AS total_attempts,
      COUNT(DISTINCT Character_Name) AS unique_characters,
      SUM(CASE WHEN QuestStatus_StatusID = (SELECT StatusID FROM queststatus WHERE StatusName = 'Completed') THEN 1 ELSE 0 END) AS success_count,
      SUM(CASE WHEN QuestStatus_StatusID = (SELECT StatusID FROM queststatus WHERE StatusName = 'Failed') THEN 1 ELSE 0 END) AS failure_count,
      SUM(CASE WHEN QuestStatus_StatusID = (SELECT StatusID FROM queststatus WHERE StatusName = 'In_Progres') THEN 1 ELSE 0 END) AS in_progress_count,
      SEC_TO_TIME(AVG(TIMESTAMPDIFF(SECOND, StartTime, EndTime))) AS avg_completion_time_text
    FROM questlog
    WHERE EndTime IS NOT NULL AND QuestStatus_StatusID = (SELECT StatusID FROM queststatus WHERE StatusName = 'Completed')
    GROUP BY Quest_QuestID
  ) AS qs ON q.QuestID = qs.Quest_QuestID
  JOIN Location l ON q.Location_LocationID = l.LocationID
  LEFT JOIN iteam i ON q.Iteam_IteamID = i.IteamID
  LEFT JOIN rarity r ON i.Rarity_RarityID = r.RarityID;

GRANT SELECT ON `rpg_game_db_mysql`.`admin_quest_statistics` TO 'game_admin'@'%';