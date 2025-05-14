{{
  config(
    materialized='incremental',
    unique_key='product_event_id'
  )
    }}

WITH base_events AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo__events') }}
    WHERE product_id != ''

    {% if is_incremental() %}

	AND date_load >  (SELECT MAX(date_load) FROM {{ this }} )

    {% endif %}
    
    ),

renamed_casted AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['event_id', 'product_id']) }} AS product_event_id,
        event_id,
        product_id,
        is_delete,
        date_load
    FROM base_events

    )   

SELECT * FROM renamed_casted
