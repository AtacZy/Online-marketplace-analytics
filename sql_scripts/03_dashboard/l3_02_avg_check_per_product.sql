-- Средний чек по товару: средняя выручка с одного товара
SELECT 
    ROUND(SUM(total_price) / 100.0 / NULLIF(COUNT(DISTINCT product_id), 0), 2) AS avg_check_per_product
FROM raw.sales
WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
