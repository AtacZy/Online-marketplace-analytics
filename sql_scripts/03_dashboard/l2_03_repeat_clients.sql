-- Повторные клиенты: покупали больше одного раза в периоде
SELECT 
    COUNT(*) AS repeat_clients
FROM (
    SELECT client_id
    FROM raw.sales
    WHERE purchase_datetime BETWEEN {{date_from}} AND {{date_to}}
    GROUP BY client_id
    HAVING COUNT(*) > 1
) t
