-- ABC-анализ: распределение товаров по классам
WITH product_revenue AS (
    SELECT 
        product_id,
        SUM(total_price) AS revenue
    FROM raw.sales
    WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
    GROUP BY product_id
),
ranked AS (
    SELECT 
        product_id,
        revenue,
        SUM(revenue) OVER (ORDER BY revenue DESC) * 100.0 / SUM(revenue) OVER () AS cumulative_pct
    FROM product_revenue
)
SELECT 
    CASE 
        WHEN cumulative_pct <= 80 THEN 'A'
        WHEN cumulative_pct <= 95 THEN 'B'
        ELSE 'C'
    END AS abc_class,
    COUNT(*) AS products,
    ROUND(SUM(revenue) / 100.0, 2) AS revenue,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS products_share,
    ROUND(SUM(revenue) * 100.0 / SUM(SUM(revenue)) OVER (), 1) AS revenue_share
FROM ranked
GROUP BY abc_class
ORDER BY abc_class
