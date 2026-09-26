-- Топ-5 товаров: лидеры и аутсайдеры по GMV
WITH top5 AS (
    SELECT 
        product_id,
        ROUND(SUM(total_price) / 100.0, 2) AS gmv
    FROM raw.sales
    WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
    GROUP BY product_id
    ORDER BY gmv DESC
    LIMIT 5
),
bottom5 AS (
    SELECT 
        product_id,
        ROUND(SUM(total_price) / 100.0, 2) AS gmv
    FROM raw.sales
    WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
    GROUP BY product_id
    HAVING SUM(total_price) > 0
    ORDER BY gmv ASC
    LIMIT 5
)
SELECT 
    t.product_id AS top_product,
    t.gmv AS top_gmv,
    b.product_id AS bottom_product,
    b.gmv AS bottom_gmv
FROM (SELECT *, ROW_NUMBER() OVER (ORDER BY gmv DESC) AS rn FROM top5) t
FULL JOIN (SELECT *, ROW_NUMBER() OVER (ORDER BY gmv ASC) AS rn FROM bottom5) b ON t.rn = b.rn
ORDER BY COALESCE(t.rn, b.rn)
