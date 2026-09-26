-- Топ-5 клиентов по GMV
SELECT 
    client_id,
    ROUND(SUM(total_price) / 100.0, 2) AS gmv,
    COUNT(*) AS orders
FROM raw.sales
WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
GROUP BY client_id
ORDER BY gmv DESC
LIMIT 5
