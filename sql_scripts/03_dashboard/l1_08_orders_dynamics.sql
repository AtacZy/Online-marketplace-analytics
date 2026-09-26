-- Количество заказов по месяцам
SELECT 
    DATE_TRUNC('month', purchase_datetime)::date AS month,
    COUNT(*) AS orders
FROM raw.sales
WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
GROUP BY month
ORDER BY month
