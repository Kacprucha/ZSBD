-- wypelnienie bazy danymi testowymi
SET search_path TO game_data;

-- tabelki slownikowe
-- AccountStatus
INSERT INTO AccountStatus (StatusName) VALUES 
('Active'), 
('Banned'), 
('Inactive');

-- MemberStatus
INSERT INTO MemberStatus (MemberStatus) VALUES 
('Leader'), 
('Officer'), 
('Member'), 
('Initiate');

-- ItemType
INSERT INTO ItemType (Category) VALUES 
('Weapon'), 
('Armor'),
('Shield'),
('Potion'), 
('Quest Item'),
('Junk');

-- Rarity
INSERT INTO Rarity (RarityName) VALUES 
('Common'), 
('Uncommon'), 
('Rare'), 
('Epic'), 
('Legendary');

-- LocationType
INSERT INTO LocationType (TypeName) VALUES 
('Town'), 
('Forest'),
('Dungeon'), 
('Mountain'), 
('Cave');

-- Tabela: QuestStatus
INSERT INTO QuestStatus (StatusName) VALUES
('Available'),
('In_Progress'),
('Completed'),
('Failed');

-- tabele niezależne
-- Tabela: Race
INSERT INTO Race (Name, Description, FightBonus, MagicBonus) VALUES
('Human', 'Versatile and adaptable, with balanced skills.', 5, 5),
('Elf', 'Graceful and agile, masters of archery and light magic.', 2, 8),
('Dwarf', 'Sturdy and strong, excellent fighters and crafters.', 8, 2),
('Orc', 'Fierce and powerful, known for their brute strength.', 10, 0),
('Undead', 'Resilient and dark, with a knack for necromancy.', 4, 6),
('Hobbit', 'Small and stealthy, great at avoiding danger.', 3, 4);

-- Tabela: Class
INSERT INTO Class (Name, Description, BaseMana, BaseHealth) VALUES
('Warrior', 'Master of melee combat, uses heavy armor and weapons.', 50, 150),
('Mage', 'Wielder of powerful arcane magic.', 150, 80),
('Rogue', 'Cunning and agile, excels in stealth and precision.', 80, 100),
('Archer', 'Master of the bow, attacks from a distance.', 90, 90);

-- Tabela: Skill
INSERT INTO Skill (Name, Description, Damage, CoolDown, ManaCost) VALUES
('Heavy Strike', 'A powerful swing that deals significant damage.', 30, 5, 10),
('Fireball', 'Launches a ball of fire at the enemy.', 40, 8, 30),
('Backstab', 'A surprise attack that deals critical damage.', 50, 12, 25),
('Aimed Shot', 'A precise shot that rarely misses.', 35, 6, 20),
('Heal', 'A minor healing spell.', 0, 10, 25),
('Shield Bash', 'Stuns the enemy with a powerful shield strike.', 20, 8, 15),
('Whirlwind', 'Spin attack that damages all nearby enemies.', 25, 10, 20),
('Battle Cry', 'Increases damage for a short duration.', 0, 15, 10),
('Ice Lance', 'Pierces the enemy with a shard of ice.', 35, 6, 25),
('Arcane Blast', 'Unleashes raw arcane energy.', 45, 10, 35),
('Mana Shield', 'Absorbs damage using mana.', 0, 12, 30),
('Poison Blade', 'Coats weapon with deadly poison.', 28, 7, 18),
('Shadow Step', 'Teleports behind the enemy.', 15, 9, 22),
('Smoke Bomb', 'Creates cover to escape or reposition.', 0, 14, 20),
('Multi-Shot', 'Fires arrows at multiple targets.', 22, 8, 18),
('Explosive Arrow', 'Arrow that explodes on impact.', 42, 11, 28),
('Eagle Eye', 'Increases accuracy and critical chance.', 0, 13, 15),
('Ancient Strike', 'A forgotten technique of immense power.', 60, 15, 40),
('Life Drain', 'Steals health from the enemy.', 25, 9, 30),
('Berserk Rage', 'Sacrifice defense for massive damage boost.', 0, 20, 25),
('Mystic Ward', 'Creates a protective barrier.', 0, 16, 35),
('Thunderclap', 'Calls down lightning to strike foes.', 48, 12, 32),
('Soul Burn', 'Burns the enemy soul, dealing damage over time.', 35, 10, 28),
('Meteor Strike', 'Summons a meteor from the sky.', 70, 18, 50),
('Invisibility', 'Become invisible for a short time.', 0, 20, 30),
('Blood Pact', 'Sacrifice health to gain temporary power.', 0, 25, 0),
('Divine Light', 'Heals and removes debuffs.', 0, 14, 40),
('Chaos Bolt', 'Unpredictable magic with random effects.', 38, 11, 27),
('Nature Call', 'Summons forest creatures to aid in battle.', 30, 15, 33);

