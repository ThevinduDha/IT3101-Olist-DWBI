USE olist_dw;
GO

-- 1. Drop view if it already exists
DROP VIEW IF EXISTS dbo.dm_sales_performance;
GO

-- 2. Create Sales & Executive Performance Data Mart View
CREATE VIEW dbo.dm_sales_performance AS
SELECT 
    f.order_id,
    d.full_date AS order_date,
    d.year_number,
    d.month_name,
    d.quarter_number,
    c.customer_state,
    c.customer_city,
    p.product_category_name,
    s.seller_state,
    f.price,
    f.freight_value,
    (f.price + f.freight_value) AS total_order_value,
    f.payment_value,
    f.review_score
FROM dbo.fact_orders f
JOIN dbo.dim_date d ON f.order_purchase_date_key = d.date_key
JOIN dbo.dim_customers c ON f.customer_key = c.customer_key
JOIN dbo.dim_products p ON f.product_key = p.product_key
JOIN dbo.dim_sellers s ON f.seller_key = s.seller_key;
GO

SELECT TOP 5 * FROM dbo.dm_sales_performance;