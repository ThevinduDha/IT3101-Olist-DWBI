USE olist_dw;
GO

-- 1. Recreate the Silver layer table for orders
DROP TABLE IF EXISTS dbo.silver_orders;

CREATE TABLE dbo.silver_orders (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_status VARCHAR(50),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);
GO

-- 2. Clean and insert data mapping from the 'Copy of' columns
INSERT INTO dbo.silver_orders (
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
)
SELECT 
    LTRIM(RTRIM([Copy of order_id])) AS order_id,
    LTRIM(RTRIM([Copy of customer_id])) AS customer_id,
    ISNULL(LOWER(LTRIM(RTRIM([Copy of order_status]))), 'unknown') AS order_status,
    TRY_CAST([Copy of order_purchase_timestamp] AS DATETIME) AS order_purchase_timestamp,
    TRY_CAST([Copy of order_approved_at] AS DATETIME) AS order_approved_at,
    TRY_CAST([Copy of order_delivered_carrier_date] AS DATETIME) AS order_delivered_carrier_date,
    TRY_CAST([Copy of order_delivered_customer_date] AS DATETIME) AS order_delivered_customer_date,
    TRY_CAST([Copy of order_estimated_delivery_date] AS DATETIME) AS order_estimated_delivery_date
FROM dbo.bronze_orders;
GO

-- 3. Verify the results
SELECT TOP 10 * FROM dbo.silver_orders;