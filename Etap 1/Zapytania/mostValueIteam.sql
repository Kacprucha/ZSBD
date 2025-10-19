-- Znajdź najbardziej wartościowe przedmioty legendary/epic,
-- a nastepnie pokaż ile postaci je posiada i jaki jest średni level tych postaci
-- oraz dodatkowo w ilu questach jest to nagorda
WITH ItemOwnership AS (
    SELECT 
        i.IteamID,
        i.Name AS item_name,
        r.RarityName AS rarity,
        i.Price AS value,
        (COALESCE(i.AtackBonus,0) + COALESCE(i.DefenceBonus,0) + COALESCE(i.MagicBonus,0)) AS total_stats,
        COUNT(DISTINCT ic.Character_Name) as owners_count,
        AVG(c.level) as avg_owner_level
    FROM 
        game_data.Iteam i
        JOIN game_data.Rarity r ON i.Rarity_RarityID = r.RarityID
        LEFT JOIN game_data.Iteam_Character ic ON i.IteamID = ic.Iteam_IteamID
        LEFT JOIN game_data.Character c ON ic.Character_Name = c.Name
    WHERE 
        r.RarityName IN ('Legendary', 'Epic')
    GROUP BY 
        i.IteamID, i.Name, r.RarityName, i.Price, i.AtackBonus, i.DefenceBonus, i.MagicBonus
)
SELECT 
    io.item_name,
    io.rarity,
    io.value,
    io.total_stats,
    io.owners_count,
    ROUND(io.avg_owner_level, 2) as avg_owner_level,
    (
        SELECT COUNT(*) 
        FROM game_data.Quest q
        WHERE q.Iteam_IteamID = io.IteamID
    ) as quest_rewards_count,
    (
        SELECT MAX(c2.level)
        FROM game_data.Iteam_Character ic2
        JOIN game_data.Character c2 ON ic2.Character_Name = c2.Name
        WHERE ic2.Iteam_IteamID = io.IteamID
    ) as highest_owner_level
FROM 
    ItemOwnership io
ORDER BY 
    io.value DESC, io.total_stats DESC;