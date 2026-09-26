-- Выручка по месяцам
SELECT 
    DATE_TRUNC('month', purchase_datetime)::date AS month,
    ROUND(SUM(total_price) / 100.0, 2) AS revenue
FROM raw.sales
WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
GROUP BY month
ORDER BY month
