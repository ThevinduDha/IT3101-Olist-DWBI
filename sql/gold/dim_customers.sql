USE olist_dw;
GO

-- 1. Drop table if it already exists to allow safe re-runs
DROP TABLE IF EXISTS dbo.dim_customers;
GO

-- 2. Create the Gold layer Dimension Table for Customers
CREATE TABLE dbo.dim_customers (
    customer_key INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate Key
    customer_id VARCHAR(50),
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(100),
    customer_state VARCHAR(50)
);
GO

-- 3. Populate the dimension table from your Silver layer data
INSERT INTO dbo.dim_customers (
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
)
SELECT 
    c.customer_id,
    c.customer_unique_id,
    c.customer_zip_code_prefix,
    c.customer_city,
    c.customer_state
FROM dbo.silver_customers c;
GO

-- 4. Verify the successful population
SELECT TOP 10 * FROM dbo.dim_customers;