-- Monster
INSERT INTO Monster (Name, Level, HitPoints, Atack, Defence, ExpDrop, GoldDrop) VALUES
('Goblin', 3, 50, 10, 5, 20, 15),
('Skeleton', 5, 80, 15, 10, 35, 25),
('Forest Spider', 8, 120, 25, 15, 60, 40),
('Orc Brute', 12, 200, 40, 30, 100, 80),
('Cave Troll', 15, 350, 50, 40, 150, 120),
('Slime', 1, 15, 3, 1, 5, 2),
('Forest Wolf', 4, 60, 12, 6, 25, 18),
('Bandit', 6, 90, 18, 8, 40, 30),
('Giant Spider', 9, 140, 28, 12, 75, 45),
('Wraith', 11, 160, 35, 20, 120, 60),
('Bandit Archer', 7, 100, 22, 7, 50, 35),
('Wyvern', 18, 420, 70, 35, 350, 220),
('Fire Elemental', 14, 280, 60, 25, 220, 150),
('Ice Golem', 16, 360, 55, 60, 300, 180),
('Necromancer', 20, 240, 45, 30, 500, 300),
('Stone Guardian', 22, 600, 80, 75, 800, 500),
('Shadow Stalker', 10, 180, 42, 18, 150, 90);

-- tabele zależne 
-- Player
INSERT INTO Player (Username, Email, Password_hash, AccountStatus_StatusID) VALUES
('User1', 'user1@email.com', '\xDEADBEEF', 1),
('User2', 'user2@email.com', '\xCAFEBABE', 1),
('User3', 'user3@email.com', '\xFEEDFACE', 1),
('User4', 'user4@email.com', '\x8BADF00D', 1),
('User5', 'user5@email.com', '\xDEADCAFE', 1),
('User6', 'user6@email.com', '\xB16B00B5', 1),
('User7', 'user7@email.com', '\x0BADC0DE', 1),
('User8', 'user8@email.com', '\xF00DBABE', 1),
('User9', 'user9@email.com', '\xC0FFEE00', 1),
('User10', 'user10@email.com', '\xFACEFEED', 1),
('User11', 'user11@email.com', '\xBAADF00D', 1),
('User12', 'user12@email.com', '\xDEAD10CC', 1),
('BannedUser', 'banned@email.com', '\xBADF00DD', 2);

-- Character
INSERT INTO Character (Name, IsNPC, Level, MaxHitPoints, MaxMana, Gold, Experience, Player_Userame) VALUES
('Aragorn', false, 10, 160, 60, 500, 1200, 'User1'),
('Legolas', false, 12, 110, 100, 850, 1800, 'User2'),
('Gimli', false, 8, 200, 40, 300, 900, 'User3'),
('Thrall', false, 15, 250, 80, 1200, 2500, 'User4'),
('Sylvanas', false, 14, 130, 120, 950, 2200, 'User5'),
('Jaina', false, 13, 100, 150, 1100, 2000, 'User6'),
('Uther', false, 11, 180, 70, 600, 1400, 'User7'),
('Illidan', false, 16, 220, 90, 1300, 2700, 'User8'),
('Malfurion', false, 12, 140, 130, 800, 1750, 'User9'),
('Tyrande', false, 13, 120, 140, 900, 1900, 'User10'),
('KelThuzad', false, 14, 150, 160, 1000, 2100, 'User11'),
('Ragnaros', false, 20, 300, 200, 2000, 4000, 'User12'),
('Boromir', false, 9, 170, 50, 400, 1000, 'User1'),
('Frodo', false, 7, 90, 30, 200, 600, 'User2'),
('Samwise', false, 7, 95, 35, 250, 650, 'User3'),
('BobTheBard', false, 5, 80, 50, 100, 250, 'User4'),
('Gandalf', true, 50, 500, 1500, 9999, 99999, NULL); 

