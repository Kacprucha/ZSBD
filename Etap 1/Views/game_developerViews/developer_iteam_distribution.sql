SET search_path TO game_data;

CREATE VIEW developer_item_distribution AS
SELECT
  i.Name AS item_name,
  it.Category AS item_category,
  r.RarityName AS item_rarity,
  COUNT(ic.InventoryID) AS total_owned_by_players,
  i.Price AS purchase_price
FROM
  Iteam i
  LEFT JOIN Iteam_Character ic ON i.IteamID = ic.Iteam_IteamID
  JOIN ItemType it ON i.ItemType_CategoryID = it.TypeID
  JOIN Rarity r ON i.Rarity_RarityID = r.RarityID
GROUP BY
  i.IteamID, i.Name, it.Category, r.RarityName
ORDER BY
  total_owned_by_players DESC;

GRANT SELECT ON developer_item_distribution TO game_developer;