DELIMITER $$
CREATE PROCEDURE sp_AddNewItem(
    IN p_name VARCHAR(25),
    IN p_description VARCHAR(70),
    IN p_category_id INT,
    IN p_rarity_id INT,
    IN p_price INT,
    IN p_retail_price INT,
    IN p_atack_bonus INT,
    IN p_defence_bonus INT,
    IN p_magic_bonus INT
)
BEGIN
    IF p_price <= p_retail_price THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error in business logic: Price must be greater than Retail Price.';
    END IF;

    INSERT INTO iteam (Name, Description, ItemType_CategoryID, Rarity_RarityID, Price, RetailPrice, AtackBonus, DefenceBonus, MagicBonus)
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
END$$
DELIMITER ;