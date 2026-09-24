USE olist_dw;
GO

-- 1. Recreate the Silver layer table for sellers
DROP TABLE IF EXISTS dbo.silver_sellers;

CREATE TABLE dbo.silver_sellers (
    seller_id VARCHAR(50),
    seller_zip_code_prefix VARCHAR(10),
    seller_city VARCHAR(100),
    seller_state VARCHAR(10)
);
GO

-- 2. Clean and insert data mapping columns from their 'Copy of' versions
INSERT INTO dbo.silver_sellers (
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
)
SELECT 
    LTRIM(RTRIM([Copy of seller_id])) AS seller_id,
    LTRIM(RTRIM(seller_zip_code_prefix)) AS seller_zip_code_prefix,
    LTRIM(RTRIM([Copy of seller_city])) AS seller_city,
    UPPER(LTRIM(RTRIM([Copy of seller_state]))) AS seller_state
FROM dbo.bronze_sellers;
GO

-- 3. Verify the results
SELECT TOP 10 * FROM dbo.silver_sellers;