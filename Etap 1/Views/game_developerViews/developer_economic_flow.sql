SET search_path TO game_data;

CREATE VIEW developer_economic_flow AS
SELECT
  'Quest Rewards' AS source_type,
  q.Name AS source_name,
  q.GoldReward AS gold_per_instance,
  COUNT(ql.QuestLogID) AS times_completed,
  (q.GoldReward * COUNT(ql.QuestLogID)) AS total_gold_generated
FROM
  QuestLog ql
  JOIN Quest q ON ql.Quest_QuestID = q.QuestID
  JOIN QuestStatus qs ON ql.QuestStatus_StatusID = qs.StatusID
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
  CombatLog cl
  JOIN Monster m ON cl.Monster_MonsterID = m.MonsterID
WHERE
  cl.Victory = TRUE AND m.GoldDrop > 0
GROUP BY
  m.MonsterID, m.Name;

GRANT SELECT ON developer_economic_flow TO game_developer;