-- Location
INSERT INTO Location (Name, LocatioType_TypeID, IsSafeZone, RecomenedLevel, MonsterDensity) VALUES
('Riverwood', 1, false, 1, 5),
('WhisperingWoods', 2, false, 5, 60),
('Goblin Cave', 5, false, 8, 70),
('Ironhold', 1, false, 10, 10),
('DragonPeak', 4, false, 20, 85),
('Sunnyvale', 1, true, 1, 0),
('Bag End', 1, true, 1, 0);

-- Guild
INSERT INTO Guild (Name, Leader_Name, GuildGold, MinLevel, Reputation) VALUES
('TheRangers', 'Aragorn', 1000, 10, 500),
('ShadowClan', 'Sylvanas', 1500, 12, 700),
('MagesGuild', 'Jaina', 2000, 15, 900);

-- Iteam
INSERT INTO Iteam (Name, Description, ItemType_CategoryID, Rarity_RarityID, Price, RetailPrice, AtackBonus, DefenceBonus, MagicBonus) VALUES
('Iron Sword', 'A basic but reliable sword.', 1, 1, 100, 50, 10, 0, 0),
('Leather Armor', 'Simple armor made from boiled leather.', 2, 1, 150, 75, 0, 15, 0),
('Health Potion', 'Restores a small amount of health.', 4, 1, 50, 25, 0, 0, 0),
('Goblin Ear', 'A proof of a slain goblin. Smells awful.', 5, 2, 1, 0, 0, 0, 0),
('DragonBlade', 'A legendary sword pulsating with power.', 1, 5, 100000, 50000, 150, 20, 20),
('Mystic Robe', 'A robe imbued with magical properties.', 2, 4, 5000, 2500, 0, 10, 50),
('Shield of Valor', 'A sturdy shield that has seen many battles.', 3, 3, 2000, 1000, 0, 40, 0),
('Elven Bow', 'A finely crafted bow made by elven artisans.', 1, 4, 8000, 4000, 80, 0, 10),
('Cave Map', 'A map detailing the layout of Goblin Cave.', 5, 2, 500, 0, 0, 0, 0),
('Potion of Mana', 'Restores a small amount of mana.', 4, 1, 60, 30, 0, 0, 0),
('Bandit Dagger', 'A sharp dagger used by bandits.', 1, 2, 300, 150, 25, 0, 0),
('Healing Herb', 'A common herb used in healing potions.', 4, 1, 20, 10, 0, 0, 0),
('Legendary Staff', 'A staff said to be wielded by ancient mages.', 1, 5, 120000, 60000, 100, 0, 200),
('Epic Armor Set', 'Armor set worn by legendary heroes.', 2, 5, 90000, 45000, 0, 100, 50),
('Cloak of Invisibility', 'A magical cloak that grants temporary invisibility.', 2, 5, 150000, 75000, 0, 20, 100),
('Dragon Slayer Sword', 'A sword specifically designed to slay dragons.', 1, 5, 200000, 100000, 200, 30, 30);

-- Quest
INSERT INTO Quest (Name, Description, Giver, GoldReward, Iteam_IteamID, Location_LocationID) VALUES
('Goblin Menace', 'Clear the nearby cave of goblins.', 'BobTheBard', 100, NULL, 3),
('Lost Scroll', 'Find the ancient scroll in WhisperingWoods.', 'Gandalf', 0, 13, 2),
('Dragon Hunt', 'Slay the dragon on DragonPeak.', 'Thrall', 0, 16, 5),
('Escort the Merchant', 'Protect the merchant traveling to Ironhold.', 'Uther', 200, NULL, 4),
('Herbal Remedy', 'Collect herbs from WhisperingWoods for Jaina.', 'Jaina', 0, 3, 2),
('Defend the Village', 'Help defend Riverwood from bandit attacks.', 'Aragorn', 150, NULL, 1),
('Cave Exploration', 'Explore the depths of Goblin Cave.', 'Gimli', 0, 9, 3),
('Mountain Rescue', 'Rescue lost hikers on DragonPeak.', 'Sylvanas', 300, NULL, 5),
('Ancient Artifact', 'Retrieve an ancient artifact from WhisperingWoods.', 'Malfurion', 0, 11, 2),
('Bandit Leader', 'Defeat the bandit leader terrorizing Ironhold.', 'Uther', 400, NULL, 4);

