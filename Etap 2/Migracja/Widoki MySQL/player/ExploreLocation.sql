CREATE VIEW player_location_explored AS
SELECT
  cl.Character_Name,
  l.Name AS location_name,
  lt.TypeName AS location_type,
  l.IsSafeZone,
  l.RecomenedLevel,
  COUNT(cl.CombatLogID) AS total_fights,
  SUM(cl.Victory) AS victories,
  CAST((AVG(cl.Victory) * 100) AS DECIMAL(5, 2)) AS success_rate_percent,
  GROUP_CONCAT(DISTINCT m.Name SEPARATOR ', ') AS monsters_encountered,
  SUM(CASE WHEN cl.Victory = 1 THEN m.GoldDrop ELSE 0 END) AS total_gold_gained,
  SUM(CASE WHEN cl.Victory = 1 THEN m.ExpDrop ELSE 0 END) AS total_exp_gained,
  SUM(cl.DmgDelt) AS total_damage_dealt,
  SUM(cl.DmgTaken) AS total_damage_taken
FROM
  combatlog cl
  JOIN `location` l ON cl.Location_LocationID = l.LocationID
  JOIN locationtype lt ON l.LocatioType_TypeID = lt.TypeID
  LEFT JOIN monster m ON cl.Monster_MonsterID = m.MonsterID
GROUP BY
  cl.Character_Name,
  l.LocationID,
  l.Name,
  lt.TypeName,
  l.IsSafeZone,
  l.RecomenedLevel;

GRANT SELECT ON `rpg_game_db_mysql`.`player_location_explored` TO 'game_player'@'%';