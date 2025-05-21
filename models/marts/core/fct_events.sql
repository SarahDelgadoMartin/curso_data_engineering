{{
  config(
    materialized='incremental',
    unique_key='event_id',
    on_schema_change='append_new_columns'
  )
    }}

WITH events_data AS (
    SELECT *
    FROM {{ ref('stg_sql_server_dbo__events') }}

    {% if is_incremental() %}

	WHERE date_load > (SELECT MAX(date_load) FROM {{ this }} )

    {% endif %}
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
    created_at_timestamp AS event_timestamp,
    is_deleted,
    date_load
FROM events_data
    