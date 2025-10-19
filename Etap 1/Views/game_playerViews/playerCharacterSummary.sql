SET search_path TO game_data;

CREATE VIEW player_character_summary AS
SELECT
  c.Name AS character_name,
  c.Level,
  c.Experience,
  c.Gold,
  c.MaxHitPoints,
  c.MaxMana,
  p.Username AS owner,
  STRING_AGG(DISTINCT cl.Name, ', ') AS class_names,
  STRING_AGG(DISTINCT r.Name, ', ') AS race_names,
  COALESCE(
    STRING_AGG(
      DISTINCT g.Name || ' (' || ms.MemberStatus || ', from: ' || gm.JoinedAt::date || ', contribution: ' || gm.Contribution || ')',
      '; '
    ),
    'No association to guild'
  ) AS guilds_and_statuses,
  COALESCE(inv.items_count, 0) AS inventory_item_count,
  COALESCE(q_latest.quest_name || ' (' || q_latest.quest_status || ')', 'No quests in log') AS latest_quest_status
FROM
  Character c
  JOIN Player p ON c.Player_Userame = p.Username
  LEFT JOIN Character_Class cc ON c.Name = cc.Character_Name
  LEFT JOIN Class cl ON cc.Class_Name = cl.Name
  LEFT JOIN Race_Character rc ON c.Name = rc.Character_Name
  LEFT JOIN Race r ON rc.Race_Name = r.Name
  LEFT JOIN GuildMember gm ON c.Name = gm.Character_Name
  LEFT JOIN Guild g ON gm.Guild_Name = g.Name
  LEFT JOIN MemberStatus ms ON gm.MemberStatus_StatusID = ms.MemberStatusID
  LEFT JOIN (
    SELECT ic.Character_Name, COUNT(*) AS items_count
    FROM Iteam_Character ic
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
        QuestLog ql
    ) AS latest_log
    JOIN Quest q ON latest_log.Quest_QuestID = q.QuestID
    JOIN QuestStatus qs ON latest_log.QuestStatus_StatusID = qs.StatusID
    WHERE latest_log.rn = 1 
  ) q_latest ON c.Name = q_latest.Character_Name
WHERE
  c.IsNPC = FALSE
GROUP BY
  c.Name,
  c.Level,
  c.Experience,
  c.Gold,
  c.MaxHitPoints,
  c.MaxMana,
  p.Username,
  inv.items_count,
  q_latest.quest_name,
  q_latest.quest_status;

GRANT SELECT ON player_character_summary TO game_player, game_system;