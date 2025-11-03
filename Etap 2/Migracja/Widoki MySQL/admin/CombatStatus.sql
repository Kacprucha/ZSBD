CREATE VIEW admin_combat_logs AS
SELECT
  cl.CombatLogID,
  p.Username,
  cl.Character_Name,
  c.Level AS character_level,
  COALESCE(m.Name, 'Missing name') AS monster_name,
  COALESCE(m.Level, 0) AS monster_level,
  l.Name AS location_name,
  CASE
    WHEN cl.Victory = 1 THEN 'Victory'
    ELSE 'Defeat'
  END AS result,
  cl.DmgDelt,
  cl.DmgTaken,
  (c.Level - COALESCE(m.Level, c.Level)) AS level_difference,
  CASE
    WHEN cl.Victory = 1 AND (c.Level - COALESCE(m.Level, c.Level)) < -15 THEN 1
    ELSE 0
  END AS level_mismatch_flag,
  CASE
    WHEN cl.DmgDelt > 10000 THEN 1
    ELSE 0
  END AS high_damage_flag,
  CASE
    WHEN cl.Victory = 1 AND cl.DmgTaken = 0 AND cl.Monster_MonsterID IS NOT NULL THEN 1
    ELSE 0
  END AS zero_damage_victory_flag
FROM
  combatlog cl
  JOIN `location` l ON cl.Location_LocationID = l.LocationID
  JOIN `character` c ON cl.Character_Name = c.Name
  JOIN player p ON c.Player_Userame = p.Username
  LEFT JOIN monster m ON cl.Monster_MonsterID = m.MonsterID;

GRANT SELECT ON `rpg_game_db_mysql`.`admin_combat_logs` TO 'game_admin'@'%';