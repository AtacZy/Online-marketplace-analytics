WITH client_cohorts AS (
    SELECT 
        client_id,
        DATE_TRUNC('month', MIN(purchase_datetime))::date AS cohort_month
    FROM raw.sales
    WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
    GROUP BY client_id
),
client_activity AS (
    SELECT DISTINCT
        cc.cohort_month,
        cc.client_id,
        (
            (EXTRACT(YEAR FROM raw.sales.purchase_datetime) - EXTRACT(YEAR FROM cc.cohort_month)) * 12
            + (EXTRACT(MONTH FROM raw.sales.purchase_datetime) - EXTRACT(MONTH FROM cc.cohort_month))
        )::int AS month_index
    FROM raw.sales
    JOIN client_cohorts cc ON raw.sales.client_id = cc.client_id
    WHERE raw.sales.purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
),
cohort_size AS (
    SELECT 
        cohort_month,
        COUNT(DISTINCT client_id) AS cohort_clients
    FROM client_cohorts
    GROUP BY cohort_month
),
retention_matrix AS (
    SELECT 
        ca.cohort_month,
        ca.month_index,
        COUNT(DISTINCT ca.client_id) AS active_clients
    FROM client_activity ca
    GROUP BY ca.cohort_month, ca.month_index
),
percentages AS (
    SELECT 
        rm.cohort_month,
        rm.month_index,
        ROUND(rm.active_clients * 100.0 / NULLIF(cs.cohort_clients, 0), 1) AS retention_pct
    FROM retention_matrix rm
    JOIN cohort_size cs ON rm.cohort_month = cs.cohort_month
)
SELECT 
    TO_CHAR(cohort_month, 'YYYY-MM') AS "Когорта месяца",
    month_index AS "month_index",
    retention_pct AS "retention_pct"
FROM percentages
ORDER BY cohort_month, month_index