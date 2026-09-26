-- MAU: уникальные клиенты по месяцам
SELECT 
    DATE_TRUNC('month', purchase_datetime)::date AS month,
    COUNT(DISTINCT client_id) AS mau
FROM raw.sales
WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
GROUP BY month
ORDER BY month
