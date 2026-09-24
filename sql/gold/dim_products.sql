USE olist_dw;
GO

-- 1. Drop table if it already exists
DROP TABLE IF EXISTS dbo.dim_products;
GO

-- 2. Create the Gold layer Dimension Table for Products
CREATE TABLE dbo.dim_products (
    product_key INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate Key
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

-- 3. Populate the dimension table from Silver products data
INSERT INTO dbo.dim_products (
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
    p.product_id,
    p.product_category_name,
    p.product_name_length,
    p.product_description_length,
    p.product_photos_qty,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM dbo.silver_products p;
GO

-- 4. Verify the results
SELECT TOP 10 * FROM dbo.dim_products;