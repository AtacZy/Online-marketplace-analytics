-- Клиенты по полу
SELECT 
    gender,
    COUNT(DISTINCT client_id) AS clients,
    ROUND(COUNT(DISTINCT client_id) * 100.0 / SUM(COUNT(DISTINCT client_id)) OVER (), 1) AS share
FROM raw.sales
WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
GROUP BY gender
ORDER BY gender
