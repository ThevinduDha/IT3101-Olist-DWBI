USE olist_dw;
GO

-- 1. Create the Silver layer table for order items
DROP TABLE IF EXISTS dbo.silver_order_items;

CREATE TABLE dbo.silver_order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
    price DECIMAL(18, 2),
    freight_value DECIMAL(18, 2)
);
GO

-- 2. Clean and insert data using the exact mix of normal and 'Copy of' columns
INSERT INTO dbo.silver_order_items (
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
)
SELECT 
    LTRIM(RTRIM([Copy of order_id])) AS order_id,
    TRY_CAST(order_item_id AS INT) AS order_item_id,
    LTRIM(RTRIM([Copy of product_id])) AS product_id,
    LTRIM(RTRIM([Copy of seller_id])) AS seller_id,
    TRY_CAST(shipping_limit_date AS DATETIME) AS shipping_limit_date,
    TRY_CAST(price AS DECIMAL(18, 2)) AS price,
    TRY_CAST(freight_value AS DECIMAL(18, 2)) AS freight_value
FROM dbo.bronze_order_items;
GO

-- 3. Verify the results
SELECT TOP 10 * FROM dbo.silver_order_items;