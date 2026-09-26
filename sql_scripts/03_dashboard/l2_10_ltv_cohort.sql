-- LTV по когортам 2023: средний LTV клиентов по месяцу первой покупки в 2023
WITH first_purchase AS (
    SELECT 
        client_id,
        DATE_TRUNC('month', MIN(purchase_datetime))::date AS cohort_month
    FROM raw.sales
    GROUP BY client_id
),
client_revenue AS (
    SELECT 
        s.client_id,
        f.cohort_month,
        SUM(s.total_price) / 100.0 AS ltv
    FROM raw.sales s
    JOIN first_purchase f ON s.client_id = f.client_id
    WHERE s.purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
      AND f.cohort_month >= {{date_from}}::date
    GROUP BY s.client_id, f.cohort_month
)
SELECT 
    cohort_month,
    ROUND(AVG(ltv), 2) AS avg_ltv,
    COUNT(*) AS clients
FROM client_revenue
GROUP BY cohort_month
ORDER BY cohort_month