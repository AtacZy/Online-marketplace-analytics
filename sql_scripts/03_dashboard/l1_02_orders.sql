-- Количество заказов за период
SELECT 
    COUNT(*) AS orders
FROM raw.sales
WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
