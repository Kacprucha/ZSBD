-- Utworzenie schematu
CREATE SCHEMA IF NOT EXISTS game_data;
SET search_path TO game_data;

-- tables
-- Table: Player
CREATE TABLE Player (
    Username varchar(10) PRIMARY KEY,
    Email varchar(20) UNIQUE,
    Password_hash bytea  NOT NULL,
    AccountStatus varchar(15)  DEFAULT 'active' CHECK (AccountStatus IN ('active', 'banned', 'suspended'))
);

-- Table: Race
CREATE TABLE Race (
    Name varchar(10)  PRIMARY KEY,
    Description varchar(30)  NOT NULL,
    FightBonus int  NOT NULL,
    MagicBonus int  NOT NULL
);

-- Table: Class
CREATE TABLE Class (
    Name varchar(10)  PRIMARY KEY,
    Description varchar(30)  NOT NULL,
    BaseMana int  NOT NULL,
    BaseHealth int  NOT NULL
);

-- Table: Skill
CREATE TABLE Skill (
    SkillID SERIAL PRIMARY KEY,
    Name varchar(10)  NOT NULL,
    Description varchar(30)  NOT NULL,
    Damage int  DEFAULT 0,
    CoolDown int DEFAULT 0,
    ManaCost int  DEFAULT 0
);

-- Table: Guild
CREATE TABLE Guild (
    Name varchar(20)  PRIMARY KEY,
    GuildGold int  DEFAULT 0,
    MinLevel int  DEFAULT 1 CHECK (MinLevel >= 1 AND MinLevel <= 100)
);

-- Table: Location
CREATE TABLE Location (
    LocationID SERIAL PRIMARY KEY,
    Name varchar(10)  UNIQUE,
    Type varchar(10)  CHECK (Type IN ('city', 'forest', 'dungeon', 'mountain', 'desert')),
    IsSafeZone boolean  DEFAULT false,
    RecomenedLevel int  NOT NULL
);

-- Table: IteamType
CREATE TABLE IteamType (
    IteamTypeID SERIAL PRIMARY KEY,
    Name varchar(10)  NOT NULL,
    Category varchar(15)  CHECK (Category IN ('weapon', 'armor', 'consumable', 'quest_item', 'crafting'))
);

-- Table: Monster
CREATE TABLE Monster (
    MonsterID SERIAL PRIMARY KEY,
    Name varchar(10)  NOT NULL,
    Level int  DEFAULT 1 CHECK (Level >= 1 AND level <= 100),
    HitPoints int DEFAULT 5,
    Atack int  DEFAULT 1,
    Defence int  DEFAULT 1,
    ExpDrop int  DEFAULT 0,
    GoldDrop int  DEFAULT 0
);

-- Table: Quest
CREATE TABLE Quest (
    QuestID SERIAL PRIMARY KEY,
    Name varchar(15)  NOT NULL,
    Description varchar(30)  NOT NULL,
    Giver varchar(15)  NOT NULL,
    Reward varchar(10),
    Location_LocationID int REFERENCES Location(LocationID)
);

-- Table: Iteam
CREATE TABLE Iteam (
    IteamID SERIAL PRIMARY KEY,
    Name varchar(10)  NOT NULL,
    Description varchar(30)  NOT NULL,
    Rarity varchar(10)  CHECK (Rarity IN ('common', 'uncommon', 'rare', 'epic', 'legendary')),
    Price int  NOT NULL,
    RetailPrice int  NOT NULL,
    AtackBonus int DEFAULT 0,
    DefenceBonus int DEFAULT 0,
    MagicBonus int DEFAULT 0
);

-- Table: Character
CREATE TABLE Character (
    Name varchar(10)  PRIMARY KEY,
    Level int  DEFAULT 1 CHECK (Level >= 1 AND level <= 100),
    MaxHitPoints int  NOT NULL,
    MaxMana int  NOT NULL,
    Gold int  NOT NULL,
    Experience int  DEFAULT 0,
    Player_Userame varchar(10)  REFERENCES Player(Username),
    Guild_Name varchar(20)  REFERENCES Guild(Name)
);

