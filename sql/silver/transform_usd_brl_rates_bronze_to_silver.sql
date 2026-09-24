USE olist_dw;
GO

-- 1. Recreate the Silver layer table for exchange rates
DROP TABLE IF EXISTS dbo.silver_usd_brl_rates;

CREATE TABLE dbo.silver_usd_brl_rates (
    rate_date DATE,
    bid_rate DECIMAL(18, 4),
    ask_rate DECIMAL(18, 4)
);
GO

-- 2. Parse the raw JSON with correct date styling (Style 103 for DD/MM/YYYY)
INSERT INTO dbo.silver_usd_brl_rates (
    rate_date, 
    bid_rate, 
    ask_rate
)
SELECT 
    CONVERT(DATE, j.dt, 103) AS rate_date,
    CAST(j.bid AS DECIMAL(18, 4)) AS bid_rate,
    CAST(j.ask AS DECIMAL(18, 4)) AS ask_rate
FROM dbo.bronze_landing_usd_brl_rates b
CROSS APPLY OPENJSON(b.raw_json) 
WITH (
    dt VARCHAR(20) '$.data',
    bid VARCHAR(20) '$.valor',
    ask VARCHAR(20) '$.ask'
) AS j;
GO

-- 3. Verify the clean data
SELECT TOP 10 * FROM dbo.silver_usd_brl_rates;