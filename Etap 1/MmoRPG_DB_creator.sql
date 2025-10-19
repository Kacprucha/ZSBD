-- Utworzenie schematu
CREATE SCHEMA IF NOT EXISTS game_data;
SET search_path TO game_data;

-- Tabele słownikowe
-- Tabele: AccountStatus
CREATE TABLE AccountStatus (
    StatusID serial PRIMARY KEY,
    StatusName varchar(10) UNIQUE NOT NULL
);

-- Tabele: MemberStatus
CREATE TABLE MemberStatus (
    MemberStatusID serial PRIMARY KEY,
    MemberStatus varchar(10) UNIQUE NOT NULL
);

-- Tabele: ItemType
CREATE TABLE ItemType (
    TypeID serial PRIMARY KEY,
    Category varchar(15) UNIQUE NOT NULL
);

-- Tabele: Rarity
CREATE TABLE Rarity (
    RarityID serial PRIMARY KEY,
    RarityName varchar(10) UNIQUE NOT NULL
);

-- Tabele: LocationType
CREATE TABLE LocationType (
    TypeID serial PRIMARY KEY,
    TypeName varchar(10) UNIQUE NOT NULL 
);

-- Table: QuestStatus
CREATE TABLE QuestStatus (
    StatusID serial PRIMARY KEY,
    StatusName varchar(15) UNIQUE NOT NULL
);

-- Tabele niezależne
-- Table: Race
CREATE TABLE Race (
    Name varchar(10)  PRIMARY KEY,
    Description varchar(70)  NOT NULL,
    FightBonus int  NOT NULL,
    MagicBonus int  NOT NULL
);

-- Table: Class
CREATE TABLE Class (
    Name varchar(10)  PRIMARY KEY,
    Description varchar(70)  NOT NULL,
    BaseMana int  NOT NULL,
    BaseHealth int  NOT NULL
);

-- Table: Skill
CREATE TABLE Skill (
    SkillID serial PRIMARY KEY,
    Name varchar(20)  NOT NULL,
    Description varchar(70)  NOT NULL,
    Damage int  DEFAULT 0,
    CoolDown int DEFAULT 0,
    ManaCost int  DEFAULT 0
);

-- Table: Monster
CREATE TABLE Monster (
    MonsterID serial PRIMARY KEY,
    Name varchar(20)  NOT NULL,
    Level int  DEFAULT 1 CHECK (Level >= 1 AND level <= 100),
    HitPoints int NOT NULL DEFAULT 5,
    Atack int NOT NULL DEFAULT 1,
    Defence int NOT NULL DEFAULT 1,
    ExpDrop int  DEFAULT 0,
    GoldDrop int  DEFAULT 0
);

-- Tabele zależne i asocjacyjne
-- Table: Player
CREATE TABLE Player (
    Username varchar(10) PRIMARY KEY,
    Email varchar(20) UNIQUE,
    Password_hash bytea  NOT NULL,
    AccountStatus_StatusID int NOT NULL REFERENCES AccountStatus(StatusID)
);

-- Table: Character
CREATE TABLE Character (
    Name varchar(10)  PRIMARY KEY,
    IsNPC boolean NOT NULL,
    Level int  DEFAULT 1 CHECK (Level >= 1 AND level <= 100),
    MaxHitPoints int  NOT NULL,
    MaxMana int  NOT NULL,
    Gold int  NOT NULL DEFAULT 0,
    Experience int NOT NULL DEFAULT 0,
    Player_Userame varchar(10) REFERENCES Player(Username)
);

-- Table: Location
CREATE TABLE Location (
    LocationID serial PRIMARY KEY,
    Name varchar(15)  UNIQUE,
    LocatioType_TypeID int NOT NULL REFERENCES LocationType(TypeID),
    IsSafeZone boolean  DEFAULT false,
    RecomenedLevel int  NOT NULL,
    MonsterDensity int  NOT NULL DEFAULT 0 CHECK (MonsterDensity >= 0 AND MonsterDensity <= 100)
);

-- Table: Guild
CREATE TABLE Guild (
    Name varchar(20)  PRIMARY KEY,
    Leader_Name varchar(10) NOT NULL REFERENCES Character(Name),
    GuildGold int NOT NULL DEFAULT 0,
    MinLevel int NOT NULL DEFAULT 1 CHECK (MinLevel >= 1 AND MinLevel <= 100),
    Reputation int NOT NULL DEFAULT 0
);

-- Table: Iteam
CREATE TABLE Iteam (
    IteamID serial PRIMARY KEY,
    Name varchar(25)  NOT NULL,
    Description varchar(70)  NOT NULL,
    ItemType_CategoryID int NOT NULL REFERENCES ItemType(TypeID),
    Rarity_RarityID int NOT NULL REFERENCES Rarity(RarityID),
    Price int  NOT NULL,
    RetailPrice int  NOT NULL,
    AtackBonus int DEFAULT 0,
    DefenceBonus int DEFAULT 0,
    MagicBonus int DEFAULT 0
);

-- Table: Quest
CREATE TABLE Quest (
    QuestID serial PRIMARY KEY,
    Name varchar(25)  NOT NULL,
    Description varchar(70)  NOT NULL,
    Giver varchar(15)  NOT NULL,
    GoldReward int  DEFAULT 0,
    Iteam_IteamID int REFERENCES Iteam(IteamID),
    Location_LocationID int NOT NULL REFERENCES Location(LocationID)
);

-- Table: CombatLog
CREATE TABLE CombatLog (
    CombatLogID serial PRIMARY KEY,
    Character_Name varchar(10) NOT NULL REFERENCES Character(Name),
    Monster_MonsterID int  REFERENCES Monster(MonsterID),
    Location_LocationID int  REFERENCES Location(LocationID),
    Victory boolean  NOT NULL,
    DmgTaken int,
    DmgDelt int
);

-- Tabele: QuestLog
CREATE TABLE QuestLog (
    QuestLogID serial PRIMARY KEY,
    Character_Name varchar(10) NOT NULL REFERENCES Character(Name),
    Quest_QuestID int NOT NULL REFERENCES Quest(QuestID),
    QuestStatus_StatusID int NOT NULL REFERENCES QuestStatus(StatusID),
    AtemptNumber int NOT NULL,
    StartTime timestamp NOT NULL,
    EndTime timestamp NULL
);

-- Tabele: GuildMember
CREATE TABLE GuildMember (
    Character_Name varchar(10) NOT NULL REFERENCES Character(Name),
    Guild_Name varchar(20) NOT NULL REFERENCES Guild(Name),
    MemberStatus_StatusID int NOT NULL REFERENCES MemberStatus(MemberStatusID),
    IsBand boolean NOT NULL,
    JoinedAt timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Contribution int NOT NULL DEFAULT 0,
    CONSTRAINT GuildMember_pk PRIMARY KEY (Character_Name, Guild_Name)
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
    InventoryID serial PRIMARY KEY,
    Iteam_IteamID int  REFERENCES Iteam(IteamID),
    Character_Name varchar(10)  REFERENCES Character(Name)
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

