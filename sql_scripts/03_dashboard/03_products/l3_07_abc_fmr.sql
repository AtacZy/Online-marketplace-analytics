WITH product_metrics AS (
    SELECT 
        product_id,
        SUM(total_price) / 100.0 AS revenue,
        COUNT(*) AS sales_count,
        SUM(discount_per_item * quantity) / 100.0 AS discount_total
    FROM raw.sales
    WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
    GROUP BY product_id
),
abc_count AS (
    SELECT 
        product_id,
        NTILE(100) OVER (ORDER BY sales_count DESC) AS rank_count
    FROM product_metrics
),
abc_revenue AS (
    SELECT 
        product_id,
        NTILE(100) OVER (ORDER BY revenue DESC) AS rank_revenue
    FROM product_metrics
),
fmr AS (
    SELECT 
        product_id,
        NTILE(3) OVER (ORDER BY sales_count DESC) AS fmr_group
    FROM product_metrics
)
SELECT 
    pm.product_id AS "Товар",
    pm.sales_count AS "Количество",
    ROUND(pm.revenue) AS "Выручка, ₽",
    ROUND(pm.discount_total) AS "Скидка, ₽",
    ROUND(pm.discount_total * 100.0 / NULLIF(pm.revenue, 0), 1) AS "% скидки",
    CASE 
        WHEN ac.rank_count <= 80 THEN 'A'
        WHEN ac.rank_count <= 95 THEN 'B'
        ELSE 'C'
    END AS "ABC Количество",
    CASE 
        WHEN ar.rank_revenue <= 80 THEN 'A'
        WHEN ar.rank_revenue <= 95 THEN 'B'
        ELSE 'C'
    END AS "ABC Выручка",
    CASE 
        WHEN f.fmr_group = 1 THEN 'F'
        WHEN f.fmr_group = 2 THEN 'M'
        ELSE 'R'
    END AS "FMR",
    CASE 
        WHEN ar.rank_revenue <= 80 THEN 'A'
        WHEN ar.rank_revenue <= 95 THEN 'B'
        ELSE 'C'
    END || 
    CASE 
        WHEN ac.rank_count <= 80 THEN 'A'
        WHEN ac.rank_count <= 95 THEN 'B'
        ELSE 'C'
    END || 
    CASE 
        WHEN f.fmr_group = 1 THEN 'F'
        WHEN f.fmr_group = 2 THEN 'M'
        ELSE 'R'
    END AS "Итог"
FROM product_metrics pm
JOIN abc_count ac ON pm.product_id = ac.product_id
JOIN abc_revenue ar ON pm.product_id = ar.product_id
JOIN fmr f ON pm.product_id = f.product_id
ORDER BY pm.revenue DESC
LIMIT 100