SET search_path TO game_data;

CREATE VIEW admin_player_activity AS
WITH CharacterStats AS (
  SELECT
    c.Player_Userame,
    c.Name AS character_name,
    c.Gold,
    ql.completed_quests,
    ql.last_quest_activity,
    cl.total_fights
  FROM
    Character c
    LEFT JOIN (
      SELECT
        Character_Name,
        COUNT(*) FILTER (WHERE QuestStatus_StatusID = (SELECT StatusID FROM QuestStatus WHERE StatusName = 'Completed')) AS completed_quests,
        MAX(GREATEST(StartTime, EndTime)) AS last_quest_activity
      FROM QuestLog
      GROUP BY Character_Name
    ) ql ON c.Name = ql.Character_Name
    LEFT JOIN (
      SELECT
        Character_Name,
        COUNT(*) AS total_fights
      FROM CombatLog
      GROUP BY Character_Name
    ) cl ON c.Name = cl.Character_Name
)
SELECT
  p.Username,
  p.Email,
  ast.StatusName AS account_status,
  COUNT(cs.character_name) AS character_count,
  COALESCE(STRING_AGG(cs.character_name, ', '), 'No characters') AS character_list,
  COALESCE(SUM(cs.total_fights), 0) AS total_fights_across_account,
  COALESCE(SUM(cs.completed_quests), 0) AS total_completed_quests,
  COALESCE(MAX(cs.last_quest_activity)::text, 'No activity recorded') AS last_activity,
  COALESCE(SUM(cs.Gold), 0) AS total_gold_on_account,
  CASE
    WHEN MAX(cs.last_quest_activity) < (NOW() - INTERVAL '30 days') THEN TRUE
    WHEN MAX(cs.last_quest_activity) IS NULL THEN TRUE 
    ELSE FALSE
  END AS is_inactive_flag,
  CASE
    WHEN COALESCE(SUM(cs.Gold), 0) > 1000000 THEN TRUE 
    ELSE FALSE
  END AS high_gold_flag
FROM
  Player p
  JOIN AccountStatus ast ON p.AccountStatus_StatusID = ast.StatusID
  LEFT JOIN CharacterStats cs ON p.Username = cs.Player_Userame
GROUP BY
  p.Username,
  p.Email,
  ast.StatusName;

GRANT SELECT ON admin_player_activity TO game_admin;