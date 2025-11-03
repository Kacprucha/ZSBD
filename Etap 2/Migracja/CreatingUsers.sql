CREATE USER 'game_player'@'%' IDENTIFIED BY 'player123';
CREATE USER 'game_admin'@'%' IDENTIFIED BY 'admin123';
CREATE USER 'game_system'@'%' IDENTIFIED BY 'system123';
CREATE USER 'game_developer'@'%' IDENTIFIED BY 'dev123';

-- Uprawnienia dla zwykłego gracza
GRANT USAGE ON `rpg_game_db_mysql`.* TO 'game_player'@'%';

GRANT SELECT ON `rpg_game_db_mysql`.`iteam` TO 'game_player'@'%';
GRANT SELECT ON `rpg_game_db_mysql`.`quest` TO 'game_player'@'%';
GRANT SELECT ON `rpg_game_db_mysql`.`monster` TO 'game_player'@'%';
GRANT SELECT ON `rpg_game_db_mysql`.`location` TO 'game_player'@'%';
GRANT SELECT ON `rpg_game_db_mysql`.`skill` TO 'game_player'@'%';
GRANT SELECT ON `rpg_game_db_mysql`.`class` TO 'game_player'@'%';
GRANT SELECT ON `rpg_game_db_mysql`.`race` TO 'game_player'@'%';
GRANT SELECT ON `rpg_game_db_mysql`.`questlog` TO 'game_player'@'%';
GRANT SELECT ON `rpg_game_db_mysql`.`player` TO 'game_player'@'%';
GRANT SELECT ON `rpg_game_db_mysql`.`guild` TO 'game_player'@'%';
GRANT SELECT ON `rpg_game_db_mysql`.`memberstatus` TO 'game_player'@'%';
GRANT SELECT ON `rpg_game_db_mysql`.`queststatus` TO 'game_player'@'%';
GRANT SELECT ON `rpg_game_db_mysql`.`character_class` TO 'game_player'@'%';
GRANT SELECT ON `rpg_game_db_mysql`.`race_character` TO 'game_player'@'%';

GRANT UPDATE ON `rpg_game_db_mysql`.`combatlog` TO 'game_player'@'%';
GRANT UPDATE ON `rpg_game_db_mysql`.`questlog` TO 'game_player'@'%';

GRANT SELECT, INSERT, UPDATE ON `rpg_game_db_mysql`.`character` TO 'game_player'@'%';
GRANT SELECT, INSERT, UPDATE ON `rpg_game_db_mysql`.`guildmember` TO 'game_player'@'%';
GRANT SELECT, INSERT, UPDATE ON `rpg_game_db_mysql`.`skill_character` TO 'game_player'@'%';
GRANT SELECT, INSERT, UPDATE ON `rpg_game_db_mysql`.`iteam_character` TO 'game_player'@'%';



-- Uprawnienia dla systemu
GRANT USAGE ON `rpg_game_db_mysql`.* TO 'game_system'@'%';

GRANT SELECT ON `rpg_game_db_mysql`.* TO 'game_system'@'%';

GRANT INSERT, UPDATE ON `rpg_game_db_mysql`.`combatlog` TO 'game_system'@'%';
GRANT INSERT, UPDATE ON `rpg_game_db_mysql`.`questlog` TO 'game_system'@'%';
GRANT UPDATE ON `rpg_game_db_mysql`.`character` TO 'game_system'@'%';
GRANT UPDATE ON `rpg_game_db_mysql`.`guild` TO 'game_system'@'%';

-- Uprawnienia dla administratora
GRANT ALL PRIVILEGES ON `rpg_game_db_mysql`.* TO 'game_admin'@'%';

-- Uprawnienia devalopera
GRANT SELECT ON `rpg_game_db_mysql`.* TO 'game_developer'@'%';

GRANT CREATE ROUTINE, ALTER ROUTINE, CREATE VIEW ON `rpg_game_db_mysql`.* TO 'game_developer'@'%';

FLUSH PRIVILEGES;