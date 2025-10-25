SET search_path TO game_data;

CREATE PROCEDURE sp_RunWeeklyMaintenance()
AS $$
DECLARE
    v_rows_archived INT;
    v_top_player_1 VARCHAR;
    v_top_player_2 VARCHAR;
    v_top_player_3 VARCHAR;
    v_top_players_array VARCHAR[]; 
    v_reward_amount INT := 500;
    v_summary TEXT;
    v_execution_id UUID := gen_random_uuid();
BEGIN
    v_execution_id := gen_random_uuid();

    INSERT INTO game_data.ProcedureExecutionLog (ExecutionID, ProcedureName, LogLevel_LogLevelID, Message)
    VALUES (v_execution_id, 'sp_RunWeeklyMaintenance', 1, 'Beginigng weekly maintenance');

    RAISE NOTICE 'Archivising old logs form CombatLog and analizing character activity...';

    WITH moved_rows AS (
        DELETE FROM game_data.CombatLog
        WHERE CombatLogID IN (SELECT CombatLogID FROM game_data.CombatLog ORDER BY CombatLogID ASC LIMIT 100000)
        RETURNING * 
    ),
    archived_data AS (
        INSERT INTO game_data.CombatLog_Archive SELECT * FROM moved_rows
        RETURNING * 
    ),
    activity_analysis AS (
        SELECT Character_Name, COUNT(*) AS fight_count
        FROM archived_data
        GROUP BY Character_Name
        ORDER BY fight_count DESC
        LIMIT 3
    )
    SELECT ARRAY_AGG(Character_Name)
    INTO v_top_players_array
    FROM activity_analysis;

    IF v_top_players_array IS NOT NULL THEN
        v_top_player_1 := v_top_players_array[1];
        v_top_player_2 := v_top_players_array[2];
        v_top_player_3 := v_top_players_array[3];
    END IF;

    SELECT COUNT(*) INTO v_rows_archived FROM game_data.CombatLog_Archive WHERE CombatLogID > (SELECT COALESCE(MAX(CombatLogID), 0) FROM game_data.CombatLog_Archive) - 100000;

    INSERT INTO game_data.ProcedureExecutionLog (ExecutionID, ProcedureName, LogLevel_LogLevelID, Message)
    VALUES (v_execution_id, 'sp_RunWeeklyMaintenance', 1, format('Archivised %s rows form CombatLog.', v_rows_archived));

    RAISE NOTICE 'Rewarding charaxter based on analysis of archived data...';
    IF v_top_player_1 IS NOT NULL THEN
        UPDATE game_data.Character SET Gold = Gold + v_reward_amount WHERE Name = v_top_player_1;
    END IF;
    IF v_top_player_2 IS NOT NULL THEN
        UPDATE game_data.Character SET Gold = Gold + v_reward_amount WHERE Name = v_top_player_2;
    END IF;
    IF v_top_player_3 IS NOT NULL THEN
        UPDATE game_data.Character SET Gold = Gold + v_reward_amount WHERE Name = v_top_player_3;
    END IF;

    RAISE NOTICE 'Resetting weekly guild Contribution...';
    UPDATE game_data.GuildMember SET Contribution = 0;
    
    v_summary := format('Completed successfully. Approximately %s rows archived. Players awarded based on archived data: %s, %s, %s.',
                        v_rows_archived,
                        COALESCE(v_top_player_1, 'N/A'),
                        COALESCE(v_top_player_2, 'N/A'),
                        COALESCE(v_top_player_3, 'N/A'));

    INSERT INTO game_data.ProcedureExecutionLog (ExecutionID, ProcedureName, LogLevel_LogLevelID, Message)
    VALUES (v_execution_id, 'sp_RunWeeklyMaintenance', 1, v_summary);

    RAISE NOTICE 'Weekly maintenance completed.';
END;
$$ LANGUAGE plpgsql;