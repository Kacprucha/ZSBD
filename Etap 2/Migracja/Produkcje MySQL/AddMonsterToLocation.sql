DELIMITER $$
CREATE PROCEDURE sp_AssignMonsterToLocation(
    IN p_monster_id INT,
    IN p_location_id INT
)
BEGIN
    INSERT IGNORE INTO monster_location (Monster_MonsterID, Location_LocationID)
    VALUES (p_monster_id, p_location_id);
END$$
DELIMITER ;