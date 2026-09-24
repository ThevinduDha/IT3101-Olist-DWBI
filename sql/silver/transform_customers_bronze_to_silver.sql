USE olist_dw;
GO

-- 1. Create the Silver layer table for customers
DROP TABLE IF EXISTS dbo.silver_customers;

CREATE TABLE dbo.silver_customers (
    customer_id VARCHAR(50),
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);
GO

-- 2. Clean and insert data from Bronze to Silver
INSERT INTO dbo.silver_customers (
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
)
SELECT 
    LTRIM(RTRIM(customer_id)) AS customer_id,
    LTRIM(RTRIM(customer_unique_id)) AS customer_unique_id,
    LTRIM(RTRIM(customer_zip_code_prefix)) AS customer_zip_code_prefix,
    -- Capitalize city names nicely or clean trailing spaces
    LTRIM(RTRIM(customer_city)) AS customer_city,
    UPPER(LTRIM(RTRIM(customer_state))) AS customer_state
FROM dbo.bronze_customers; -- (Adjust table name if your Bronze customer landing table is named differently)
GO

-- 3. Verify the results
SELECT TOP 10 * FROM dbo.silver_customers;