-- GuildMember
INSERT INTO GuildMember (Character_Name, Guild_Name, MemberStatus_StatusID, IsBand, JoinedAt, Contribution) VALUES
('Aragorn', 'TheRangers', 1, false, '2025-01-10 15:00:00', 1000),
('Legolas', 'TheRangers', 3, false, '2025-01-12 18:30:00', 500),
('Sylvanas', 'ShadowClan', 1, false, '2025-01-15 20:00:00', 1500),
('Jaina', 'MagesGuild', 1, false, '2025-01-20 14:00:00', 2000),
('Gimli', 'TheRangers', 4, false, '2025-01-22 16:45:00', 300),
('Thrall', 'MagesGuild', 2, false, '2025-01-25 19:15:00', 800),
('Uther', 'ShadowClan', 3, false, '2025-01-28 13:30:00', 600),
('Malfurion', 'MagesGuild', 4, false, '2025-01-30 17:00:00', 400);

-- QuestLog
INSERT INTO QuestLog (Character_Name, Quest_QuestID, QuestStatus_StatusID, AtemptNumber, StartTime, EndTime) VALUES
('Aragorn', 1, 2, 1, '2025-02-01 10:00:00', NULL), -- In progress
('Legolas', 1, 3, 1, '2025-01-20 12:00:00', '2025-01-20 18:00:00'), -- Completed
('Gimli', 7, 2, 1, '2025-02-02 14:00:00', NULL), -- In progress
('Thrall', 3, 3, 1, '2025-01-15 09:00:00', '2025-01-16 11:00:00'), -- Completed
('Sylvanas', 8, 2, 1, '2025-02-03 16:00:00', NULL), -- In progress
('Jaina', 5, 3, 1, '2025-01-18 08:00:00', '2025-01-18 12:00:00'), -- Completed
('Uther', 4, 4, 1, '2025-01-22 13:00:00', '2025-01-23 15:00:00'), -- Failed
('Malfurion', 9, 2, 1, '2025-02-04 11:00:00', NULL), -- In progress
('Aragorn', 6, 3, 1, '2025-01-25 10:00:00', '2025-01-25 16:00:00'), -- Completed
('Legolas', 2, 4, 1, '2025-01-28 14:00:00', '2025-01-29 18:00:00'), -- Failed
('Gandalf', 10, 3, 1, '2025-01-10 09:00:00', '2025-01-11 12:00:00'), -- Completed
('BobTheBard', 1, 3, 2, '2025-01-05 11:00:00', '2025-01-05 17:00:00'), -- Completed
('BobTheBard', 1, 4, 1, '2025-01-15 10:00:00', '2025-01-16 14:00:00'), -- Failed
('BobTheBard', 3, 2, 1, '2025-02-05 15:00:00', NULL), -- In progress
('Uther', 4, 3, 1, '2025-01-30 12:00:00', '2025-01-31 16:00:00'), -- Completed
('Malfurion', 9, 4, 1, '2025-01-20 14:00:00', '2025-01-21 18:00:00'), -- Failed
('Jaina', 5, 2, 1, '2025-02-06 09:00:00', NULL); -- In progress

