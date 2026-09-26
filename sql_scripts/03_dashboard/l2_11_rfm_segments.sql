-- RFM-сегментация: распределение клиентов по сегментам
WITH rfm_raw AS (
    SELECT 
        client_id,
        MAX(purchase_datetime) AS last_purchase,
        COUNT(*) AS frequency,
        SUM(total_price) / 100.0 AS monetary
    FROM raw.sales
    WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
    GROUP BY client_id
),
rfm_scored AS (
    SELECT 
        client_id,
        CASE 
            WHEN ({{date_to}}::date - last_purchase) <= 30 AND frequency >= 5 AND monetary >= 50000 THEN 'Champions'
            WHEN ({{date_to}}::date - last_purchase) <= 60 AND frequency >= 3 THEN 'Loyal'
            WHEN ({{date_to}}::date - last_purchase) <= 90 THEN 'At Risk'
            WHEN ({{date_to}}::date - last_purchase) <= 180 THEN 'Lost'
            ELSE 'New'
        END AS segment
    FROM rfm_raw
)
SELECT 
    segment,
    COUNT(*) AS clients,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS share
FROM rfm_scored
GROUP BY segment
ORDER BY clients DESC