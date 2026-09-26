-- Retention: % клиентов из прошлого периода, кто вернулся в этом
WITH active_before AS (
    SELECT DISTINCT client_id FROM raw.sales
    WHERE purchase_datetime < {{date_from}}
),
active_now AS (
    SELECT DISTINCT client_id FROM raw.sales
    WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
)
SELECT 
    ROUND(
        COUNT(*) FILTER (WHERE a.client_id IS NOT NULL) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS retention
FROM active_before b
LEFT JOIN active_now a ON b.client_id = a.client_id