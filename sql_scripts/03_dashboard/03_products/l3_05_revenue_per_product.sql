SELECT 
    ROUND(
        SUM(total_price) / 100.0 / NULLIF(COUNT(DISTINCT product_id), 0),
        2
    ) AS "Выручка с одного товара, ₽"
FROM raw.sales
WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}