-- CombatLog
INSERT INTO CombatLog (Character_Name, Monster_MonsterID, Location_LocationID, Victory, DmgTaken, DmgDelt) VALUES
('Aragorn', 1, 3, true, 20, 55),
('Aragorn', 1, 2, true, 25, 60),
('Legolas', 3, 2, true, 50, 130),
('Legolas', 2, 3, false, 85, 40),
('Gimli', 1, 3, true, 30, 70),
('Thrall', 4, 5, true, 100, 220),
('Sylvanas', 5, 5, true, 120, 300),
('Jaina', 2, 3, true, 40, 150),
('Uther', 1, 2, false, 60, 30),
('Malfurion', 3, 2, true, 70, 160),
('Aragorn', 2, 3, true, 40, 90),
('Legolas', 1, 3, true, 30, 80),
('Gimli', 2, 3, false, 90, 50),
('Thrall', 5, 5, true, 130, 350),
('Sylvanas', 4, 5, true, 110, 280),
('Jaina', 3, 2, true, 60, 170),
('Uther', 2, 3, true, 50, 100),
('Malfurion', 1, 3, true, 30, 85),
('Gandalf', 5, 5, true, 200, 500),
('BobTheBard', 1, 3, true, 15, 45),
('BobTheBard', 1, 2, true, 10, 40),
('BobTheBard', 3, 2, false, 60, 25),
('BobTheBard', 2, 3, true, 25, 70),
('Boromir', 4, 5, false, 180, 95),
('Boromir', 1, 3, true, 25, 60),
('Frodo', 6, 3, true, 5, 18),
('Samwise', 9, 2, false, 65, 40),
('KelThuzad', 15, 3, false, 120, 80),
('Ragnaros', 13, 5, true, 40, 260),
('Illidan', 17, 3, true, 35, 110),
('Tyrande', 11, 2, true, 30, 90),
('Gandalf', 16, 5, false, 220, 150),
('Malfurion', 7, 3, true, 15, 90),
('Uther', 12, 3, true, 10, 150),
('Jaina', 14, 3, true, 21, 200);

-- Tabele asocjacyjne
-- Race_Character
INSERT INTO Race_Character (Race_Name, Character_Name) VALUES
('Human', 'Aragorn'),
('Elf', 'Legolas'),
('Human', 'Gandalf'),
('Dwarf', 'BobTheBard'),
('Orc', 'Thrall'),
('Elf', 'Sylvanas'),
('Human', 'Jaina'),
('Human', 'Uther'),
('Elf', 'Malfurion'),
('Dwarf', 'Gimli'),
('Human', 'Boromir'),
('Hobbit', 'Frodo'),
('Hobbit', 'Samwise'),
('Human', 'Ragnaros'),
('Undead', 'KelThuzad'),
('Elf', 'Tyrande'),
('Undead', 'Illidan');

-- Character_Class
INSERT INTO Character_Class (Character_Name, Class_Name) VALUES
('Aragorn', 'Warrior'),
('Legolas', 'Archer'),
('Gandalf', 'Mage'),
('BobTheBard', 'Rogue'),
('Thrall', 'Warrior'),
('Sylvanas', 'Archer'),
('Jaina', 'Mage'),
('Uther', 'Warrior'),
('Malfurion', 'Mage'),
('Gimli', 'Warrior'),
('Boromir', 'Warrior'),
('Frodo', 'Rogue'),
('Samwise', 'Rogue'),
('Ragnaros', 'Mage'),
('KelThuzad', 'Mage'),
('Tyrande', 'Archer'),
('Illidan', 'Rogue');

-- Class_Skill
INSERT INTO Class_Skill (Class_Name, Skill_SkillID) VALUES
('Warrior', 1),
('Warrior', 6),
('Warrior', 7),
('Warrior', 8),
('Mage', 2),
('Mage', 9),
('Mage', 10),
('Mage', 11),
('Mage', 5),
('Rogue', 3),
('Rogue', 12),
('Rogue', 13),
('Rogue', 14),
('Archer', 4),
('Archer', 15),
('Archer', 16),
('Archer', 17);

-- Skill_Character
INSERT INTO Skill_Character (Skill_SkillID, Character_Name) VALUES
(1, 'Aragorn'),
(6, 'Aragorn'),  
(7, 'Aragorn'),  
(18, 'Aragorn'),

(4, 'Legolas'),
(15, 'Legolas'), 
(16, 'Legolas'), 
(24, 'Legolas'),

(1, 'Gimli'),    
(6, 'Gimli'),    
(8, 'Gimli'),    
(21, 'Gimli'),

(1, 'Thrall'),   
(7, 'Thrall'),   
(22, 'Thrall'),  
(27, 'Thrall'),

(4, 'Sylvanas'), 
(15, 'Sylvanas'),
(14, 'Sylvanas'), 
(23, 'Sylvanas'), 

(2, 'Jaina'),
(9, 'Jaina'),
(10, 'Jaina'),
(11, 'Jaina'),

(1, 'Uther'),
(6, 'Uther'),
(5, 'Uther'),
(25, 'Uther'),

(3, 'Illidan'),
(12, 'Illidan'),
(13, 'Illidan'),
(19, 'Illidan'),
(26, 'Illidan'),

