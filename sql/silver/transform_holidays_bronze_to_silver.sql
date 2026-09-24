USE olist_dw;
GO

-- 1. Create the Silver layer table if it doesn't exist
DROP TABLE IF EXISTS dbo.silver_holidays;

CREATE TABLE dbo.silver_holidays (
    holiday_date DATE,
    local_name VARCHAR(255),
    name VARCHAR(255),
    country_code VARCHAR(10),
    is_fixed BIT,
    is_global BIT,
    holiday_type VARCHAR(100)
);
GO

-- 2. Parse the raw JSON using OPENJSON and insert into Silver
INSERT INTO dbo.silver_holidays (
    holiday_date, 
    local_name, 
    name, 
    country_code, 
    is_fixed, 
    is_global, 
    holiday_type
)
SELECT 
    CAST(j.date AS DATE) AS holiday_date,
    j.localName AS local_name,
    j.name AS name,
    j.countryCode AS country_code,
    CAST(j.fixed AS BIT) AS is_fixed,
    CAST(j.[global] AS BIT) AS is_global,
    j.types AS holiday_type
FROM dbo.bronze_landing_holidays b
CROSS APPLY OPENJSON(b.raw_json) 
WITH (
    date VARCHAR(20) '$.date',
    localName VARCHAR(255) '$.localName',
    name VARCHAR(255) '$.name',
    countryCode VARCHAR(10) '$.countryCode',
    fixed VARCHAR(10) '$.fixed',
    [global] VARCHAR(10) '$.global',
    types VARCHAR(100) '$.types'
) AS j;
GO

-- 3. Verify the clean data
SELECT TOP 10 * FROM dbo.silver_holidays;