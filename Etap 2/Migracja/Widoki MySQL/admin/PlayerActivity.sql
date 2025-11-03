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
    `character` c 
    LEFT JOIN (
      SELECT
        Character_Name,
        SUM(CASE WHEN QuestStatus_StatusID = (SELECT StatusID FROM queststatus WHERE StatusName = 'Completed') THEN 1 ELSE 0 END) AS completed_quests,
        MAX(GREATEST(StartTime, EndTime)) AS last_quest_activity
      FROM questlog
      GROUP BY Character_Name
    ) ql ON c.Name = ql.Character_Name
    LEFT JOIN (
      SELECT
        Character_Name,
        COUNT(*) AS total_fights
      FROM combatlog
      GROUP BY Character_Name
    ) cl ON c.Name = cl.Character_Name
)
SELECT
  p.Username,
  p.Email,
  ast.StatusName AS account_status,
  COUNT(cs.character_name) AS character_count,
  COALESCE(GROUP_CONCAT(cs.character_name SEPARATOR ', '), 'No characters') AS character_list,
  COALESCE(SUM(cs.total_fights), 0) AS total_fights_across_account,
  COALESCE(SUM(cs.completed_quests), 0) AS total_completed_quests,
  COALESCE(CAST(MAX(cs.last_quest_activity) AS CHAR), 'No activity recorded') AS last_activity,
  COALESCE(SUM(cs.Gold), 0) AS total_gold_on_account,
  CASE
    WHEN MAX(cs.last_quest_activity) < (NOW() - INTERVAL 30 DAY) THEN 1
    WHEN MAX(cs.last_quest_activity) IS NULL THEN 1
    ELSE 0
  END AS is_inactive_flag,
  CASE
    WHEN COALESCE(SUM(cs.Gold), 0) > 1000000 THEN 1
    ELSE 0
  END AS high_gold_flag
FROM
  player p
  JOIN accountstatus ast ON p.AccountStatus_StatusID = ast.StatusID
  LEFT JOIN characterstats cs ON p.Username = cs.Player_Userame
GROUP BY
  p.Username,
  p.Email,
  ast.StatusName;

GRANT SELECT ON `rpg_game_db_mysql`.`admin_player_activity` TO 'game_admin'@'%';