(2, 'Malfurion'),
(5, 'Malfurion'),
(27, 'Malfurion'),
(22, 'Malfurion'),

(4, 'Tyrande'),
(15, 'Tyrande'),
(5, 'Tyrande'), 
(25, 'Tyrande'),

(2, 'KelThuzad'),
(10, 'KelThuzad'),
(19, 'KelThuzad'),
(23, 'KelThuzad'),

(2, 'Ragnaros'),
(20, 'Ragnaros'),
(22, 'Ragnaros'),
(24, 'Ragnaros'),
(28, 'Ragnaros'),

(1, 'Boromir'),
(6, 'Boromir'),
(8, 'Boromir'),

(14, 'Frodo'), 
(24, 'Frodo'), 

(1, 'Samwise'),
(8, 'Samwise'),
(25, 'Samwise'),

(5, 'BobTheBard'),
(8, 'BobTheBard'),
(17, 'BobTheBard'),
(28, 'BobTheBard'),

(2, 'Gandalf'), 
(5, 'Gandalf'), 
(10, 'Gandalf'),
(18, 'Gandalf'),
(24, 'Gandalf'),
(25, 'Gandalf'),
(28, 'Gandalf');

-- Iteam_Character
INSERT INTO Iteam_Character (Iteam_IteamID, Character_Name) VALUES
(1, 'Aragorn'),
(2, 'Aragorn'),
(3, 'Aragorn'),
(3, 'Legolas'),
(8, 'Legolas'),
(4, 'BobTheBard'),
(12, 'BobTheBard'),
(10, 'Gandalf'),
(6, 'Gandalf'),
(7, 'Gandalf'),
(13, 'Jaina'),
(14, 'Sylvanas'),
(15, 'Thrall'),
(11, 'Legolas'),
(9, 'Gimli'),
(2, 'Uther'),
(1, 'Boromir'),
(1, 'Frodo'),
(1, 'Samwise'),
(3, 'Boromir'),
(3, 'Frodo'),
(3, 'Samwise'),
(16, 'Aragorn'),
(16, 'Illidan'),
(5,  'Boromir'),
(13, 'Gandalf'),
(13, 'Ragnaros'),
(13, 'KelThuzad'),
(14, 'Gimli'),
(14, 'Thrall'),
(15, 'Sylvanas'),
(15, 'BobTheBard'),
(6,  'Jaina'),
(6,  'Malfurion');  

-- Monster_Location 
INSERT INTO Monster_Location (Monster_MonsterID, Location_LocationID) VALUES
(1, 2), -- Goblin in WhisperingWoods
(1, 3), -- Goblin in Goblin Cave
(2, 3), -- Skeleton in Goblin Cave
(3, 2), -- Forest Spider in WhisperingWoods
(4, 5), -- Orc Brute on DragonPeak
(5, 5), -- Cave Troll on DragonPeak
(6, 3),  -- Slime -> Goblin Cave
(6, 2),  -- Slime -> WhisperingWoods
(7, 2),  -- Forest Wolf -> WhisperingWoods
(7, 1),  -- Forest Wolf -> Riverwood
(8, 4),  -- Bandit -> Ironhold
(8, 2),  -- Bandit -> WhisperingWoods
(9, 3),  -- Giant Spider -> Goblin Cave
(9, 2),  -- Giant Spider -> WhisperingWoods
(10, 3), -- Wraith -> Goblin Cave
(10, 5), -- Wraith -> DragonPeak
(11, 4), -- Bandit Archer -> Ironhold
(11, 2), -- Bandit Archer -> WhisperingWoods
(12, 5), -- Wyvern -> DragonPeak
(13, 5), -- Fire Elemental -> DragonPeak
(14, 5), -- Ice Golem -> DragonPeak
(15, 3), -- Necromancer -> Goblin Cave
(15, 2), -- Necromancer -> WhisperingWoods
(16, 5), -- Stone Guardian -> DragonPeak
(17, 2), -- Shadow Stalker -> WhisperingWoods
(17, 3); -- Shadow Stalker -> Goblin Cave

-- Quest_Guild
INSERT INTO Quest_Guild (Quest_QuestID, Guild_Name) VALUES
(2, 'TheRangers');
