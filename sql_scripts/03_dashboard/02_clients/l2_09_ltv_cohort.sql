WITH client_cohorts AS (
    SELECT 
        client_id,
        DATE_TRUNC('month', MIN(purchase_datetime))::date AS cohort_month
    FROM raw.sales
    WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
    GROUP BY client_id
),
client_revenue AS (
    SELECT 
        cc.cohort_month,
        cc.client_id,
        (
            (EXTRACT(YEAR FROM raw.sales.purchase_datetime) - EXTRACT(YEAR FROM cc.cohort_month)) * 12
            + (EXTRACT(MONTH FROM raw.sales.purchase_datetime) - EXTRACT(MONTH FROM cc.cohort_month))
        )::int AS month_index,
        SUM(raw.sales.total_price) / 100.0 AS client_revenue
    FROM raw.sales
    JOIN client_cohorts cc ON raw.sales.client_id = cc.client_id
    WHERE raw.sales.purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
    GROUP BY cc.cohort_month, cc.client_id, month_index
)
SELECT 
    TO_CHAR(cohort_month, 'YYYY-MM') AS "Когорта месяца",
    month_index AS "month_index",
    ROUND(AVG(client_revenue)) AS "ltv"
FROM client_revenue
GROUP BY cohort_month, month_index
ORDER BY cohort_month, month_index