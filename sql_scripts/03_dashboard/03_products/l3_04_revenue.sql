SELECT 
    ROUND(SUM(total_price) / 100.0, 2) AS "Товарооборот, ₽"
FROM raw.sales
WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}