USE olist_dw;
GO

-- 1. Drop table if it already exists
DROP TABLE IF EXISTS dbo.fact_orders;
GO

-- 2. Create the Fact Table joining transactions with surrogate keys
CREATE TABLE dbo.fact_orders (
    order_item_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id VARCHAR(50),
    customer_key INT,
    product_key INT,
    seller_key INT,
    order_purchase_date_key INT,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),
    payment_value DECIMAL(10,2),
    review_score INT,
    
    -- Foreign Key constraints linking to your dimensions
    FOREIGN KEY (customer_key) REFERENCES dbo.dim_customers(customer_key),
    FOREIGN KEY (product_key) REFERENCES dbo.dim_products(product_key),
    FOREIGN KEY (seller_key) REFERENCES dbo.dim_sellers(seller_key),
    FOREIGN KEY (order_purchase_date_key) REFERENCES dbo.dim_date(date_key)
);
GO

-- 3. Populate the Fact Table by joining Silver tables and looking up surrogate keys
INSERT INTO dbo.fact_orders (
    order_id,
    customer_key,
    product_key,
    seller_key,
    order_purchase_date_key,
    price,
    freight_value,
    payment_value,
    review_score
)
SELECT 
    oi.order_id,
    dc.customer_key,
    dp.product_key,
    ds.seller_key,
    ISNULL(CAST(FORMAT(o.order_purchase_timestamp, 'yyyyMMdd') AS INT), 19000101),
    oi.price,
    oi.freight_value,
    op.payment_value,
    ore.review_score
FROM dbo.silver_order_items oi
LEFT JOIN dbo.silver_orders o ON oi.order_id = o.order_id
LEFT JOIN dbo.dim_customers dc ON o.customer_id = dc.customer_id
LEFT JOIN dbo.dim_products dp ON oi.product_id = dp.product_id
LEFT JOIN dbo.dim_sellers ds ON oi.seller_id = ds.seller_id
LEFT JOIN dbo.silver_order_payments op ON oi.order_id = op.order_id
LEFT JOIN dbo.silver_order_reviews ore ON oi.order_id = ore.order_id;
GO

-- 4. Verify the results
SELECT TOP 10 * FROM dbo.fact_orders;