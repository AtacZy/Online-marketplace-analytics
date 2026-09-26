-- Всего клиентов за период
SELECT 
    COUNT(DISTINCT client_id) AS total_clients
FROM raw.sales
WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
