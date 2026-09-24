USE olist_dw;
GO

-- 1. Recreate the Silver layer table for products
DROP TABLE IF EXISTS dbo.silver_products;

CREATE TABLE dbo.silver_products (
    product_id VARCHAR(50),
    product_category_name VARCHAR(100),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);
GO

-- 2. Clean and insert data, mapping product_id from the correct source column
INSERT INTO dbo.silver_products (
    product_id,
    product_category_name,
    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
)
SELECT 
    LTRIM(RTRIM([Copy of product_id])) AS product_id, -- Maps from the correct shifted column
    ISNULL(LOWER(LTRIM(RTRIM([Copy of product_category_name]))), 'unknown') AS product_category_name,
    TRY_CAST(product_name_lenght AS INT) AS product_name_length,
    TRY_CAST(product_description_lenght AS INT) AS product_description_length,
    TRY_CAST(product_photos_qty AS INT) AS product_photos_qty,
    TRY_CAST(product_weight_g AS INT) AS product_weight_g,
    TRY_CAST(product_length_cm AS INT) AS product_length_cm,
    TRY_CAST(product_height_cm AS INT) AS product_height_cm,
    TRY_CAST(product_width_cm AS INT) AS product_width_cm
FROM dbo.bronze_products;
GO

-- 3. Verify the results
SELECT TOP 10 * FROM dbo.silver_products;