-- Retention по когортам 2023: % активных клиентов когорты по месяцам
WITH first_purchase AS (
    SELECT 
        client_id,
        DATE_TRUNC('month', MIN(purchase_datetime))::date AS cohort_month
    FROM raw.sales
    GROUP BY client_id
),
cohort_size AS (
    SELECT 
        cohort_month,
        COUNT(*) AS cohort_clients
    FROM first_purchase
    WHERE cohort_month >= {{date_from}}::date
    GROUP BY cohort_month
),
activity AS (
    SELECT 
        f.cohort_month,
        DATE_TRUNC('month', s.purchase_datetime)::date AS activity_month,
        COUNT(DISTINCT s.client_id) AS active_clients
    FROM raw.sales s
    JOIN first_purchase f ON s.client_id = f.client_id
    WHERE s.purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
      AND f.cohort_month >= {{date_from}}::date
    GROUP BY f.cohort_month, activity_month
)
SELECT 
    a.cohort_month,
    a.activity_month,
    a.active_clients,
    c.cohort_clients,
    ROUND(a.active_clients * 100.0 / NULLIF(c.cohort_clients, 0), 2) AS retention_pct
FROM activity a
JOIN cohort_size c ON a.cohort_month = c.cohort_month
ORDER BY a.cohort_month, a.activity_month