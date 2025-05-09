{{
  config(
    materialized='incremental'
  )
    }}

WITH src_events AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo__events') }}

    {% if is_incremental() %}

	WHERE _fivetran_synced > (SELECT MAX(date_load) FROM {{ this }} )

    {% endif %}
    ),

renamed_casted AS (
    SELECT
        event_id,
        page_url,
        user_id,
        session_id,
        is_delete,
        date_load
    FROM src_events
    )   

SELECT * FROM renamed_casted
