-- Эффективность ассортимента: % активных товаров в день от общего
WITH daily_products AS (
    SELECT 
        purchase_datetime,
        COUNT(DISTINCT product_id) AS products_per_day
    FROM raw.sales
    WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
    GROUP BY purchase_datetime
),
total_products AS (
    SELECT COUNT(DISTINCT product_id) AS total
    FROM raw.sales
    WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
)
SELECT 
    ROUND(AVG(products_per_day) * 100.0 / NULLIF((SELECT total FROM total_products), 0), 2) AS efficiency_pct
FROM daily_products
