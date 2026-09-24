USE olist_dw;
GO

-- 1. Drop table if it already exists
DROP TABLE IF EXISTS dbo.dim_date;
GO

-- 2. Create the Date Dimension Table
CREATE TABLE dbo.dim_date (
    date_key INT PRIMARY KEY, -- Format: YYYYMMDD
    full_date DATE UNIQUE,
    day_of_week INT,
    day_name VARCHAR(15),
    day_of_month INT,
    month_number INT,
    month_name VARCHAR(15),
    quarter_number INT,
    year_number INT
);
GO

-- 3. Populate date dimension dynamically covering your data range (2016 to 2018 for Olist)
DECLARE @StartDate DATE = '2016-01-01';
DECLARE @EndDate DATE = '2018-12-31';

WHILE @StartDate <= @EndDate
BEGIN
    INSERT INTO dbo.dim_date (
        date_key,
        full_date,
        day_of_week,
        day_name,
        day_of_month,
        month_number,
        month_name,
        quarter_number,
        year_number
    )
    SELECT 
        CAST(FORMAT(@StartDate, 'yyyyMMdd') AS INT),
        @StartDate,
        DATEPART(WEEKDAY, @StartDate),
        DATENAME(WEEKDAY, @StartDate),
        DAY(@StartDate),
        MONTH(@StartDate),
        DATENAME(MONTH, @StartDate),
        DATEPART(QUARTER, @StartDate),
        YEAR(@StartDate);

    SET @StartDate = DATEADD(day, 1, @StartDate);
END;
GO

-- 4. Verify the results
SELECT TOP 10 * FROM dbo.dim_date;