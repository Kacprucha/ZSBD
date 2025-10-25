SET search_path TO game_data;

CREATE FUNCTION fn_CheckInventoryLimit()
RETURNS TRIGGER AS $$
DECLARE
    v_item_count INT;
    v_limit INT := 50;
BEGIN
    SELECT COUNT(*) INTO v_item_count
    FROM Iteam_Character WHERE Character_Name = NEW.Character_Name;

    IF v_item_count >= v_limit THEN
        RAISE EXCEPTION 'Canot equip iteam. Equipment of character "%" is full (Iteams limit: % ).', NEW.Character_Name, v_limit;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_InventoryLimitCheck
BEFORE INSERT ON Iteam_Character
FOR EACH ROW
EXECUTE FUNCTION fn_CheckInventoryLimit();