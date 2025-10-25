SET search_path TO game_data;

CREATE PROCEDURE sp_AddNewItem(
    p_name VARCHAR(25),
    p_description VARCHAR(70),
    p_category_id INT,
    p_rarity_id INT,
    p_price INT,
    p_retail_price INT,
    p_atack_bonus INT DEFAULT 0,
    p_defence_bonus INT DEFAULT 0,
    p_magic_bonus INT DEFAULT 0
) AS $$
BEGIN
    IF p_price <= p_retail_price THEN
        RAISE EXCEPTION 'Error in business logic: Price (%) must be greater than Retail Price (%).', p_price, p_retail_price;
    END IF;

    INSERT INTO Iteam (Name, Description, ItemType_CategoryID, Rarity_RarityID, Price, RetailPrice, AtackBonus, DefenceBonus, MagicBonus)
    VALUES (
        p_name,
        p_description,
        p_category_id,
        p_rarity_id,
        p_price,
        p_retail_price,
        p_atack_bonus,
        p_defence_bonus,
        p_magic_bonus
    );

    RAISE NOTICE 'New item "%" has been added successfully.', p_name;
END;
$$ LANGUAGE plpgsql;