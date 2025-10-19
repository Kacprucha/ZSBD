SET search_path TO game_data;

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
  ql.StartTime::text AS start_time,
  CASE
    WHEN ql.EndTime IS NOT NULL THEN (ql.EndTime)::text
    ELSE '...'
  END AS end_time,
  CASE
    WHEN ql.EndTime IS NOT NULL THEN (ql.EndTime - ql.StartTime)::text
    ELSE 'Quest in progress'
  END AS duration,
  q.GoldReward,
  COALESCE(i.Name || ' (' || r.RarityName || ')', 'No item reward') AS reward_item_details
FROM
  QuestLog ql
  JOIN Quest q ON ql.Quest_QuestID = q.QuestID
  JOIN QuestStatus qs ON ql.QuestStatus_StatusID = qs.StatusID
  JOIN Location l ON q.Location_LocationID = l.LocationID
  LEFT JOIN Iteam i ON q.Iteam_IteamID = i.IteamID
  LEFT JOIN Rarity r ON i.Rarity_RarityID = r.RarityID;

GRANT SELECT ON player_quest_log TO game_player, game_system;