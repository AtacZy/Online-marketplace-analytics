-- MAU: средний MAU за период
SELECT 
    ROUND(AVG(mau), 0) AS avg_mau
FROM (
    SELECT 
        DATE_TRUNC('month', purchase_datetime) AS month,
        COUNT(DISTINCT client_id) AS mau
    FROM raw.sales
    WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
    GROUP BY month
) t
EO
exit
\q
cat > l2_08_mau.sql << 'EOF'
-- MAU: средний MAU за период
SELECT 
    ROUND(AVG(mau), 0) AS avg_mau
FROM (
    SELECT 
        DATE_TRUNC('month', purchase_datetime) AS month,
        COUNT(DISTINCT client_id) AS mau
    FROM raw.sales
    WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
    GROUP BY month
) t
