CREATE VIEW system_ranking_overview AS
SELECT
  c.Name AS character_name,
  'Experience' AS ranking_category,
  c.Experience AS rank_value,
  RANK() OVER (ORDER BY c.Experience DESC, c.Level DESC) AS rank_position
FROM
  `character` c
WHERE
  c.IsNPC = 0 

UNION ALL

SELECT
  ql.Character_Name AS character_name,
  'Completed Quests' AS ranking_category,
  COUNT(ql.QuestLogID) AS rank_value,
  RANK() OVER (ORDER BY COUNT(ql.QuestLogID) DESC) AS rank_position
FROM
  questlog ql
JOIN
  queststatus qs ON ql.QuestStatus_StatusID = qs.StatusID
WHERE
  qs.StatusName = 'Completed'
GROUP BY
  ql.Character_Name

UNION ALL

SELECT
  c.Name AS character_name,
  'Wealth (Gold)' AS ranking_category,
  c.Gold AS rank_value,
  RANK() OVER (ORDER BY c.Gold DESC) AS rank_position
FROM
  `character` c 
WHERE
  c.IsNPC = 0 

UNION ALL

SELECT
  cl.Character_Name AS character_name,
  'PvE Victories' AS ranking_category,
  COUNT(cl.CombatLogID) AS rank_value,
  RANK() OVER (ORDER BY COUNT(cl.CombatLogID) DESC) AS rank_position
FROM
  combatlog cl
WHERE
  cl.Victory = 1 AND cl.Monster_MonsterID IS NOT NULL 
GROUP BY
  cl.Character_Name;

GRANT SELECT ON `rpg_game_db_mysql`.`system_ranking_overview` TO 'game_system'@'%';