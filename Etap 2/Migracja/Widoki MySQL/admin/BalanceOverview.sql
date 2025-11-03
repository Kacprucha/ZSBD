CREATE VIEW admin_balance_overview AS
WITH
CharacterMetrics AS (
  SELECT
    COUNT(*) AS total_characters,
    CAST(AVG(Level) AS DECIMAL(5, 2)) AS avg_level,
    MAX(Level) AS max_level_achieved,
    SUM(CASE WHEN Level = 100 THEN 1 ELSE 0 END) AS max_level_character_count,
    SUM(Gold) AS total_character_gold,
    CAST(AVG(Gold) AS DECIMAL(12, 2)) AS avg_gold_per_character,
    SUM(Experience) AS total_experience_points
  FROM `character`
  WHERE IsNPC = 0 
),
PlayerMetrics AS (
  SELECT COUNT(*) AS total_active_accounts
  FROM player
  WHERE AccountStatus_StatusID = (SELECT StatusID FROM accountstatus WHERE StatusName = 'Active')
),
GuildMetrics AS (
  SELECT COALESCE(SUM(GuildGold), 0) AS total_guild_gold
  FROM guild
),
RarityCounts AS (
  SELECT
    r.RarityName,
    COUNT(ic.InventoryID) AS item_count
  FROM iteam_character ic
  JOIN iteam i ON ic.Iteam_IteamID = i.IteamID
  JOIN rarity r ON i.Rarity_RarityID = r.RarityID
  GROUP BY r.RarityName
),
ItemMetrics AS (
  SELECT
    SUM(rc.item_count) AS total_items_owned_by_players,
    GROUP_CONCAT(CONCAT(rc.RarityName, ': ', rc.item_count) ORDER BY rc.item_count DESC SEPARATOR '; ') AS rarity_distribution
  FROM rarityCounts rc
),
RichestCharacter AS (
  SELECT
    CONCAT(Name, ' (', Gold, ' G)') AS richest_character_info
  FROM `character`
  WHERE IsNPC = 0
  ORDER BY Gold DESC
  LIMIT 1
)
SELECT
  pm.total_active_accounts,
  cm.total_characters,
  cm.avg_level,
  cm.max_level_achieved,
  cm.max_level_character_count,
  cm.total_experience_points,
  cm.total_character_gold,
  gm.total_guild_gold,
  (cm.total_character_gold + gm.total_guild_gold) AS grand_total_gold_in_economy,
  cm.avg_gold_per_character,
  rc.richest_character_info,
  im.total_items_owned_by_players,
  CAST(im.total_items_owned_by_players / NULLIF(cm.total_characters, 0) AS DECIMAL(10, 2)) AS avg_items_per_character,
  im.rarity_distribution
FROM
  charactermetrics cm,
  PlayerMetrics pm,
  GuildMetrics gm,
  ItemMetrics im,
  RichestCharacter rc;

GRANT SELECT ON `rpg_game_db_mysql`.`admin_balance_overview` TO 'game_admin'@'%';