CREATE VIEW system_anomaly_detection AS
WITH charactercombatstats AS (
  SELECT
    cl.Character_Name,
    COUNT(cl.CombatLogID) AS total_fights,
    SUM(cl.Victory) AS total_victories,
    SUM(NOT cl.Victory) AS total_deaths, 
    SUM(CASE WHEN cl.Victory = 1 THEN m.GoldDrop ELSE 0 END) AS total_gold_from_monsters,
    SUM(CASE WHEN cl.Victory = 1 THEN m.ExpDrop ELSE 0 END) AS total_exp_from_monsters
  FROM
    combatlog cl
    JOIN monster m ON cl.Monster_MonsterID = m.MonsterID
  GROUP BY
    cl.Character_Name
)
SELECT
  c.Name AS character_name,
  p.Username,
  c.Level,
  c.Gold AS current_gold_balance,
  COALESCE(ccs.total_fights, 0) AS total_fights,
  COALESCE(ccs.total_deaths, 0) AS total_deaths,
  COALESCE(ccs.total_gold_from_monsters, 0) AS total_gold_from_monsters,
  CAST(COALESCE(ccs.total_victories, 0) * 100.0 / NULLIF(COALESCE(ccs.total_fights, 0), 0) AS DECIMAL(5, 2)) AS win_rate_percent,
  (c.Gold > 1000000) AS extreme_wealth_flag,
  (COALESCE(ccs.total_deaths, 0) > 500) AS high_death_count_flag,
  (
    COALESCE(ccs.total_fights, 0) > 100 AND
    (
      (COALESCE(ccs.total_victories, 0) / NULLIF(COALESCE(ccs.total_fights, 0), 0)) = 1 OR
      (COALESCE(ccs.total_victories, 0) / NULLIF(COALESCE(ccs.total_fights, 0), 0)) < 0.05
    )
  ) AS unusual_win_rate_flag,
  (
    (COALESCE(ccs.total_gold_from_monsters, 0) / NULLIF(c.Level, 0)) > 2000
  ) AS high_farming_yield_flag
FROM
  `character` c 
  JOIN player p ON c.Player_Userame = p.Username
  LEFT JOIN charactercombatstats ccs ON c.Name = ccs.Character_Name
WHERE
  c.IsNPC = 0; 

GRANT SELECT ON `rpg_game_db_mysql`.`system_anomaly_detection` TO 'game_system'@'%';