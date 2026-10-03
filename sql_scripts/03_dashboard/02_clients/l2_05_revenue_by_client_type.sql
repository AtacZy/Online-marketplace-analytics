WITH first_purchase AS (
    SELECT 
        client_id,
        MIN(purchase_datetime) AS first_date
    FROM raw.sales
    GROUP BY client_id
),
sales_with_type AS (
    SELECT 
        s.total_price,
        CASE 
            WHEN fp.first_date BETWEEN {{date_from}} AND {{date_to}} THEN 'Новые'
            ELSE 'Повторные'
        END AS client_type
    FROM raw.sales s
    JOIN first_purchase fp ON s.client_id = fp.client_id
    WHERE s.purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
)
SELECT 
    client_type,
    ROUND(SUM(total_price) / 100.0, 2) AS revenue,
    ROUND(
        SUM(total_price) * 100.0 / SUM(SUM(total_price)) OVER (),
        1
    ) AS revenue_share_pct
FROM sales_with_type
GROUP BY client_type
ORDER BY client_type