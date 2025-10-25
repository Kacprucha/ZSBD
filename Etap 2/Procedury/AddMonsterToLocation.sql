SET search_path TO game_data;

CREATE PROCEDURE sp_AssignMonsterToLocation(
    p_monster_id INT,
    p_location_id INT
) AS $$
DECLARE
    v_monster_exists BOOLEAN;
    v_location_exists BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM Monster WHERE MonsterID = p_monster_id) INTO v_monster_exists;
    SELECT EXISTS(SELECT 1 FROM Location WHERE LocationID = p_location_id) INTO v_location_exists;

    IF NOT v_monster_exists THEN
        RAISE EXCEPTION 'Monster of ID % does not exist.', p_monster_id;
    END IF;

    IF NOT v_location_exists THEN
        RAISE EXCEPTION 'Location of ID % does not exist.', p_location_id;
    END IF;

    INSERT INTO Monster_Location (Monster_MonsterID, Location_LocationID)
    VALUES (p_monster_id, p_location_id)
    ON CONFLICT (Monster_MonsterID, Location_LocationID) DO NOTHING;

    RAISE NOTICE 'Monster with ID % has been assigned to location with ID %.', p_monster_id, p_location_id;
END;
$$ LANGUAGE plpgsql;