-- Новые клиенты: первая покупка за всё время попала в период
WITH first_purchase AS (
    SELECT 
        client_id,
        MIN(purchase_datetime) AS first_date
    FROM raw.sales
    GROUP BY client_id
)
SELECT 
    COUNT(*) AS new_clients
FROM first_purchase
WHERE first_date BETWEEN {{date_from}} AND {{date_to}}
