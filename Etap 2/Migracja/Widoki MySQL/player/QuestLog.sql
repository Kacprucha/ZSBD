CREATE VIEW player_quest_log AS
SELECT
  ql.Character_Name,
  qs.StatusName AS quest_status,
  q.Name AS quest_name,
  q.Giver AS quest_giver,
  l.Name AS location_name,
  l.RecomenedLevel AS recommended_level,
  q.Description AS quest_description,
  ql.AtemptNumber AS attempt_number,
  CAST(ql.StartTime AS CHAR) AS start_time,
  CASE
    WHEN ql.EndTime IS NOT NULL THEN CAST(ql.EndTime AS CHAR)
    ELSE '...'
  END AS end_time,
  CASE
    WHEN ql.EndTime IS NOT NULL THEN TIMEDIFF(ql.EndTime, ql.StartTime)
    ELSE 'Quest in progress'
  END AS duration,
  q.GoldReward,
  COALESCE(CONCAT(i.Name, ' (', r.RarityName, ')'), 'No item reward') AS reward_item_details
FROM
  questlog ql
  JOIN quest q ON ql.Quest_QuestID = q.QuestID
  JOIN queststatus qs ON ql.QuestStatus_StatusID = qs.StatusID
  JOIN `location` l ON ql.Location_LocationID = l.LocationID
  LEFT JOIN iteam i ON q.Iteam_IteamID = i.IteamID
  LEFT JOIN rarity r ON i.Rarity_RarityID = r.RarityID;

GRANT SELECT ON `rpg_game_db_mysql`.`player_quest_log` TO 'game_player'@'%';