CREATE VIEW player_character_summary AS
SELECT
  c.Name AS character_name,
  c.Level,
  c.Experience,
  c.Gold,
  c.MaxHitPoints,
  c.MaxMana,
  p.Username AS owner,
  GROUP_CONCAT(DISTINCT cl.Name SEPARATOR ', ') AS class_names,
  GROUP_CONCAT(DISTINCT r.Name SEPARATOR ', ') AS race_names,
  COALESCE(
    GROUP_CONCAT(
      DISTINCT CONCAT(g.Name, ' (', ms.MemberStatus, ', from: ', DATE(gm.JoinedAt), ', contribution: ', gm.Contribution, ')')
      SEPARATOR '; '
    ),
    'No association to guild'
  ) AS guilds_and_statuses,
  COALESCE(inv.items_count, 0) AS inventory_item_count,
  COALESCE(CONCAT(q_latest.quest_name, ' (', q_latest.quest_status, ')'), 'No quests in log') AS latest_quest_status
FROM
  `character` c 
  JOIN player p ON c.Player_Userame = p.Username
  LEFT JOIN character_class cc ON c.Name = cc.Character_Name
  LEFT JOIN class cl ON cc.Class_Name = cl.Name
  LEFT JOIN race_character rc ON c.Name = rc.Character_Name
  LEFT JOIN race r ON rc.Race_Name = r.Name
  LEFT JOIN guildmember gm ON c.Name = gm.Character_Name
  LEFT JOIN guild g ON gm.Guild_Name = g.Name
  LEFT JOIN memberstatus ms ON gm.MemberStatus_StatusID = ms.MemberStatusID
  LEFT JOIN (
    SELECT ic.Character_Name, COUNT(*) AS items_count
    FROM iteam_character ic
    GROUP BY ic.Character_Name
  ) inv ON c.Name = inv.Character_Name
  LEFT JOIN (
    SELECT
      latest_log.Character_Name,
      q.Name AS quest_name,
      qs.StatusName AS quest_status
    FROM (
      SELECT
        ql.Character_Name,
        ql.Quest_QuestID,
        ql.QuestStatus_StatusID,
        ROW_NUMBER() OVER(PARTITION BY ql.Character_Name ORDER BY ql.StartTime DESC) as rn
      FROM
        questlog ql
    ) AS latest_log
    JOIN quest q ON latest_log.Quest_QuestID = q.QuestID
    JOIN queststatus qs ON latest_log.QuestStatus_StatusID = qs.StatusID
    WHERE latest_log.rn = 1
  ) q_latest ON c.Name = q_latest.Character_Name
WHERE
  c.IsNPC = 0 
GROUP BY
  c.Name; 

GRANT SELECT ON `rpg_game_db_mysql`.`player_character_summary` TO 'game_player'@'%';