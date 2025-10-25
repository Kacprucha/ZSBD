SET search_path TO game_data;

CREATE TABLE LogLevel (
    LogLevelID serial PRIMARY KEY,
    LogLEvelName varchar(10) UNIQUE NOT NULL
);

CREATE TABLE CombatLog_Archive (
    LIKE CombatLog INCLUDING ALL
);

CREATE TABLE ProcedureExecutionLog (
LogID serial PRIMARY KEY,
ExecutionID UUID DEFAULT gen_random_uuid(), 
ProcedureName VARCHAR(100),
LogTimestamp timestamp with time zone DEFAULT NOW(),
LogLevel_LogLevelID int NOT NULL REFERENCES LogLevel(LogLevelID), 
Message TEXT
);

INSERT INTO LogLevel (LogLEvelName) VALUES 
('INFO'), 
('WARNING'), 
('ERROR');