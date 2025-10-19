SET search_path TO game_data;

CREATE VIEW system_anomaly_detection AS
WITH CharacterCombatStats AS (
  SELECT
    cl.Character_Name,
    COUNT(cl.CombatLogID) AS total_fights,
    SUM(CASE WHEN cl.Victory THEN 1 ELSE 0 END) AS total_victories,
    SUM(CASE WHEN NOT cl.Victory THEN 1 ELSE 0 END) AS total_deaths,
    SUM(CASE WHEN cl.Victory THEN m.GoldDrop ELSE 0 END) AS total_gold_from_monsters,
    SUM(CASE WHEN cl.Victory THEN m.ExpDrop ELSE 0 END) AS total_exp_from_monsters
  FROM
    CombatLog cl
    JOIN Monster m ON cl.Monster_MonsterID = m.MonsterID
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
  (COALESCE(ccs.total_victories, 0)::numeric / NULLIF(COALESCE(ccs.total_fights, 0), 0) * 100)::numeric(5, 2) AS win_rate_percent,
  CASE
    WHEN c.Gold > 1000000 THEN TRUE 
    ELSE FALSE
  END AS extreme_wealth_flag,
  CASE
    WHEN ccs.total_deaths > 500 THEN TRUE 
    ELSE FALSE
  END AS high_death_count_flag,
  CASE
    WHEN ccs.total_fights > 100 AND
         ( (COALESCE(ccs.total_victories, 0)::numeric / ccs.total_fights) = 1 OR
           (COALESCE(ccs.total_victories, 0)::numeric / ccs.total_fights) < 0.05 ) THEN TRUE
    ELSE FALSE
  END AS unusual_win_rate_flag,
  CASE
    WHEN (COALESCE(ccs.total_gold_from_monsters, 0)::numeric / c.Level) > 2000 THEN TRUE -- Próg "złoto/poziom" do kalibracji
    ELSE FALSE
  END AS high_farming_yield_flag
FROM
  Character c
  JOIN Player p ON c.Player_Userame = p.Username
  LEFT JOIN CharacterCombatStats ccs ON c.Name = ccs.Character_Name
WHERE
  c.IsNPC = FALSE;

GRANT SELECT ON system_anomaly_detection TO game_system;