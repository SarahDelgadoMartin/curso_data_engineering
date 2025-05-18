{{
    config(
        materialized='table'
    )
}}

WITH events_data AS (
    SELECT
        *
    FROM
        {{ ref('stg_sql_server_dbo__events') }}
)

SELECT
    event_id,
    page_url,
    user_id,
    session_id,
    event_type,
    product_id,
    order_id,
    created_at_date AS event_date,
    created_at_time AS event_time,
    is_deleted
FROM
    events_data
    