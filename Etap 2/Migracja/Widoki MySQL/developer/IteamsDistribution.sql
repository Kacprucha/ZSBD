CREATE VIEW developer_item_distribution AS
SELECT
  i.Name AS item_name,
  it.Category AS item_category,
  r.RarityName AS item_rarity,
  COUNT(ic.InventoryID) AS total_owned_by_players,
  i.Price AS purchase_price
FROM
  iteam i
  LEFT JOIN iteam_character ic ON i.IteamID = ic.Iteam_IteamID
  JOIN itemtype it ON i.ItemType_CategoryID = it.TypeID
  JOIN rarity r ON i.Rarity_RarityID = r.RarityID
GROUP BY
  i.IteamID, i.Name, it.Category, r.RarityName, i.Price 
ORDER BY
  total_owned_by_players DESC;

GRANT SELECT ON `rpg_game_db_mysql`.`developer_item_distribution` TO 'game_developer'@'%';