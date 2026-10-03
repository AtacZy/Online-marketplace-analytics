SELECT 
    DATE_TRUNC(
        CASE {{granularity}}
            WHEN 'Месяц' THEN 'month'
            WHEN 'Неделя' THEN 'week'
            WHEN 'День' THEN 'day'
            WHEN 'Квартал' THEN 'quarter'
            WHEN 'Год' THEN 'year'
            ELSE 'month'
        END,
        purchase_datetime
    )::date AS period,
    COUNT(*) AS orders
FROM raw.sales
WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
GROUP BY period
ORDER BY period