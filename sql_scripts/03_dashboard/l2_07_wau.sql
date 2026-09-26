-- WAU: средний WAU за период
SELECT 
    ROUND(AVG(wau), 0) AS avg_wau
FROM (
    SELECT 
        DATE_TRUNC('week', purchase_datetime) AS week,
        COUNT(DISTINCT client_id) AS wau
    FROM raw.sales
    WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
    GROUP BY week
) t
