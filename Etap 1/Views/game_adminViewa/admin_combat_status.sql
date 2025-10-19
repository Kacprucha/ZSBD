SET search_path TO game_data;

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
    WHEN cl.Victory THEN 'Victory'
    ELSE 'Defeat'
  END AS result,
  cl.DmgDelt,
  cl.DmgTaken,
  (c.Level - COALESCE(m.Level, c.Level)) AS level_difference,
  CASE
    WHEN cl.Victory AND (c.Level - COALESCE(m.Level, c.Level)) < -15 THEN TRUE 
    ELSE FALSE
  END AS level_mismatch_flag,
  CASE
    WHEN cl.DmgDelt > 10000 THEN TRUE 
    ELSE FALSE
  END AS high_damage_flag,
  CASE
    WHEN cl.Victory AND cl.DmgTaken = 0 AND cl.Monster_MonsterID IS NOT NULL THEN TRUE
    ELSE FALSE
  END AS zero_damage_victory_flag
FROM
  CombatLog cl
  JOIN Location l ON cl.Location_LocationID = l.LocationID
  JOIN Character c ON cl.Character_Name = c.Name
  JOIN Player p ON c.Player_Userame = p.Username
  LEFT JOIN Monster m ON cl.Monster_MonsterID = m.MonsterID;

GRANT SELECT ON admin_combat_logs TO game_admin;