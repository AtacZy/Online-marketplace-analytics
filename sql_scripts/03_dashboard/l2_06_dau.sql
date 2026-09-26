-- DAU: средний DAU за период
SELECT 
    ROUND(AVG(dau), 0) AS avg_dau
FROM (
    SELECT 
        purchase_datetime,
        COUNT(DISTINCT client_id) AS dau
    FROM raw.sales
    WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
    GROUP BY purchase_datetime
) t
