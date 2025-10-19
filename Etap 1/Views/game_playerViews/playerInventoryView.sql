SET search_path TO game_data;

CREATE VIEW player_inventory_view AS
SELECT
  p.Username AS owner_username,
  ic.Character_Name,
  i.Name AS item_name,
  COUNT(i.IteamID) AS quantity, 
  it.Category AS item_category,
  r.RarityName AS item_rarity,
  i.Description,
  i.AtackBonus,
  i.DefenceBonus,
  i.MagicBonus,
  i.Price AS purchase_price,
  i.RetailPrice AS sell_price,
  CASE
    WHEN q.Name IS NOT NULL THEN 'Price from a quest: ' || q.Name
    ELSE 'Loot / Shope'
  END AS item_source
FROM
  Iteam_Character ic
  JOIN Iteam i ON ic.Iteam_IteamID = i.IteamID
  JOIN Rarity r ON i.rarity_rarityid = r.RarityID
  JOIN ItemType it ON i.ItemType_CategoryID = it.TypeID
  JOIN Character c ON ic.Character_Name = c.Name
  JOIN Player p ON c.Player_Userame = p.Username
  LEFT JOIN Quest q ON i.IteamID = q.Iteam_IteamID
GROUP BY
  p.Username,
  ic.Character_Name,
  i.Name,
  it.Category,
  r.RarityName,
  i.Description,
  i.AtackBonus,
  i.DefenceBonus,
  i.MagicBonus,
  i.Price,
  i.RetailPrice,
  q.Name;

  GRANT SELECT ON player_inventory_view TO game_player, game_system;