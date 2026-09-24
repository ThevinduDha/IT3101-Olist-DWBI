USE olist_dw;
GO

-- 1. Recreate the Silver layer table for order payments
DROP TABLE IF EXISTS dbo.silver_order_payments;

CREATE TABLE dbo.silver_order_payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(50),
    payment_installments INT,
    payment_value DECIMAL(18, 2)
);
GO

-- 2. Clean and insert data mapping order_id from the correct column
INSERT INTO dbo.silver_order_payments (
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
)
SELECT 
    LTRIM(RTRIM([Copy of order_id])) AS order_id,
    TRY_CAST(payment_sequential AS INT) AS payment_sequential,
    ISNULL(LOWER(LTRIM(RTRIM(payment_type))), 'unknown') AS payment_type,
    TRY_CAST(payment_installments AS INT) AS payment_installments,
    TRY_CAST(payment_value AS DECIMAL(18, 2)) AS payment_value
FROM dbo.bronze_order_payments;
GO

-- 3. Verify the results
SELECT TOP 10 * FROM dbo.silver_order_payments;