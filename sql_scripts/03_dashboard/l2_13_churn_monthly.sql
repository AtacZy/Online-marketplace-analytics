-- Churn Rate по месяцам: % клиентов, которые ушли в следующем месяце
WITH monthly_clients AS (
    SELECT 
        DATE_TRUNC('month', purchase_datetime)::date AS month,
        client_id
    FROM raw.sales
    WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
    GROUP BY month, client_id
),
month_pairs AS (
    SELECT 
        m1.month AS month,
        COUNT(m1.client_id) AS clients_before,
        COUNT(m2.client_id) AS stayed,
        COUNT(m1.client_id) - COUNT(m2.client_id) AS churned
    FROM monthly_clients m1
    LEFT JOIN monthly_clients m2 
        ON m1.client_id = m2.client_id 
        AND m2.month = (m1.month + INTERVAL '1 month')::date
    GROUP BY m1.month
)
SELECT 
    month,
    clients_before,
    churned,
    ROUND(churned * 100.0 / NULLIF(clients_before, 0), 2) AS churn_rate
FROM month_pairs
WHERE month < (SELECT MAX(month) FROM monthly_clients)
ORDER BY month