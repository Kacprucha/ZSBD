SET search_path TO game_data;

CREATE VIEW admin_balance_overview AS
WITH CharacterMetrics AS (
  SELECT
    COUNT(*) AS total_characters,
    AVG(Level)::numeric(5, 2) AS avg_level,
    MAX(Level) AS max_level_achieved,
    COUNT(*) FILTER (WHERE Level = 100) AS max_level_character_count,
    SUM(Gold) AS total_character_gold,
    AVG(Gold)::numeric(12, 2) AS avg_gold_per_character,
    SUM(Experience) AS total_experience_points
  FROM Character
  WHERE IsNPC = FALSE
),
PlayerMetrics AS (
  SELECT COUNT(*) AS total_active_accounts
  FROM Player
  WHERE AccountStatus_StatusID = (SELECT StatusID FROM AccountStatus WHERE StatusName = 'Active')
),
GuildMetrics AS (
  SELECT COALESCE(SUM(GuildGold), 0) AS total_guild_gold
  FROM Guild
),
RarityCounts AS (
  SELECT
    r.RarityName,
    COUNT(ic.InventoryID) AS item_count
  FROM Iteam_Character ic
  JOIN Iteam i ON ic.Iteam_IteamID = i.IteamID
  JOIN Rarity r ON i.Rarity_RarityID = r.RarityID
  GROUP BY r.RarityName
),
ItemMetrics AS (
  SELECT
    SUM(rc.item_count) AS total_items_owned_by_players,
    STRING_AGG(rc.RarityName || ': ' || rc.item_count, '; ' ORDER BY rc.item_count DESC) AS rarity_distribution
  FROM RarityCounts rc
),
RichestCharacter AS (
  SELECT Name || ' (' || Gold || ' G)' AS richest_character_info
  FROM Character
  WHERE IsNPC = FALSE
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
  (im.total_items_owned_by_players::numeric / NULLIF(cm.total_characters, 0))::numeric(10, 2) AS avg_items_per_character,
  im.rarity_distribution
FROM
  CharacterMetrics cm,
  PlayerMetrics pm,
  GuildMetrics gm,
  ItemMetrics im,
  RichestCharacter rc;

GRANT SELECT ON admin_balance_overview TO game_admin;