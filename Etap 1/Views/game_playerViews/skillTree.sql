SET search_path TO game_data;

CREATE VIEW player_skill_tree AS
SELECT
  sc.Character_Name,
  c.Level AS character_level, 
  s.Name AS skill_name,
  COALESCE(
    STRING_AGG(DISTINCT cl.Name, ', '),
    'General / Special'
  ) AS source_class,
  s.Description,
  s.Damage,
  s.CoolDown,
  s.ManaCost
FROM
  Skill_Character sc
  JOIN Skill s ON sc.skill_skillid = s.SkillID
  JOIN Character c ON sc.Character_Name = c.Name
  LEFT JOIN Class_Skill cs ON s.skillid = cs.Skill_SkillID
  LEFT JOIN Class cl ON cs.Class_Name = cl.Name
GROUP BY
  sc.Character_Name,
  c.Level,
  s.SkillID, 
  s.Name,
  s.Description,
  s.Damage,
  s.CoolDown,
  s.ManaCost;

GRANT SELECT ON player_skill_tree TO game_player, game_system;