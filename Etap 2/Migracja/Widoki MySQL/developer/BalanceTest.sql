CREATE VIEW developer_balance_test_results AS
SELECT
  'Class Combat Performance' AS analysis_type,
  cc.Class_Name AS entity_name,
  COUNT(cl.CombatLogID) AS total_fights_recorded,
  CAST((AVG(cl.Victory) * 100) AS DECIMAL(5, 2)) AS win_rate_percent,
  CAST(AVG(cl.DmgDelt) AS DECIMAL(10, 2)) AS avg_damage_dealt,
  CAST(AVG(cl.DmgTaken) AS DECIMAL(10, 2)) AS avg_damage_taken,
  CONCAT('Fights:', COUNT(cl.CombatLogID), '; WinRate:', CAST((AVG(cl.Victory) * 100) AS DECIMAL(5, 2)), '%') AS summary
FROM
  combatlog cl
  JOIN character_class cc ON cl.Character_Name = cc.Character_Name
GROUP BY
  cc.Class_Name

UNION ALL

SELECT
  'Monster Difficulty' AS analysis_type,
  m.Name AS entity_name,
  COUNT(cl.CombatLogID) AS times_fought,
  CAST(AVG(c.Level) AS DECIMAL(5, 2)) AS avg_player_level,
  CAST((AVG(cl.Victory) * 100) AS DECIMAL(5, 2)) AS player_win_rate_percent,
  m.Level AS monster_level,
  CONCAT('Fought:', COUNT(cl.CombatLogID), '; PlayerWinRate:', CAST((AVG(cl.Victory) * 100) AS DECIMAL(5, 2)), '%') AS summary
FROM
  combatlog cl
  JOIN monster m ON cl.Monster_MonsterID = m.MonsterID
  JOIN `character` c ON cl.Character_Name = c.Name 
GROUP BY
  m.MonsterID, m.Name

UNION ALL

SELECT
  'Quest Balance' AS analysis_type,
  q.Name AS entity_name,
  COUNT(ql.QuestLogID) AS total_attempts,
  CAST((AVG(CASE WHEN qs.StatusName = 'Completed' THEN 1.0 ELSE 0.0 END) * 100) AS DECIMAL(5, 2)) AS success_rate_percent,
  CAST(AVG(CASE WHEN qs.StatusName = 'Completed' THEN ql.AtemptNumber ELSE NULL END) AS DECIMAL(5, 2)) AS avg_attempts_for_completion,
  CAST(AVG(CASE WHEN qs.StatusName = 'Completed' THEN TIMESTAMPDIFF(SECOND, ql.StartTime, ql.EndTime) ELSE NULL END) AS SIGNED) AS avg_seconds_to_complete,
  CONCAT('SuccessRate:', CAST((AVG(CASE WHEN qs.StatusName = 'Completed' THEN 1.0 ELSE 0.0 END) * 100) AS DECIMAL(5, 2)), '%') AS summary
FROM
  questlog ql
  JOIN quest q ON ql.Quest_QuestID = q.QuestID
  JOIN queststatus qs ON ql.QuestStatus_StatusID = qs.StatusID
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
  CONCAT('Dmg:', s.Damage, '; Mana:', s.ManaCost, '; CD:', s.CoolDown) AS summary
FROM
  skill s;

GRANT SELECT ON `rpg_game_db_mysql`.`developer_balance_test_results` TO 'game_developer'@'%';