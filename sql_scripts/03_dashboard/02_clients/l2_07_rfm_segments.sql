WITH client_stats AS (
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
        NTILE(5) OVER (ORDER BY last_purchase DESC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
        NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
    FROM client_stats
),
rfm_segments AS (
    SELECT 
        client_id,
        r_score,
        f_score,
        m_score,
        CASE 
            WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Чемпионы'
            WHEN r_score >= 3 AND f_score >= 3 AND m_score >= 3 THEN 'Лояльные'
            WHEN r_score <= 2 AND f_score >= 3 AND m_score >= 3 THEN 'В зоне риска'
            WHEN r_score <= 2 AND f_score <= 2 THEN 'Потерянные'
            WHEN r_score >= 4 AND f_score <= 2 THEN 'Новые'
            ELSE 'Прочие'
        END AS segment
    FROM rfm_scored
)
SELECT 
    segment,
    COUNT(*) AS clients
FROM rfm_segments
GROUP BY segment
ORDER BY clients DESC