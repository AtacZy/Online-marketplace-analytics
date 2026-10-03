SELECT 
    product_id AS "ID товара",
    ROUND(SUM(total_price) / 100.0, 2) AS "Выручка, ₽",
    COUNT(*) AS "Кол-во продаж"
FROM raw.sales
WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
GROUP BY product_id
ORDER BY SUM(total_price) DESC
LIMIT 10