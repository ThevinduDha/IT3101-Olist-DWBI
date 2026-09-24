USE olist_dw;
GO

-- 1. Create the Silver layer table with safe column sizes
DROP TABLE IF EXISTS dbo.silver_geolocation;

CREATE TABLE dbo.silver_geolocation (
    geolocation_zip_code_prefix VARCHAR(10),
    geolocation_lat FLOAT,
    geolocation_lng FLOAT,
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(50) -- Expanded to 50 to safely handle any length
);
GO

-- 2. Clean and insert data from the landing table
INSERT INTO dbo.silver_geolocation (
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
)
SELECT 
    LTRIM(RTRIM(["geolocation_zip_code_prefix"])) AS geolocation_zip_code_prefix,
    TRY_CAST(["geolocation_lat"] AS FLOAT) AS geolocation_lat,
    TRY_CAST(["geolocation_lng"] AS FLOAT) AS geolocation_lng,
    LTRIM(RTRIM(["geolocation_city"])) AS geolocation_city,
    UPPER(LTRIM(RTRIM(["geolocation_state"]))) AS geolocation_state
FROM dbo.bronze_landing_geolocation;
GO

-- 3. Verify the results
SELECT TOP 10 * FROM dbo.silver_geolocation;