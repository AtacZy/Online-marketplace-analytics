-- Средний чек за период
SELECT 
    ROUND(AVG(total_price) / 100.0, 2) AS avg_check
FROM raw.sales
WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
