-- Tworzenie użytkowników
CREATE USER game_player WITH PASSWORD 'player123';
CREATE USER game_admin WITH PASSWORD 'admin123';
CREATE USER game_system WITH PASSWORD 'system123';
CREATE USER game_developer WITH PASSWORD 'dev123';

-- Uprawnienia dla zwykłego gracza
GRANT CONNECT ON DATABASE rpg_game_db TO game_player;
GRANT USAGE ON SCHEMA game_data TO game_player;

GRANT SELECT ON 
    game_data.Iteam, 
    game_data.Quest, 
    game_data.Monster, 
    game_data.Location, 
    game_data.Skill, 
    game_data.Class, 
    game_data.Race,
    game_data.QuestLog,
    game_data.Player, 
    game_data.Guild,
    game_data.MemberStatus, 
    game_data.QuestStatus,
    game_data.Character_Class, 
    game_data.Race_Character
TO game_player;
GRANT UPDATE ON 
    game_data.CombatLog,
    game_data.QuestLog
TO game_player;
GRANT SELECT, INSERT, UPDATE ON 
    game_data.Character,
    game_data.GuildMember, 
    game_data.Skill_Character, 
    game_data.Iteam_Character 
TO game_player;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA game_data TO game_player;

-- Uprawnienia dla systemu
GRANT CONNECT ON DATABASE rpg_game_db TO game_system;
GRANT USAGE ON SCHEMA game_data TO game_system;

GRANT SELECT ON ALL TABLES IN SCHEMA game_data TO game_system;
GRANT INSERT, UPDATE, SELECT ON 
    game_data.CombatLog, 
    game_data.QuestLog 
TO game_system;
GRANT UPDATE, SELECT ON 
    game_data.Character, 
    game_data.Guild 
TO game_system;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA game_data TO game_system;

-- Uprawnienia dla administratora
GRANT ALL PRIVILEGES ON DATABASE rpg_game_db TO game_admin;
GRANT USAGE ON SCHEMA game_data TO game_admin;
GRANT CREATE ON SCHEMA game_data TO game_admin;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA game_data TO game_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA game_data TO game_admin;

-- Uprawnienia devalopera
GRANT CONNECT ON DATABASE rpg_game_db TO game_developer;
GRANT USAGE ON SCHEMA game_data TO game_developer;
GRANT SELECT ON ALL TABLES IN SCHEMA game_data TO game_developer;