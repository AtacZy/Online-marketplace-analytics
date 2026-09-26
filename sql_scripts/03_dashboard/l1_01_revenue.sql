-- Выручка за период
SELECT 
    SUM(total_price) / 100.0 AS revenue
FROM raw.sales
WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}