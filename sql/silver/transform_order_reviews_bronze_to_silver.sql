USE olist_dw;
GO

-- 1. Recreate the Silver layer table for order reviews
DROP TABLE IF EXISTS dbo.silver_order_reviews;

CREATE TABLE dbo.silver_order_reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title VARCHAR(255),
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);
GO

-- 2. Clean and insert data mapping both review_id and order_id from their 'Copy of' columns
INSERT INTO dbo.silver_order_reviews (
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
)
SELECT 
    LTRIM(RTRIM([Copy of review_id])) AS review_id,
    LTRIM(RTRIM([Copy of order_id])) AS order_id,
    TRY_CAST(review_score AS INT) AS review_score,
    LTRIM(RTRIM(review_comment_title)) AS review_comment_title,
    LTRIM(RTRIM(review_comment_message)) AS review_comment_message,
    TRY_CAST(review_creation_date AS DATETIME) AS review_creation_date,
    TRY_CAST(review_answer_timestamp AS DATETIME) AS review_answer_timestamp
FROM dbo.bronze_order_reviews;
GO

-- 3. Verify the results
SELECT TOP 10 * FROM dbo.silver_order_reviews;