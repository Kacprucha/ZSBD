-- TOP 10 postaci z największą liczbą pokonanych potworów
-- oraz do jakiej guildi naleza, ich całkowity zdobyty exp i gold z walk
-- grupowane wdług wygranuych walk, a następnie według procentu wygranych walk
SELECT 
    c.name,
    c.level,
    COALESCE(STRING_AGG(DISTINCT cl.name, ', '), 'Brak klasy') AS class_names,
    COALESCE(STRING_AGG(DISTINCT r.name, ', '), 'Brak rasy') AS race_names,
    COALESCE(STRING_AGG(DISTINCT gm.guild_name, ', '), 'No Guild') AS guilds,
    COUNT(cl_log.combatlogid) AS total_battles,
    SUM(CASE WHEN cl_log.victory = TRUE THEN 1 ELSE 0 END) AS victories,
    ROUND(
        CAST(SUM(CASE WHEN cl_log.victory = TRUE THEN 1 ELSE 0 END) AS DECIMAL) / 
        NULLIF(COUNT(cl_log.combatlogid), 0) * 100, 
        2
    ) AS win_rate_percent,
    SUM(CASE WHEN cl_log.victory = TRUE THEN m.expdrop ELSE 0 END) AS total_exp_from_combat,
    SUM(CASE WHEN cl_log.victory = TRUE THEN m.golddrop ELSE 0 END) AS total_gold_from_combat,
    AVG(cl_log.dmgdelt) AS avg_damage_per_fight
FROM 
    game_data.Character c
    LEFT JOIN game_data.CombatLog cl_log ON c.name = cl_log.character_name
    LEFT JOIN game_data.Monster m ON cl_log.monster_monsterid = m.monsterid
    LEFT JOIN game_data.Character_Class cc ON c.name = cc.character_name
    LEFT JOIN game_data.Class cl ON cc.class_name = cl.name
    LEFT JOIN game_data.Race_Character rc ON c.name = rc.character_name
    LEFT JOIN game_data.Race r ON rc.race_name = r.name
    LEFT JOIN game_data.GuildMember gm ON c.name = gm.character_name
GROUP BY 
    c.name, c.level
HAVING 
    COUNT(cl_log.combatlogid) > 0
ORDER BY 
    victories DESC, win_rate_percent DESC
LIMIT 10;