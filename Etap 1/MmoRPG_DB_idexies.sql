SET search_path TO game_data;

-- Indexes for optimizing queries on Player table
CREATE INDEX idx_player_accountstatus ON Player (AccountStatus_StatusID);

-- Indexes for optimizing queries on Character table
CREATE INDEX idx_character_player_username ON Character (Player_Userame);
CREATE INDEX idx_character_isnpc ON Character (IsNPC);

-- Indexes for optimizing queries on Guild table
CREATE INDEX idx_guild_leader_name ON Guild (Leader_Name);
CREATE INDEX idx_guild_min_level ON Guild (MinLevel);

-- Indexes for optimizing queries on Iteam table
CREATE INDEX idx_item_type_category ON Iteam (ItemType_CategoryID);
CREATE INDEX idx_item_rarity ON Iteam (Rarity_RarityID);
CREATE INDEX idx_item_name ON Iteam (Name);
CREATE INDEX idx_item_price ON Iteam (Price);
CREATE INDEX idx_item_retail_price ON Iteam (RetailPrice);

-- Indexes for optimizing queries on Quest table
CREATE INDEX idx_quest_location ON Quest (Location_LocationID);
CREATE INDEX idx_quest_item ON Quest (Iteam_IteamID);

-- Indexes for optimizing queries on CombatLog table
CREATE INDEX idx_combatlog_character_name ON CombatLog (Character_Name);
CREATE INDEX idx_combatlog_monster_id ON CombatLog (Monster_MonsterID);
CREATE INDEX idx_combatlog_location_id ON CombatLog (Location_LocationID);

-- Indexes for optimizing queries on QuestLog table
CREATE INDEX idx_questlog_character_name ON QuestLog (Character_Name);
CREATE INDEX idx_questlog_quest_id ON QuestLog (Quest_QuestID);
CREATE INDEX idx_questlog_status_id ON QuestLog (QuestStatus_StatusID);

-- Indexes for optimizing queries on Iteam_Character table
CREATE INDEX idx_item_character_character_name ON Iteam_Character (Character_Name);
CREATE INDEX idx_item_character_item_id ON Iteam_Character (Iteam_IteamID);