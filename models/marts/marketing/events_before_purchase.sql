-- Comportamiento del Usuario en la Web (Eventos antes de la compra)
WITH relevant_events AS (
    SELECT
        event_id,
        page_url,
        user_id,
        session_id,
        event_type
    FROM
        YOUR_SCHEMA.fct_events
    WHERE
        event_type IN ('add_to_cart', 'view_product', 'begin_checkout') -- Ajusta estos tipos de evento según tus necesidades
),
purchasing_users AS (
    SELECT
        user_id,
        first_name,
        last_name,
        has_purchased
    FROM
        YOUR_SCHEMA.dim_user
    WHERE
        has_purchased = TRUE
)
SELECT
    pu.user_id,
    pu.first_name,
    pu.last_name,
    re.event_type,
    COUNT(re.event_id) AS event_count,
    COUNT(DISTINCT re.session_id) AS distinct_sessions
FROM
    relevant_events re
INNER JOIN
    purchasing_users pu ON re.user_id = pu.user_id
GROUP BY
    pu.user_id,
    pu.first_name,
    pu.last_name,
    re.event_type
ORDER BY
    pu.user_id,
    event_count DESC;