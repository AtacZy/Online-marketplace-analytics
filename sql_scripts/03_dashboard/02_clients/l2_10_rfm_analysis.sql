WITH client_stats AS (
    SELECT 
        client_id,
        MIN(purchase_datetime)::date AS first_purchase,
        MAX(purchase_datetime)::date AS last_purchase,
        COUNT(*) AS frequency,
        SUM(total_price) / 100.0 AS monetary
    FROM raw.sales
    WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
    GROUP BY client_id
),
rfm_scored AS (
    SELECT 
        client_id,
        first_purchase,
        NTILE(5) OVER (ORDER BY last_purchase DESC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
        NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
    FROM client_stats
)
SELECT 
    client_id AS "Клиент",
    first_purchase AS "Дата первого заказа в периоде",
    r_score AS "R",
    f_score AS "F",
    m_score AS "M",
    CONCAT(r_score, f_score, m_score) AS "RFM"
FROM rfm_scored
ORDER BY client_id
LIMIT 100