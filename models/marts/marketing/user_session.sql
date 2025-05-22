WITH fct_event AS (
    SELECT
        event_id,
        session_id,
        user_id,
        event_type,
        event_timestamp
    FROM {{ ref('fct_events') }}
    ),

dim_user AS (
    SELECT
        user_id,
        first_name,
        email
    FROM {{ ref('dim_user') }}
    ),

session_metrics AS (
    SELECT
        session_id,
        user_id,
        MIN(event_timestamp) AS first_event_time_utc,
        MAX(event_timestamp) AS last_event_time_utc,
        DATEDIFF(minute, MIN(event_timestamp), MAX(event_timestamp)) AS session_lenght_minutes,
        SUM(CASE 
                WHEN event_type = 'page_view' THEN 1
                ELSE 0
            END) AS page_view,
        SUM(CASE
                WHEN event_type = 'add_to_cart' THEN 1
                ELSE 0
            END) AS add_to_cart,
        SUM(CASE
                WHEN event_type = 'checkout' THEN 1
                ELSE 0
            END) AS checkout,
        SUM(CASE 
                WHEN event_type = 'package_shipped' THEN 1
                ELSE 0
            END) AS package_shipped
    FROM fct_event
    GROUP BY session_id, user_id
    )

SELECT
    sm.session_id,
    sm.user_id,
    du.first_name,
    du.email,
    sm.first_event_time_utc,
    sm.last_event_time_utc,
    sm.session_lenght_minutes,
    sm.page_view,
    sm.add_to_cart,
    sm.checkout,
    sm.package_shipped
FROM session_metrics sm
INNER JOIN dim_user du ON sm.user_id = du.user_id