-- Table: CombatLog
CREATE TABLE CombatLog (
    CombatLogID SERIAL PRIMARY KEY,
    Character_Name varchar(10)  REFERENCES Character(Name),
    Monster_MonsterID int  REFERENCES Monster(MonsterID),
    Victory boolean  NOT NULL,
    DmgTaken int,
    DmgDelt int
);

-- Tabele asocjacyjne:
-- Table: Race_Character
CREATE TABLE Race_Character (
    Race_Name varchar(10)  REFERENCES Race(Name),
    Character_Name varchar(10)  REFERENCES Character(Name),
    CONSTRAINT Race_Character_pk PRIMARY KEY (Race_Name,Character_Name)
);


-- Table: Character_Class
CREATE TABLE Character_Class (
    Character_Name varchar(10)  REFERENCES Character(Name),
    Class_Name varchar(10)  REFERENCES Class(Name),
    CONSTRAINT Character_Class_pk PRIMARY KEY (Character_Name,Class_Name)
);

-- Table: Class_Skill
CREATE TABLE Class_Skill (
    Class_Name varchar(10)  REFERENCES Class(Name),
    Skill_SkillID int  REFERENCES Skill(SkillID),
    CONSTRAINT Class_Skill_pk PRIMARY KEY (Class_Name,Skill_SkillID)
);

-- Table: Skill_Character
CREATE TABLE Skill_Character (
    Skill_SkillID int  REFERENCES Skill(SkillID),
    Character_Name varchar(10)  REFERENCES Character(Name),
    CONSTRAINT Skill_Character_pk PRIMARY KEY (Skill_SkillID,Character_Name)
);

-- Table: Iteam_Character
CREATE TABLE Iteam_Character (
    Iteam_IteamID int  REFERENCES Iteam(IteamID),
    Character_Name varchar(10)  REFERENCES Character(Name),
    CONSTRAINT Iteam_Character_pk PRIMARY KEY (Iteam_IteamID,Character_Name)
);

-- Table: Character_Quest
CREATE TABLE Character_Quest (
    Character_Name varchar(10)  REFERENCES Character(Name),
    Quest_QuestID int  REFERENCES Quest(QuestID),
    CONSTRAINT Character_Quest_pk PRIMARY KEY (Character_Name,Quest_QuestID)
);

-- Table: Quest_Guild
CREATE TABLE Quest_Guild (
    Quest_QuestID int  REFERENCES Quest(QuestID),
    Guild_Name varchar(20)  REFERENCES Guild(Name),
    CONSTRAINT Quest_Guild_pk PRIMARY KEY (Quest_QuestID,Guild_Name)
);

-- Table: Monster_Location
CREATE TABLE Monster_Location (
    Monster_MonsterID int  REFERENCES Monster(MonsterID),
    Location_LocationID int  REFERENCES Location(LocationID),
    CONSTRAINT Monster_Location_pk PRIMARY KEY (Monster_MonsterID,Location_LocationID)
);

-- Table: IteamType_Iteam
CREATE TABLE IteamType_Iteam (
    IteamType_IteamTypeID int  REFERENCES IteamType(IteamTypeID),
    Iteam_IteamID int  REFERENCES Iteam(IteamID),
    CONSTRAINT IteamType_Iteam_pk PRIMARY KEY (IteamType_IteamTypeID,Iteam_IteamID)
);

-- sequences
-- Sequence: IteamType_seq
CREATE SEQUENCE IteamType_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: Iteam_seq
CREATE SEQUENCE Iteam_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: Location_seq
CREATE SEQUENCE Location_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: Monster_seq
CREATE SEQUENCE Monster_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: Quest_seq
CREATE SEQUENCE Quest_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: Skill_seq
CREATE SEQUENCE Skill_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- End of file.

