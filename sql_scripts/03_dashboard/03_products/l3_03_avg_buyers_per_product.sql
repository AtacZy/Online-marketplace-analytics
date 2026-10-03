SELECT 
    ROUND(
        COUNT(DISTINCT client_id)::numeric / NULLIF(COUNT(DISTINCT product_id), 0),
        2
    ) AS "Среднее кол-во покупателей на товар"
FROM raw.sales
WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}