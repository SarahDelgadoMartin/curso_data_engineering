{{
  config(
    materialized='incremental',
    unique_key='event_id',
    on_schema_change='append_new_columns'
  )
    }}

WITH base_events AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo__events') }}

    {% if is_incremental() %}

	WHERE date_load > (SELECT MAX(date_load) FROM {{ this }} )

    {% endif %}
    ),

renamed_casted AS (
    SELECT
        event_id,
        page_url,
        user_id,
        session_id,
        event_type,
        DATE(created_at_timestamp) AS created_at_date,
        TIME(created_at_timestamp) AS created_at_time,
        is_deleted,
        date_load
    FROM base_events
    )   

SELECT * FROM renamed_casted
