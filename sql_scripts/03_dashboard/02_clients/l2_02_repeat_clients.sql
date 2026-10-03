WITH client_orders AS (
    SELECT 
        client_id,
        COUNT(*) AS orders
    FROM raw.sales
    WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
    GROUP BY client_id
)
SELECT 
    COUNT(*) FILTER (WHERE orders > 1) AS repeat_clients
FROM client_orders