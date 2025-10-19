-- Tablica informacji o potworach: ile razy zostały pokonane w danej lokacji,
-- jaki jest procent szans na ich napotkanie w tej lokacji
SELECT
    m.Name AS monster_name,
    loc.Name AS location_name,
    COALESCE(kills.killed_count, 0) AS killed_count,
    ROUND(
        CAST(COALESCE(
            CASE WHEN ml.Monster_MonsterID IS NOT NULL THEN loc.MonsterDensity ELSE 0 END, 0
        ) AS DECIMAL)
        /
        NULLIF(CAST(COALESCE(md.total_density, 0) AS DECIMAL), 0)
        * 100,
        2
    ) AS chance_percent,
    CASE WHEN ml.Monster_MonsterID IS NOT NULL THEN 'YES' ELSE 'NO' END AS expected
FROM
    (
        SELECT Monster_MonsterID, Location_LocationID FROM game_data.Monster_Location
        UNION
        SELECT Monster_MonsterID, Location_LocationID FROM game_data.CombatLog WHERE Victory = TRUE
    ) all_pairs
    LEFT JOIN game_data.Monster_Location ml ON all_pairs.Monster_MonsterID = ml.Monster_MonsterID AND all_pairs.Location_LocationID = ml.Location_LocationID
    LEFT JOIN game_data.Monster m ON all_pairs.Monster_MonsterID = m.MonsterID
    LEFT JOIN game_data.Location loc ON all_pairs.Location_LocationID = loc.LocationID
    LEFT JOIN (
        SELECT
            cl.Monster_MonsterID,
            cl.Location_LocationID,
            COUNT(*) AS killed_count
        FROM game_data.CombatLog cl
        WHERE cl.Victory = TRUE
        GROUP BY cl.Monster_MonsterID, cl.Location_LocationID
    ) kills ON
        kills.Monster_MonsterID = all_pairs.Monster_MonsterID AND
        kills.Location_LocationID = all_pairs.Location_LocationID
    LEFT JOIN (
        SELECT
            ml.Monster_MonsterID,
            SUM(loc.MonsterDensity) AS total_density
        FROM game_data.Monster_Location ml
        JOIN game_data.Location loc ON ml.Location_LocationID = loc.LocationID
        GROUP BY ml.Monster_MonsterID
    ) md ON
        md.Monster_MonsterID = all_pairs.Monster_MonsterID
ORDER BY
    expected ASC,
    location_name,
    chance_percent DESC,
    monster_name;