-- Среднее количество единиц в заказе
SELECT 
    ROUND(AVG(quantity), 2) AS avg_quantity
FROM raw.sales
WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
