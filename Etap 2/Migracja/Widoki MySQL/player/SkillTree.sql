CREATE VIEW player_skill_tree AS
SELECT
  sc.Character_Name,
  c.Level AS character_level,
  s.Name AS skill_name,
  COALESCE(
    GROUP_CONCAT(DISTINCT cl.Name SEPARATOR ', '),
    'General / Special'
  ) AS source_class,
  s.Description,
  s.Damage,
  s.CoolDown,
  s.ManaCost
FROM
  skill_character sc
  JOIN skill s ON sc.Skill_SkillID = s.SkillID
  JOIN `character` c ON sc.Character_Name = c.Name
  LEFT JOIN class_skill cs ON s.SkillID = cs.Skill_SkillID
  LEFT JOIN class cl ON cs.Class_Name = cl.Name

GRANT SELECT ON `rpg_game_db_mysql`.`player_skill_tree` TO 'game_player'@'%';