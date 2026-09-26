-- Растущие vs падающие товары: изменение GMV год к году
WITH current_period AS (
    SELECT 
        product_id,
        SUM(total_price) AS revenue
    FROM raw.sales
    WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
    GROUP BY product_id
),
previous_period AS (
    SELECT 
        product_id,
        SUM(total_price) AS revenue
    FROM raw.sales
    WHERE purchase_datetime BETWEEN 
        ({{date_from}}::date - INTERVAL '1 year')::date AND 
        ({{date_to}}::date - INTERVAL '1 year')::date
    GROUP BY product_id
)
SELECT 
    CASE 
        WHEN p.revenue IS NULL OR p.revenue = 0 THEN 'new'
        WHEN (c.revenue - p.revenue) * 100.0 / p.revenue > 30 THEN 'growing'
        WHEN (c.revenue - p.revenue) * 100.0 / p.revenue < -30 THEN 'declining'
        ELSE 'stable'
    END AS trend,
    COUNT(*) AS products,
    MIN(
        CASE 
            WHEN p.revenue IS NULL OR p.revenue = 0 THEN 4
            WHEN (c.revenue - p.revenue) * 100.0 / p.revenue > 30 THEN 1
            WHEN (c.revenue - p.revenue) * 100.0 / p.revenue < -30 THEN 3
            ELSE 2
        END
    ) AS sort_order
FROM current_period c
LEFT JOIN previous_period p ON c.product_id = p.product_id
GROUP BY trend
ORDER BY sort_order