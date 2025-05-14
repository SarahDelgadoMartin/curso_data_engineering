{{
  config(
    materialized='incremental',
    unique_key='order_event_id'
  )
    }}

WITH stg_events AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo__events') }}
    WHERE order_id != ''

    {% if is_incremental() %}

    AND date_load > (SELECT MAX(date_load) FROM {{ this }} )

    {% endif %}

    ),

renamed_casted AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['event_id', 'order_id']) }} AS order_event_id,
        event_id,
        order_id,
        is_delete,
        date_load
    FROM stg_events
    )   

SELECT * FROM renamed_casted
