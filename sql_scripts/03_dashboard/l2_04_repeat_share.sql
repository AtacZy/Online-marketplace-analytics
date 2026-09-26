-- Доля повторных: % клиентов, купивших больше одного раза в периоде
WITH client_orders AS (
    SELECT 
        client_id,
        COUNT(*) AS orders
    FROM raw.sales
    WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
    GROUP BY client_id
)
SELECT 
    ROUND(
        COUNT(*) FILTER (WHERE orders > 1) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS repeat_share
FROM client_orders
