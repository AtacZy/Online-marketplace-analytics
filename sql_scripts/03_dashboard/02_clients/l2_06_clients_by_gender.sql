SELECT 
    CASE gender
        WHEN 'M' THEN 'Мужчины'
        WHEN 'F' THEN 'Женщины'
        ELSE 'Не указан'
    END AS gender_label,
    COUNT(DISTINCT client_id) AS clients
FROM raw.sales
WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
GROUP BY gender
ORDER BY clients DESC