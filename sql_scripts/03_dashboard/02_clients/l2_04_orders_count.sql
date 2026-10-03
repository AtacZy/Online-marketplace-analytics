SELECT 
    COUNT(*) AS orders
FROM raw.sales
WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}