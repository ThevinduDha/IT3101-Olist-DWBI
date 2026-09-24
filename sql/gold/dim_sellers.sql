USE olist_dw;
GO

-- 1. Drop table if it already exists
DROP TABLE IF EXISTS dbo.dim_sellers;
GO

-- 2. Create the Gold layer Dimension Table for Sellers
CREATE TABLE dbo.dim_sellers (
    seller_key INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate Key
    seller_id VARCHAR(50),
    seller_zip_code_prefix VARCHAR(10),
    seller_city VARCHAR(100),
    seller_state VARCHAR(50)
);
GO

-- 3. Populate the dimension table from Silver sellers data
INSERT INTO dbo.dim_sellers (
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
)
SELECT 
    s.seller_id,
    s.seller_zip_code_prefix,
    s.seller_city,
    s.seller_state
FROM dbo.silver_sellers s;
GO

-- 4. Verify the results
SELECT TOP 10 * FROM dbo.dim_sellers;