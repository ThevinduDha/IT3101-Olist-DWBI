USE olist_dw;
GO

-- 1. Drop view if it already exists
DROP VIEW IF EXISTS dbo.dm_customer_insights;
GO

-- 2. Create Customer & Service Quality Insights Data Mart View
CREATE VIEW dbo.dm_customer_insights AS
SELECT 
    f.order_id,
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    d.full_date AS purchase_date,
    f.payment_value,
    f.review_score,
    CASE 
        WHEN f.review_score = 5 THEN 'Very Satisfied'
        WHEN f.review_score = 4 THEN 'Satisfied'
        WHEN f.review_score = 3 THEN 'Neutral'
        WHEN f.review_score <= 2 THEN 'Dissatisfied'
        ELSE 'No Review'
    END AS satisfaction_category
FROM dbo.fact_orders f
JOIN dbo.dim_customers c ON f.customer_key = c.customer_key
JOIN dbo.dim_date d ON f.order_purchase_date_key = d.date_key;
GO

SELECT TOP 5 * FROM dbo.dm_customer_insights;