--
-- PostgreSQL database dump
--


-- Dumped from database version 16.10 (Debian 16.10-1.pgdg13+1)
-- Dumped by pg_dump version 16.10 (Debian 16.10-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: game_data; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA game_data;


--
-- Name: fn_autolevelup(); Type: FUNCTION; Schema: game_data; Owner: -
--




--
-- Name: fn_calculatecharacterpower(character varying); Type: FUNCTION; Schema: game_data; Owner: -
--



--
-- Name: fn_cancharacterjoinguild(character varying, character varying); Type: FUNCTION; Schema: game_data; Owner: -
--




--
-- Name: fn_checkguildlevel(); Type: FUNCTION; Schema: game_data; Owner: -
--




--
-- Name: fn_checkinventorylimit(); Type: FUNCTION; Schema: game_data; Owner: -
--




--
-- Name: fn_getcharacterwinrate(character varying); Type: FUNCTION; Schema: game_data; Owner: -
--




--
-- Name: fn_getguildmembershipduration(character varying); Type: FUNCTION; Schema: game_data; Owner: -
--




--
-- Name: fn_grantcombatrewards(); Type: FUNCTION; Schema: game_data; Owner: -
--




--
-- Name: sp_addcharactertoguild(character varying, character varying); Type: PROCEDURE; Schema: game_data; Owner: -
--




--
-- Name: sp_addclasstocharacter(character varying, character varying); Type: PROCEDURE; Schema: game_data; Owner: -
--




--
-- Name: sp_addnewitem(character varying, character varying, integer, integer, integer, integer, integer, integer, integer); Type: PROCEDURE; Schema: game_data; Owner: -
--




--
-- Name: sp_addracetocharacter(character varying, character varying); Type: PROCEDURE; Schema: game_data; Owner: -
--




--
-- Name: sp_admingiveitem(character varying, integer, integer); Type: PROCEDURE; Schema: game_data; Owner: -
--




--
-- Name: sp_assignmonstertolocation(integer, integer); Type: PROCEDURE; Schema: game_data; Owner: -
--




--
-- Name: sp_completequest(character varying, integer); Type: PROCEDURE; Schema: game_data; Owner: -
--




--
-- Name: sp_createcharacter(character varying, character varying, character varying[], character varying); Type: PROCEDURE; Schema: game_data; Owner: -
--



--
-- Name: sp_createclass(character varying, character varying, integer, integer); Type: PROCEDURE; Schema: game_data; Owner: -
--




--
-- Name: sp_createguild(character varying, character varying, integer); Type: PROCEDURE; Schema: game_data; Owner: -
--




--
-- Name: sp_createmonster(character varying, integer, integer, integer, integer, integer, integer); Type: PROCEDURE; Schema: game_data; Owner: -
--




--
-- Name: sp_createnpc(character varying, character varying, character varying, integer, integer, integer, integer, integer, integer[]); Type: PROCEDURE; Schema: game_data; Owner: -
--




--
-- Name: sp_createquest(character varying, character varying, character varying, integer, character varying, character varying); Type: PROCEDURE; Schema: game_data; Owner: -
--




--
-- Name: sp_createrace(character varying, character varying, integer, integer); Type: PROCEDURE; Schema: game_data; Owner: -
--




--
-- Name: sp_createskill(character varying, character varying, integer, integer, integer); Type: PROCEDURE; Schema: game_data; Owner: -
--




--
-- Name: sp_learnskill(character varying, integer); Type: PROCEDURE; Schema: game_data; Owner: -
--



--
-- Name: sp_registerplayer(character varying, character varying, character varying); Type: PROCEDURE; Schema: game_data; Owner: -
--




--
-- Name: sp_runweeklymaintenance(); Type: PROCEDURE; Schema: game_data; Owner: -
--




SET default_table_access_method = heap;

--
-- Name: accountstatus; Type: TABLE; Schema: game_data; Owner: -
--

CREATE TABLE game_data.accountstatus (
    statusid integer NOT NULL,
    statusname character varying(10) NOT NULL
);


--
-- Name: accountstatus_statusid_seq; Type: SEQUENCE; Schema: game_data; Owner: -
--

CREATE SEQUENCE game_data.accountstatus_statusid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accountstatus_statusid_seq; Type: SEQUENCE OWNED BY; Schema: game_data; Owner: -
--

ALTER SEQUENCE game_data.accountstatus_statusid_seq OWNED BY game_data.accountstatus.statusid;


--
-- Name: character; Type: TABLE; Schema: game_data; Owner: -
--

CREATE TABLE game_data."character" (
    name character varying(10) NOT NULL,
    isnpc boolean NOT NULL,
    level integer DEFAULT 1,
    maxhitpoints integer NOT NULL,
    maxmana integer NOT NULL,
    gold integer DEFAULT 0 NOT NULL,
    experience integer DEFAULT 0 NOT NULL,
    player_userame character varying(10),
    CONSTRAINT character_level_check CHECK (((level >= 1) AND (level <= 100)))
);


--
-- Name: guild; Type: TABLE; Schema: game_data; Owner: -
--

CREATE TABLE game_data.guild (
    name character varying(20) NOT NULL,
    leader_name character varying(10) NOT NULL,
    guildgold integer DEFAULT 0 NOT NULL,
    minlevel integer DEFAULT 1 NOT NULL,
    reputation integer DEFAULT 0 NOT NULL,
    CONSTRAINT guild_minlevel_check CHECK (((minlevel >= 1) AND (minlevel <= 100)))
);


--
-- Name: iteam; Type: TABLE; Schema: game_data; Owner: -
--

CREATE TABLE game_data.iteam (
    iteamid integer NOT NULL,
    name character varying(25) NOT NULL,
    description character varying(70) NOT NULL,
    itemtype_categoryid integer NOT NULL,
    rarity_rarityid integer NOT NULL,
    price integer NOT NULL,
    retailprice integer NOT NULL,
    atackbonus integer DEFAULT 0,
    defencebonus integer DEFAULT 0,
    magicbonus integer DEFAULT 0
);


--
-- Name: iteam_character; Type: TABLE; Schema: game_data; Owner: -
--

CREATE TABLE game_data.iteam_character (
    inventoryid integer NOT NULL,
    iteam_iteamid integer,
    character_name character varying(10)
);


--
-- Name: player; Type: TABLE; Schema: game_data; Owner: -
--

CREATE TABLE game_data.player (
    username character varying(10) NOT NULL,
    email character varying(20),
    password_hash bytea NOT NULL,
    accountstatus_statusid integer NOT NULL
);


--
-- Name: rarity; Type: TABLE; Schema: game_data; Owner: -
--

CREATE TABLE game_data.rarity (
    rarityid integer NOT NULL,
    rarityname character varying(10) NOT NULL
);


--
-- Name: admin_balance_overview; Type: VIEW; Schema: game_data; Owner: -
--




--
-- Name: combatlog; Type: TABLE; Schema: game_data; Owner: -
--

CREATE TABLE game_data.combatlog (
    combatlogid integer NOT NULL,
    character_name character varying(10) NOT NULL,
    monster_monsterid integer,
    location_locationid integer,
    victory boolean NOT NULL,
    dmgtaken integer,
    dmgdelt integer
);


--
-- Name: location; Type: TABLE; Schema: game_data; Owner: -
--

CREATE TABLE game_data.location (
    locationid integer NOT NULL,
    name character varying(15),
    locatiotype_typeid integer NOT NULL,
    issafezone boolean DEFAULT false,
    recomenedlevel integer NOT NULL,
    monsterdensity integer DEFAULT 0 NOT NULL,
    CONSTRAINT location_monsterdensity_check CHECK (((monsterdensity >= 0) AND (monsterdensity <= 100)))
);


--
-- Name: monster; Type: TABLE; Schema: game_data; Owner: -
--

CREATE TABLE game_data.monster (
    monsterid integer NOT NULL,
    name character varying(20) NOT NULL,
    level integer DEFAULT 1,
    hitpoints integer DEFAULT 5 NOT NULL,
    atack integer DEFAULT 1 NOT NULL,
    defence integer DEFAULT 1 NOT NULL,
    expdrop integer DEFAULT 0,
    golddrop integer DEFAULT 0,
    CONSTRAINT monster_level_check CHECK (((level >= 1) AND (level <= 100)))
);


--
-- Name: admin_combat_logs; Type: VIEW; Schema: game_data; Owner: -
--




--
-- Name: questlog; Type: TABLE; Schema: game_data; Owner: -
--

CREATE TABLE game_data.questlog (
    questlogid integer NOT NULL,
    character_name character varying(10) NOT NULL,
    quest_questid integer NOT NULL,
    queststatus_statusid integer NOT NULL,
    atemptnumber integer NOT NULL,
    starttime timestamp without time zone NOT NULL,
    endtime timestamp without time zone
);


--
-- Name: queststatus; Type: TABLE; Schema: game_data; Owner: -
--

CREATE TABLE game_data.queststatus (
    statusid integer NOT NULL,
    statusname character varying(15) NOT NULL
);


--
-- Name: admin_player_activity; Type: VIEW; Schema: game_data; Owner: -
--




--
-- Name: quest; Type: TABLE; Schema: game_data; Owner: -
--

CREATE TABLE game_data.quest (
    questid integer NOT NULL,
    name character varying(25) NOT NULL,
    description character varying(70) NOT NULL,
    giver character varying(15) NOT NULL,
    goldreward integer DEFAULT 0,
    iteam_iteamid integer,
    location_locationid integer NOT NULL
);


--
-- Name: admin_quest_statistics; Type: VIEW; Schema: game_data; Owner: -
--




--
-- Name: character_class; Type: TABLE; Schema: game_data; Owner: -
--

CREATE TABLE game_data.character_class (
    character_name character varying(10) NOT NULL,
    class_name character varying(10) NOT NULL
);


--
-- Name: class; Type: TABLE; Schema: game_data; Owner: -
--

CREATE TABLE game_data.class (
    name character varying(10) NOT NULL,
    description character varying(70) NOT NULL,
    basemana integer NOT NULL,
    basehealth integer NOT NULL
);


--
-- Name: class_skill; Type: TABLE; Schema: game_data; Owner: -
--

CREATE TABLE game_data.class_skill (
    class_name character varying(10) NOT NULL,
    skill_skillid integer NOT NULL
);


--
-- Name: combatlog_combatlogid_seq; Type: SEQUENCE; Schema: game_data; Owner: -
--

CREATE SEQUENCE game_data.combatlog_combatlogid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: combatlog_combatlogid_seq; Type: SEQUENCE OWNED BY; Schema: game_data; Owner: -
--

ALTER SEQUENCE game_data.combatlog_combatlogid_seq OWNED BY game_data.combatlog.combatlogid;


--
-- Name: combatlog_archive; Type: TABLE; Schema: game_data; Owner: -
--

CREATE TABLE game_data.combatlog_archive (
    combatlogid integer DEFAULT nextval('game_data.combatlog_combatlogid_seq'::regclass) NOT NULL,
    character_name character varying(10) NOT NULL,
    monster_monsterid integer,
    location_locationid integer,
    victory boolean NOT NULL,
    dmgtaken integer,
    dmgdelt integer
);


--
-- Name: developer_balance_test_results; Type: VIEW; Schema: game_data; Owner: -
--




--
-- Name: developer_economic_flow; Type: VIEW; Schema: game_data; Owner: -
--




--
-- Name: developer_item_distribution; Type: VIEW; Schema: game_data; Owner: -
--



--
-- Name: guildmember; Type: TABLE; Schema: game_data; Owner: -
--

CREATE TABLE game_data.guildmember (
    character_name character varying(10) NOT NULL,
    guild_name character varying(20) NOT NULL,
    memberstatus_statusid integer NOT NULL,
    isband boolean NOT NULL,
    joinedat timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    contribution integer DEFAULT 0 NOT NULL
);


--
-- Name: iteam_character_inventoryid_seq; Type: SEQUENCE; Schema: game_data; Owner: -
--

CREATE SEQUENCE game_data.iteam_character_inventoryid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: iteam_character_inventoryid_seq; Type: SEQUENCE OWNED BY; Schema: game_data; Owner: -
--

ALTER SEQUENCE game_data.iteam_character_inventoryid_seq OWNED BY game_data.iteam_character.inventoryid;


--
-- Name: iteam_iteamid_seq; Type: SEQUENCE; Schema: game_data; Owner: -
--

CREATE SEQUENCE game_data.iteam_iteamid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: iteam_iteamid_seq; Type: SEQUENCE OWNED BY; Schema: game_data; Owner: -
--

ALTER SEQUENCE game_data.iteam_iteamid_seq OWNED BY game_data.iteam.iteamid;


--
-- Name: iteam_seq; Type: SEQUENCE; Schema: game_data; Owner: -
--

CREATE SEQUENCE game_data.iteam_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: iteamtype_seq; Type: SEQUENCE; Schema: game_data; Owner: -
--

CREATE SEQUENCE game_data.iteamtype_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: itemtype; Type: TABLE; Schema: game_data; Owner: -
--

CREATE TABLE game_data.itemtype (
    typeid integer NOT NULL,
    category character varying(15) NOT NULL
);


--
-- Name: itemtype_typeid_seq; Type: SEQUENCE; Schema: game_data; Owner: -
--

CREATE SEQUENCE game_data.itemtype_typeid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: itemtype_typeid_seq; Type: SEQUENCE OWNED BY; Schema: game_data; Owner: -
--

ALTER SEQUENCE game_data.itemtype_typeid_seq OWNED BY game_data.itemtype.typeid;


--
-- Name: location_locationid_seq; Type: SEQUENCE; Schema: game_data; Owner: -
--

CREATE SEQUENCE game_data.location_locationid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: location_locationid_seq; Type: SEQUENCE OWNED BY; Schema: game_data; Owner: -
--

ALTER SEQUENCE game_data.location_locationid_seq OWNED BY game_data.location.locationid;


--
-- Name: location_seq; Type: SEQUENCE; Schema: game_data; Owner: -
--

CREATE SEQUENCE game_data.location_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locationtype; Type: TABLE; Schema: game_data; Owner: -
--

CREATE TABLE game_data.locationtype (
    typeid integer NOT NULL,
    typename character varying(10) NOT NULL
);


--
-- Name: locationtype_typeid_seq; Type: SEQUENCE; Schema: game_data; Owner: -
--

CREATE SEQUENCE game_data.locationtype_typeid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locationtype_typeid_seq; Type: SEQUENCE OWNED BY; Schema: game_data; Owner: -
--

ALTER SEQUENCE game_data.locationtype_typeid_seq OWNED BY game_data.locationtype.typeid;


--
-- Name: loglevel; Type: TABLE; Schema: game_data; Owner: -
--

CREATE TABLE game_data.loglevel (
    loglevelid integer NOT NULL,
    loglevelname character varying(10) NOT NULL
);


--
-- Name: loglevel_loglevelid_seq; Type: SEQUENCE; Schema: game_data; Owner: -
--

CREATE SEQUENCE game_data.loglevel_loglevelid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: loglevel_loglevelid_seq; Type: SEQUENCE OWNED BY; Schema: game_data; Owner: -
--

ALTER SEQUENCE game_data.loglevel_loglevelid_seq OWNED BY game_data.loglevel.loglevelid;


--
-- Name: memberstatus; Type: TABLE; Schema: game_data; Owner: -
--

CREATE TABLE game_data.memberstatus (
    memberstatusid integer NOT NULL,
    memberstatus character varying(10) NOT NULL
);


--
-- Name: memberstatus_memberstatusid_seq; Type: SEQUENCE; Schema: game_data; Owner: -
--

CREATE SEQUENCE game_data.memberstatus_memberstatusid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: memberstatus_memberstatusid_seq; Type: SEQUENCE OWNED BY; Schema: game_data; Owner: -
--

ALTER SEQUENCE game_data.memberstatus_memberstatusid_seq OWNED BY game_data.memberstatus.memberstatusid;


--
-- Name: monster_location; Type: TABLE; Schema: game_data; Owner: -
--

CREATE TABLE game_data.monster_location (
    monster_monsterid integer NOT NULL,
    location_locationid integer NOT NULL
);


--
-- Name: monster_monsterid_seq; Type: SEQUENCE; Schema: game_data; Owner: -
--

CREATE SEQUENCE game_data.monster_monsterid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: monster_monsterid_seq; Type: SEQUENCE OWNED BY; Schema: game_data; Owner: -
--

ALTER SEQUENCE game_data.monster_monsterid_seq OWNED BY game_data.monster.monsterid;


--
-- Name: monster_seq; Type: SEQUENCE; Schema: game_data; Owner: -
--

CREATE SEQUENCE game_data.monster_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: race; Type: TABLE; Schema: game_data; Owner: -
--

CREATE TABLE game_data.race (
    name character varying(10) NOT NULL,
    description character varying(70) NOT NULL,
    fightbonus integer NOT NULL,
    magicbonus integer NOT NULL
);


--
-- Name: race_character; Type: TABLE; Schema: game_data; Owner: -
--

CREATE TABLE game_data.race_character (
    race_name character varying(10) NOT NULL,
    character_name character varying(10) NOT NULL
);


--
-- Name: player_character_summary; Type: VIEW; Schema: game_data; Owner: -
--




--
-- Name: player_inventory_view; Type: VIEW; Schema: game_data; Owner: -
--




--
-- Name: player_location_explored; Type: VIEW; Schema: game_data; Owner: -
--




--
-- Name: player_quest_log; Type: VIEW; Schema: game_data; Owner: -
--




--
-- Name: skill; Type: TABLE; Schema: game_data; Owner: -
--

CREATE TABLE game_data.skill (
    skillid integer NOT NULL,
    name character varying(20) NOT NULL,
    description character varying(70) NOT NULL,
    damage integer DEFAULT 0,
    cooldown integer DEFAULT 0,
    manacost integer DEFAULT 0
);


--
-- Name: skill_character; Type: TABLE; Schema: game_data; Owner: -
--

CREATE TABLE game_data.skill_character (
    skill_skillid integer NOT NULL,
    character_name character varying(10) NOT NULL
);


--
-- Name: player_skill_tree; Type: VIEW; Schema: game_data; Owner: -
--




--
-- Name: procedureexecutionlog; Type: TABLE; Schema: game_data; Owner: -
--

CREATE TABLE game_data.procedureexecutionlog (
    logid integer NOT NULL,
    executionid uuid DEFAULT gen_random_uuid(),
    procedurename character varying(100),
    logtimestamp timestamp with time zone DEFAULT now(),
    loglevel_loglevelid integer NOT NULL,
    message text
);


--
-- Name: procedureexecutionlog_logid_seq; Type: SEQUENCE; Schema: game_data; Owner: -
--

CREATE SEQUENCE game_data.procedureexecutionlog_logid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: procedureexecutionlog_logid_seq; Type: SEQUENCE OWNED BY; Schema: game_data; Owner: -
--

ALTER SEQUENCE game_data.procedureexecutionlog_logid_seq OWNED BY game_data.procedureexecutionlog.logid;


--
-- Name: quest_guild; Type: TABLE; Schema: game_data; Owner: -
--

CREATE TABLE game_data.quest_guild (
    quest_questid integer NOT NULL,
    guild_name character varying(20) NOT NULL
);


--
-- Name: quest_questid_seq; Type: SEQUENCE; Schema: game_data; Owner: -
--

CREATE SEQUENCE game_data.quest_questid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quest_questid_seq; Type: SEQUENCE OWNED BY; Schema: game_data; Owner: -
--

ALTER SEQUENCE game_data.quest_questid_seq OWNED BY game_data.quest.questid;


--
-- Name: quest_seq; Type: SEQUENCE; Schema: game_data; Owner: -
--

CREATE SEQUENCE game_data.quest_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: questlog_questlogid_seq; Type: SEQUENCE; Schema: game_data; Owner: -
--

CREATE SEQUENCE game_data.questlog_questlogid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: questlog_questlogid_seq; Type: SEQUENCE OWNED BY; Schema: game_data; Owner: -
--

ALTER SEQUENCE game_data.questlog_questlogid_seq OWNED BY game_data.questlog.questlogid;


--
-- Name: queststatus_statusid_seq; Type: SEQUENCE; Schema: game_data; Owner: -
--

CREATE SEQUENCE game_data.queststatus_statusid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: queststatus_statusid_seq; Type: SEQUENCE OWNED BY; Schema: game_data; Owner: -
--

ALTER SEQUENCE game_data.queststatus_statusid_seq OWNED BY game_data.queststatus.statusid;


--
-- Name: rarity_rarityid_seq; Type: SEQUENCE; Schema: game_data; Owner: -
--

CREATE SEQUENCE game_data.rarity_rarityid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rarity_rarityid_seq; Type: SEQUENCE OWNED BY; Schema: game_data; Owner: -
--

ALTER SEQUENCE game_data.rarity_rarityid_seq OWNED BY game_data.rarity.rarityid;


--
-- Name: skill_seq; Type: SEQUENCE; Schema: game_data; Owner: -
--

CREATE SEQUENCE game_data.skill_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skill_skillid_seq; Type: SEQUENCE; Schema: game_data; Owner: -
--

CREATE SEQUENCE game_data.skill_skillid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skill_skillid_seq; Type: SEQUENCE OWNED BY; Schema: game_data; Owner: -
--

ALTER SEQUENCE game_data.skill_skillid_seq OWNED BY game_data.skill.skillid;


--
-- Name: system_anomaly_detection; Type: VIEW; Schema: game_data; Owner: -
--



--
-- Name: system_boss_fight_log; Type: VIEW; Schema: game_data; Owner: -
--



--
-- Name: system_ranking_overview; Type: VIEW; Schema: game_data; Owner: -
--




--
-- Name: accountstatus statusid; Type: DEFAULT; Schema: game_data; Owner: -
--



--
-- Name: combatlog combatlogid; Type: DEFAULT; Schema: game_data; Owner: -
--



--
-- Name: iteam iteamid; Type: DEFAULT; Schema: game_data; Owner: -
--



--
-- Name: iteam_character inventoryid; Type: DEFAULT; Schema: game_data; Owner: -
--



--
-- Name: itemtype typeid; Type: DEFAULT; Schema: game_data; Owner: -
--



--
-- Name: location locationid; Type: DEFAULT; Schema: game_data; Owner: -
--



--
-- Name: locationtype typeid; Type: DEFAULT; Schema: game_data; Owner: -
--



--
-- Name: loglevel loglevelid; Type: DEFAULT; Schema: game_data; Owner: -
--



--
-- Name: memberstatus memberstatusid; Type: DEFAULT; Schema: game_data; Owner: -
--



--
-- Name: monster monsterid; Type: DEFAULT; Schema: game_data; Owner: -
--



--
-- Name: procedureexecutionlog logid; Type: DEFAULT; Schema: game_data; Owner: -
--



--
-- Name: quest questid; Type: DEFAULT; Schema: game_data; Owner: -
--



--
-- Name: questlog questlogid; Type: DEFAULT; Schema: game_data; Owner: -
--



--
-- Name: queststatus statusid; Type: DEFAULT; Schema: game_data; Owner: -
--



--
-- Name: rarity rarityid; Type: DEFAULT; Schema: game_data; Owner: -
--



--
-- Name: skill skillid; Type: DEFAULT; Schema: game_data; Owner: -
--



--
-- Name: accountstatus accountstatus_pkey; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.accountstatus
    ADD CONSTRAINT accountstatus_pkey PRIMARY KEY (statusid);


--
-- Name: accountstatus accountstatus_statusname_key; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.accountstatus
    ADD CONSTRAINT accountstatus_statusname_key UNIQUE (statusname);


--
-- Name: character_class character_class_pk; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.character_class
    ADD CONSTRAINT character_class_pk PRIMARY KEY (character_name, class_name);


--
-- Name: character character_pkey; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data."character"
    ADD CONSTRAINT character_pkey PRIMARY KEY (name);


--
-- Name: class class_pkey; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.class
    ADD CONSTRAINT class_pkey PRIMARY KEY (name);


--
-- Name: class_skill class_skill_pk; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.class_skill
    ADD CONSTRAINT class_skill_pk PRIMARY KEY (class_name, skill_skillid);


--
-- Name: combatlog_archive combatlog_archive_pkey; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.combatlog_archive
    ADD CONSTRAINT combatlog_archive_pkey PRIMARY KEY (combatlogid);


--
-- Name: combatlog combatlog_pkey; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.combatlog
    ADD CONSTRAINT combatlog_pkey PRIMARY KEY (combatlogid);


--
-- Name: guild guild_pkey; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.guild
    ADD CONSTRAINT guild_pkey PRIMARY KEY (name);


--
-- Name: guildmember guildmember_pk; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.guildmember
    ADD CONSTRAINT guildmember_pk PRIMARY KEY (character_name, guild_name);


--
-- Name: iteam_character iteam_character_pkey; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.iteam_character
    ADD CONSTRAINT iteam_character_pkey PRIMARY KEY (inventoryid);


--
-- Name: iteam iteam_pkey; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.iteam
    ADD CONSTRAINT iteam_pkey PRIMARY KEY (iteamid);


--
-- Name: itemtype itemtype_category_key; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.itemtype
    ADD CONSTRAINT itemtype_category_key UNIQUE (category);


--
-- Name: itemtype itemtype_pkey; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.itemtype
    ADD CONSTRAINT itemtype_pkey PRIMARY KEY (typeid);


--
-- Name: location location_name_key; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.location
    ADD CONSTRAINT location_name_key UNIQUE (name);


--
-- Name: location location_pkey; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.location
    ADD CONSTRAINT location_pkey PRIMARY KEY (locationid);


--
-- Name: locationtype locationtype_pkey; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.locationtype
    ADD CONSTRAINT locationtype_pkey PRIMARY KEY (typeid);


--
-- Name: locationtype locationtype_typename_key; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.locationtype
    ADD CONSTRAINT locationtype_typename_key UNIQUE (typename);


--
-- Name: loglevel loglevel_loglevelname_key; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.loglevel
    ADD CONSTRAINT loglevel_loglevelname_key UNIQUE (loglevelname);


--
-- Name: loglevel loglevel_pkey; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.loglevel
    ADD CONSTRAINT loglevel_pkey PRIMARY KEY (loglevelid);


--
-- Name: memberstatus memberstatus_memberstatus_key; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.memberstatus
    ADD CONSTRAINT memberstatus_memberstatus_key UNIQUE (memberstatus);


--
-- Name: memberstatus memberstatus_pkey; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.memberstatus
    ADD CONSTRAINT memberstatus_pkey PRIMARY KEY (memberstatusid);


--
-- Name: monster_location monster_location_pk; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.monster_location
    ADD CONSTRAINT monster_location_pk PRIMARY KEY (monster_monsterid, location_locationid);


--
-- Name: monster monster_pkey; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.monster
    ADD CONSTRAINT monster_pkey PRIMARY KEY (monsterid);


--
-- Name: player player_email_key; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.player
    ADD CONSTRAINT player_email_key UNIQUE (email);


--
-- Name: player player_pkey; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.player
    ADD CONSTRAINT player_pkey PRIMARY KEY (username);


--
-- Name: procedureexecutionlog procedureexecutionlog_pkey; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.procedureexecutionlog
    ADD CONSTRAINT procedureexecutionlog_pkey PRIMARY KEY (logid);


--
-- Name: quest_guild quest_guild_pk; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.quest_guild
    ADD CONSTRAINT quest_guild_pk PRIMARY KEY (quest_questid, guild_name);


--
-- Name: quest quest_pkey; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.quest
    ADD CONSTRAINT quest_pkey PRIMARY KEY (questid);


--
-- Name: questlog questlog_pkey; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.questlog
    ADD CONSTRAINT questlog_pkey PRIMARY KEY (questlogid);


--
-- Name: queststatus queststatus_pkey; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.queststatus
    ADD CONSTRAINT queststatus_pkey PRIMARY KEY (statusid);


--
-- Name: queststatus queststatus_statusname_key; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.queststatus
    ADD CONSTRAINT queststatus_statusname_key UNIQUE (statusname);


--
-- Name: race_character race_character_pk; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.race_character
    ADD CONSTRAINT race_character_pk PRIMARY KEY (race_name, character_name);


--
-- Name: race race_pkey; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.race
    ADD CONSTRAINT race_pkey PRIMARY KEY (name);


--
-- Name: rarity rarity_pkey; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.rarity
    ADD CONSTRAINT rarity_pkey PRIMARY KEY (rarityid);


--
-- Name: rarity rarity_rarityname_key; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.rarity
    ADD CONSTRAINT rarity_rarityname_key UNIQUE (rarityname);


--
-- Name: skill_character skill_character_pk; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.skill_character
    ADD CONSTRAINT skill_character_pk PRIMARY KEY (skill_skillid, character_name);


--
-- Name: skill skill_pkey; Type: CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.skill
    ADD CONSTRAINT skill_pkey PRIMARY KEY (skillid);


--
-- Name: combatlog_archive_character_name_idx; Type: INDEX; Schema: game_data; Owner: -
--

CREATE INDEX combatlog_archive_character_name_idx ON game_data.combatlog_archive USING btree (character_name);


--
-- Name: combatlog_archive_location_locationid_idx; Type: INDEX; Schema: game_data; Owner: -
--

CREATE INDEX combatlog_archive_location_locationid_idx ON game_data.combatlog_archive USING btree (location_locationid);


--
-- Name: combatlog_archive_monster_monsterid_idx; Type: INDEX; Schema: game_data; Owner: -
--

CREATE INDEX combatlog_archive_monster_monsterid_idx ON game_data.combatlog_archive USING btree (monster_monsterid);


--
-- Name: idx_character_isnpc; Type: INDEX; Schema: game_data; Owner: -
--

CREATE INDEX idx_character_isnpc ON game_data."character" USING btree (isnpc);


--
-- Name: idx_character_player_username; Type: INDEX; Schema: game_data; Owner: -
--

CREATE INDEX idx_character_player_username ON game_data."character" USING btree (player_userame);


--
-- Name: idx_combatlog_character_name; Type: INDEX; Schema: game_data; Owner: -
--

CREATE INDEX idx_combatlog_character_name ON game_data.combatlog USING btree (character_name);


--
-- Name: idx_combatlog_location_id; Type: INDEX; Schema: game_data; Owner: -
--

CREATE INDEX idx_combatlog_location_id ON game_data.combatlog USING btree (location_locationid);


--
-- Name: idx_combatlog_monster_id; Type: INDEX; Schema: game_data; Owner: -
--

CREATE INDEX idx_combatlog_monster_id ON game_data.combatlog USING btree (monster_monsterid);


--
-- Name: idx_guild_leader_name; Type: INDEX; Schema: game_data; Owner: -
--

CREATE INDEX idx_guild_leader_name ON game_data.guild USING btree (leader_name);


--
-- Name: idx_guild_min_level; Type: INDEX; Schema: game_data; Owner: -
--

CREATE INDEX idx_guild_min_level ON game_data.guild USING btree (minlevel);


--
-- Name: idx_item_character_character_name; Type: INDEX; Schema: game_data; Owner: -
--

CREATE INDEX idx_item_character_character_name ON game_data.iteam_character USING btree (character_name);


--
-- Name: idx_item_character_item_id; Type: INDEX; Schema: game_data; Owner: -
--

CREATE INDEX idx_item_character_item_id ON game_data.iteam_character USING btree (iteam_iteamid);


--
-- Name: idx_item_name; Type: INDEX; Schema: game_data; Owner: -
--

CREATE INDEX idx_item_name ON game_data.iteam USING btree (name);


--
-- Name: idx_item_price; Type: INDEX; Schema: game_data; Owner: -
--

CREATE INDEX idx_item_price ON game_data.iteam USING btree (price);


--
-- Name: idx_item_rarity; Type: INDEX; Schema: game_data; Owner: -
--

CREATE INDEX idx_item_rarity ON game_data.iteam USING btree (rarity_rarityid);


--
-- Name: idx_item_retail_price; Type: INDEX; Schema: game_data; Owner: -
--

CREATE INDEX idx_item_retail_price ON game_data.iteam USING btree (retailprice);


--
-- Name: idx_item_type_category; Type: INDEX; Schema: game_data; Owner: -
--

CREATE INDEX idx_item_type_category ON game_data.iteam USING btree (itemtype_categoryid);


--
-- Name: idx_player_accountstatus; Type: INDEX; Schema: game_data; Owner: -
--

CREATE INDEX idx_player_accountstatus ON game_data.player USING btree (accountstatus_statusid);


--
-- Name: idx_quest_item; Type: INDEX; Schema: game_data; Owner: -
--

CREATE INDEX idx_quest_item ON game_data.quest USING btree (iteam_iteamid);


--
-- Name: idx_quest_location; Type: INDEX; Schema: game_data; Owner: -
--

CREATE INDEX idx_quest_location ON game_data.quest USING btree (location_locationid);


--
-- Name: idx_questlog_character_name; Type: INDEX; Schema: game_data; Owner: -
--

CREATE INDEX idx_questlog_character_name ON game_data.questlog USING btree (character_name);


--
-- Name: idx_questlog_quest_id; Type: INDEX; Schema: game_data; Owner: -
--

CREATE INDEX idx_questlog_quest_id ON game_data.questlog USING btree (quest_questid);


--
-- Name: idx_questlog_status_id; Type: INDEX; Schema: game_data; Owner: -
--

CREATE INDEX idx_questlog_status_id ON game_data.questlog USING btree (queststatus_statusid);


--
-- Name: developer_balance_test_results _RETURN; Type: RULE; Schema: game_data; Owner: -
--




--
-- Name: developer_economic_flow _RETURN; Type: RULE; Schema: game_data; Owner: -
--




--
-- Name: developer_item_distribution _RETURN; Type: RULE; Schema: game_data; Owner: -
--




--
-- Name: character trg_characterlevelup; Type: TRIGGER; Schema: game_data; Owner: -
--



--
-- Name: combatlog trg_combat_log_rewards; Type: TRIGGER; Schema: game_data; Owner: -
--



--
-- Name: guildmember trg_guildlevelcheck; Type: TRIGGER; Schema: game_data; Owner: -
--



--
-- Name: iteam_character trg_inventorylimitcheck; Type: TRIGGER; Schema: game_data; Owner: -
--



--
-- Name: character_class character_class_character_name_fkey; Type: FK CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.character_class
    ADD CONSTRAINT character_class_character_name_fkey FOREIGN KEY (character_name) REFERENCES game_data."character"(name);


--
-- Name: character_class character_class_class_name_fkey; Type: FK CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.character_class
    ADD CONSTRAINT character_class_class_name_fkey FOREIGN KEY (class_name) REFERENCES game_data.class(name);


--
-- Name: character character_player_userame_fkey; Type: FK CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data."character"
    ADD CONSTRAINT character_player_userame_fkey FOREIGN KEY (player_userame) REFERENCES game_data.player(username);


--
-- Name: class_skill class_skill_class_name_fkey; Type: FK CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.class_skill
    ADD CONSTRAINT class_skill_class_name_fkey FOREIGN KEY (class_name) REFERENCES game_data.class(name);


--
-- Name: class_skill class_skill_skill_skillid_fkey; Type: FK CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.class_skill
    ADD CONSTRAINT class_skill_skill_skillid_fkey FOREIGN KEY (skill_skillid) REFERENCES game_data.skill(skillid);


--
-- Name: combatlog combatlog_character_name_fkey; Type: FK CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.combatlog
    ADD CONSTRAINT combatlog_character_name_fkey FOREIGN KEY (character_name) REFERENCES game_data."character"(name);


--
-- Name: combatlog combatlog_location_locationid_fkey; Type: FK CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.combatlog
    ADD CONSTRAINT combatlog_location_locationid_fkey FOREIGN KEY (location_locationid) REFERENCES game_data.location(locationid);


--
-- Name: combatlog combatlog_monster_monsterid_fkey; Type: FK CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.combatlog
    ADD CONSTRAINT combatlog_monster_monsterid_fkey FOREIGN KEY (monster_monsterid) REFERENCES game_data.monster(monsterid);


--
-- Name: guild guild_leader_name_fkey; Type: FK CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.guild
    ADD CONSTRAINT guild_leader_name_fkey FOREIGN KEY (leader_name) REFERENCES game_data."character"(name);


--
-- Name: guildmember guildmember_character_name_fkey; Type: FK CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.guildmember
    ADD CONSTRAINT guildmember_character_name_fkey FOREIGN KEY (character_name) REFERENCES game_data."character"(name);


--
-- Name: guildmember guildmember_guild_name_fkey; Type: FK CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.guildmember
    ADD CONSTRAINT guildmember_guild_name_fkey FOREIGN KEY (guild_name) REFERENCES game_data.guild(name);


--
-- Name: guildmember guildmember_memberstatus_statusid_fkey; Type: FK CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.guildmember
    ADD CONSTRAINT guildmember_memberstatus_statusid_fkey FOREIGN KEY (memberstatus_statusid) REFERENCES game_data.memberstatus(memberstatusid);


--
-- Name: iteam_character iteam_character_character_name_fkey; Type: FK CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.iteam_character
    ADD CONSTRAINT iteam_character_character_name_fkey FOREIGN KEY (character_name) REFERENCES game_data."character"(name);


--
-- Name: iteam_character iteam_character_iteam_iteamid_fkey; Type: FK CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.iteam_character
    ADD CONSTRAINT iteam_character_iteam_iteamid_fkey FOREIGN KEY (iteam_iteamid) REFERENCES game_data.iteam(iteamid);


--
-- Name: iteam iteam_itemtype_categoryid_fkey; Type: FK CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.iteam
    ADD CONSTRAINT iteam_itemtype_categoryid_fkey FOREIGN KEY (itemtype_categoryid) REFERENCES game_data.itemtype(typeid);


--
-- Name: iteam iteam_rarity_rarityid_fkey; Type: FK CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.iteam
    ADD CONSTRAINT iteam_rarity_rarityid_fkey FOREIGN KEY (rarity_rarityid) REFERENCES game_data.rarity(rarityid);


--
-- Name: location location_locatiotype_typeid_fkey; Type: FK CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.location
    ADD CONSTRAINT location_locatiotype_typeid_fkey FOREIGN KEY (locatiotype_typeid) REFERENCES game_data.locationtype(typeid);


--
-- Name: monster_location monster_location_location_locationid_fkey; Type: FK CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.monster_location
    ADD CONSTRAINT monster_location_location_locationid_fkey FOREIGN KEY (location_locationid) REFERENCES game_data.location(locationid);


--
-- Name: monster_location monster_location_monster_monsterid_fkey; Type: FK CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.monster_location
    ADD CONSTRAINT monster_location_monster_monsterid_fkey FOREIGN KEY (monster_monsterid) REFERENCES game_data.monster(monsterid);


--
-- Name: player player_accountstatus_statusid_fkey; Type: FK CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.player
    ADD CONSTRAINT player_accountstatus_statusid_fkey FOREIGN KEY (accountstatus_statusid) REFERENCES game_data.accountstatus(statusid);


--
-- Name: procedureexecutionlog procedureexecutionlog_loglevel_loglevelid_fkey; Type: FK CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.procedureexecutionlog
    ADD CONSTRAINT procedureexecutionlog_loglevel_loglevelid_fkey FOREIGN KEY (loglevel_loglevelid) REFERENCES game_data.loglevel(loglevelid);


--
-- Name: quest_guild quest_guild_guild_name_fkey; Type: FK CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.quest_guild
    ADD CONSTRAINT quest_guild_guild_name_fkey FOREIGN KEY (guild_name) REFERENCES game_data.guild(name);


--
-- Name: quest_guild quest_guild_quest_questid_fkey; Type: FK CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.quest_guild
    ADD CONSTRAINT quest_guild_quest_questid_fkey FOREIGN KEY (quest_questid) REFERENCES game_data.quest(questid);


--
-- Name: quest quest_iteam_iteamid_fkey; Type: FK CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.quest
    ADD CONSTRAINT quest_iteam_iteamid_fkey FOREIGN KEY (iteam_iteamid) REFERENCES game_data.iteam(iteamid);


--
-- Name: quest quest_location_locationid_fkey; Type: FK CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.quest
    ADD CONSTRAINT quest_location_locationid_fkey FOREIGN KEY (location_locationid) REFERENCES game_data.location(locationid);


--
-- Name: questlog questlog_character_name_fkey; Type: FK CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.questlog
    ADD CONSTRAINT questlog_character_name_fkey FOREIGN KEY (character_name) REFERENCES game_data."character"(name);


--
-- Name: questlog questlog_quest_questid_fkey; Type: FK CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.questlog
    ADD CONSTRAINT questlog_quest_questid_fkey FOREIGN KEY (quest_questid) REFERENCES game_data.quest(questid);


--
-- Name: questlog questlog_queststatus_statusid_fkey; Type: FK CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.questlog
    ADD CONSTRAINT questlog_queststatus_statusid_fkey FOREIGN KEY (queststatus_statusid) REFERENCES game_data.queststatus(statusid);


--
-- Name: race_character race_character_character_name_fkey; Type: FK CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.race_character
    ADD CONSTRAINT race_character_character_name_fkey FOREIGN KEY (character_name) REFERENCES game_data."character"(name);


--
-- Name: race_character race_character_race_name_fkey; Type: FK CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.race_character
    ADD CONSTRAINT race_character_race_name_fkey FOREIGN KEY (race_name) REFERENCES game_data.race(name);


--
-- Name: skill_character skill_character_character_name_fkey; Type: FK CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.skill_character
    ADD CONSTRAINT skill_character_character_name_fkey FOREIGN KEY (character_name) REFERENCES game_data."character"(name);


--
-- Name: skill_character skill_character_skill_skillid_fkey; Type: FK CONSTRAINT; Schema: game_data; Owner: -
--

ALTER TABLE ONLY game_data.skill_character
    ADD CONSTRAINT skill_character_skill_skillid_fkey FOREIGN KEY (skill_skillid) REFERENCES game_data.skill(skillid);


--
-- PostgreSQL database dump complete
--


