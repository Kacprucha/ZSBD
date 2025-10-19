SET search_path TO game_data;

CREATE VIEW player_location_explored AS
SELECT
  cl.Character_Name,
  l.Name AS location_name,
  lt.TypeName AS location_type,
  l.IsSafeZone,
  l.RecomenedLevel,
  COUNT(cl.CombatLogID) AS total_fights, 
  SUM(CASE WHEN cl.Victory THEN 1 ELSE 0 END) AS victories, 
  (AVG(CASE WHEN cl.Victory THEN 1.0 ELSE 0.0 END) * 100)::numeric(5, 2) AS success_rate_percent,
  STRING_AGG(DISTINCT m.Name, ', ') AS monsters_encountered, 
  SUM(CASE WHEN cl.Victory THEN m.GoldDrop ELSE 0 END) AS total_gold_gained,
  SUM(CASE WHEN cl.Victory THEN m.ExpDrop ELSE 0 END) AS total_exp_gained, 
  SUM(cl.DmgDelt) AS total_damage_dealt, 
  SUM(cl.DmgTaken) AS total_damage_taken 
FROM
  CombatLog cl
  JOIN Location l ON cl.Location_LocationID = l.LocationID
  JOIN LocationType lt ON l.LocatioType_TypeID = lt.TypeID
  LEFT JOIN Monster m ON cl.Monster_MonsterID = m.MonsterID
GROUP BY
  cl.Character_Name,
  l.LocationID, 
  l.Name,
  lt.TypeName,
  l.IsSafeZone,
  l.RecomenedLevel;

GRANT SELECT ON player_location_explored TO game_player, game_system;