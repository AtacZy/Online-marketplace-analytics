SELECT 
    COUNT(DISTINCT product_id) AS "Активные SKU"
FROM raw.sales
WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}