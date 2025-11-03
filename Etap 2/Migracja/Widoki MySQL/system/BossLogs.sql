CREATE VIEW system_boss_fight_log AS
SELECT
  cl.Character_Name,
  c.Level AS character_level,
  COALESCE(gm.Guild_Name, 'No guild') AS character_guild,
  m.Name AS boss_name,
  m.Level AS boss_level,
  m.HitPoints AS boss_hit_points,
  l.Name AS location_name,
  CASE
    WHEN cl.Victory = 1 THEN 'Victory' 
    ELSE 'Defeat'
  END AS result,
  cl.DmgDelt,
  cl.DmgTaken,
  m.GoldDrop AS potential_gold_reward,
  m.ExpDrop AS potential_exp_reward
FROM
  combatlog cl
  JOIN monster m ON cl.Monster_MonsterID = m.MonsterID
  JOIN `character` c ON cl.Character_Name = c.Name 
  JOIN `location` l ON cl.Location_LocationID = l.LocationID
  LEFT JOIN guildmember gm ON c.Name = gm.Character_Name
WHERE
  m.Level > 40 AND m.HitPoints > 5000;

GRANT SELECT ON `rpg_game_db_mysql`.`system_boss_fight_log` TO 'game_system'@'%';