WITH first_purchase AS (
    SELECT 
        client_id,
        MIN(purchase_datetime) AS first_date
    FROM raw.sales
    GROUP BY client_id
)
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
        first_date
    )::date AS period,
    COUNT(*) AS new_clients
FROM first_purchase
WHERE first_date BETWEEN {{date_from}} AND {{date_to}}
GROUP BY period
ORDER BY period