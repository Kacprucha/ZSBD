SET search_path TO game_data;

CREATE VIEW developer_balance_test_results AS
SELECT
  'Class Combat Performance' AS analysis_type,
  cc.Class_Name AS entity_name,
  COUNT(cl.CombatLogID) AS total_fights_recorded,
  (AVG(CASE WHEN cl.Victory THEN 1.0 ELSE 0.0 END) * 100)::numeric(5, 2) AS win_rate_percent,
  AVG(cl.DmgDelt)::numeric(10, 2) AS avg_damage_dealt,
  AVG(cl.DmgTaken)::numeric(10, 2) AS avg_damage_taken,
  'Fights:' || COUNT(cl.CombatLogID) || '; WinRate:' || (AVG(CASE WHEN cl.Victory THEN 1.0 ELSE 0.0 END) * 100)::numeric(5, 2) || '%' AS summary
FROM
  CombatLog cl
  JOIN Character_Class cc ON cl.Character_Name = cc.Character_Name
GROUP BY
  cc.Class_Name

UNION ALL
SELECT
  'Monster Difficulty' AS analysis_type,
  m.Name AS entity_name,
  COUNT(cl.CombatLogID) AS times_fought,
  AVG(c.Level)::numeric(5, 2) AS avg_player_level,
  (AVG(CASE WHEN cl.Victory THEN 1.0 ELSE 0.0 END) * 100)::numeric(5, 2) AS player_win_rate_percent,
  m.Level AS monster_level,
  'Fought:' || COUNT(cl.CombatLogID) || '; PlayerWinRate:' || (AVG(CASE WHEN cl.Victory THEN 1.0 ELSE 0.0 END) * 100)::numeric(5, 2) || '%' AS summary
FROM
  CombatLog cl
  JOIN Monster m ON cl.Monster_MonsterID = m.MonsterID
  JOIN Character c ON cl.Character_Name = c.Name
GROUP BY
  m.MonsterID, m.Name

UNION ALL
SELECT
  'Quest Balance' AS analysis_type,
  q.Name AS entity_name,
  COUNT(ql.QuestLogID) AS total_attempts,
  (AVG(CASE WHEN qs.StatusName = 'Completed' THEN 1.0 ELSE 0.0 END) * 100)::numeric(5, 2) AS success_rate_percent,
  AVG(ql.AtemptNumber) FILTER (WHERE qs.StatusName = 'Completed')::numeric(5, 2) AS avg_attempts_for_completion,
  EXTRACT(EPOCH FROM AVG(ql.EndTime - ql.StartTime) FILTER (WHERE qs.StatusName = 'Completed'))::integer AS avg_seconds_to_complete,
  'SuccessRate:' || (AVG(CASE WHEN qs.StatusName = 'Completed' THEN 1.0 ELSE 0.0 END) * 100)::numeric(5, 2) || '%' AS summary
FROM
  QuestLog ql
  JOIN Quest q ON ql.Quest_QuestID = q.QuestID
  JOIN QuestStatus qs ON ql.QuestStatus_StatusID = qs.StatusID
GROUP BY
  q.QuestID, q.Name

UNION ALL
SELECT
  'Skill Overview' AS analysis_type,
  s.Name AS entity_name,
  (SELECT COUNT(DISTINCT sc.Character_Name) FROM Skill_Character sc WHERE sc.Skill_SkillID = s.SkillID) AS characters_with_skill,
  s.Damage AS base_damage,
  s.ManaCost AS mana_cost,
  s.CoolDown AS cooldown,
  'Dmg:' || s.Damage || '; Mana:' || s.ManaCost || '; CD:' || s.CoolDown AS summary
FROM
  Skill s;

GRANT SELECT ON developer_balance_test_results TO game_developer;