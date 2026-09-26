-- Распределение клиентов по количеству заказов
WITH client_orders AS (
    SELECT 
        client_id,
        COUNT(*) AS orders
    FROM raw.sales
    WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
    GROUP BY client_id
)
SELECT 
    CASE 
        WHEN orders = 1 THEN '1 заказ'
        WHEN orders BETWEEN 2 AND 5 THEN '2-5'
        WHEN orders BETWEEN 6 AND 10 THEN '6-10'
        ELSE '10+'
    END AS category,
    COUNT(*) AS clients,
    MIN(orders) AS sort_order
FROM client_orders
GROUP BY category
ORDER BY sort_order