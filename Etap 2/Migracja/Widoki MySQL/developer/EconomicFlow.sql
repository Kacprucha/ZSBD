CREATE VIEW developer_economic_flow AS
SELECT
  'Quest Rewards' AS source_type,
  q.Name AS source_name,
  q.GoldReward AS gold_per_instance,
  COUNT(ql.QuestLogID) AS times_completed,
  (q.GoldReward * COUNT(ql.QuestLogID)) AS total_gold_generated
FROM
  questlog ql
  JOIN quest q ON ql.Quest_QuestID = q.QuestID
  JOIN queststatus qs ON ql.QuestStatus_StatusID = qs.StatusID
WHERE
  qs.StatusName = 'Completed' AND q.GoldReward > 0
GROUP BY
  q.QuestID, q.Name 

UNION ALL

SELECT
  'Monster Drops' AS source_type,
  m.Name AS source_name,
  m.GoldDrop AS gold_per_instance,
  COUNT(cl.CombatLogID) AS times_defeated,
  SUM(m.GoldDrop) AS total_gold_generated
FROM
  combatlog cl
  JOIN monster m ON cl.Monster_MonsterID = m.MonsterID
WHERE
  cl.Victory = 1 AND m.GoldDrop > 0 
GROUP BY
  m.MonsterID, m.Name; 

GRANT SELECT ON `rpg_game_db_mysql`.`developer_economic_flow` TO 'game_developer'@'%';