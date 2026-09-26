-- Всего товаров за период
SELECT 
    COUNT(DISTINCT product_id) AS total_products
FROM raw.sales
WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
