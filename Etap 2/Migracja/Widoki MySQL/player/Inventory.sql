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
    WHEN q.Name IS NOT NULL THEN CONCAT('Price from a quest: ', q.Name)
    ELSE 'Loot / Shope' 
  END AS item_source
FROM
  iteam_character ic
  JOIN iteam i ON ic.Iteam_IteamID = i.IteamID
  JOIN rarity r ON i.Rarity_RarityID = r.RarityID
  JOIN itemtype it ON i.ItemType_CategoryID = it.TypeID
  JOIN `character` c ON ic.Character_Name = c.Name 
  JOIN player p ON c.Player_Userame = p.Username
  LEFT JOIN quest q ON i.IteamID = q.Iteam_IteamID
GROUP BY
  p.Username,
  ic.Character_Name,
  i.IteamID, 
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

GRANT SELECT ON `rpg_game_db_mysql`.`player_inventory_view` TO 'game_player'@'%';