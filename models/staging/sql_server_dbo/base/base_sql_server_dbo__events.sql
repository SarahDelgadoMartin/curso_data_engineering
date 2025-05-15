{{
  config(
    materialized='incremental',
    unique_key='event_id',
    on_schema_change='append_new_columns'
  )
    }}

WITH src_events AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'events') }}

{% if is_incremental() %}

	WHERE _fivetran_synced > (SELECT MAX(date_load) FROM {{ this }} )

{% endif %}
    ),

renamed_casted AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['event_id']) }} AS event_id,
        CAST(page_url AS VARCHAR) AS page_url,
        CAST(event_type AS VARCHAR) AS event_type,
        {{ dbt_utils.generate_surrogate_key(['user_id']) }} AS user_id,
        CASE 
            WHEN product_id != '' THEN {{ dbt_utils.generate_surrogate_key(['product_id']) }} 
        END AS product_id,
        {{ dbt_utils.generate_surrogate_key(['session_id']) }} AS session_id,
        CONVERT_TIMEZONE(
            'UTC',
            CAST(IFNULL(
                    created_at,
                    CAST('9999-12-31 23:59:59' AS TIMESTAMP_TZ)
                    ) AS TIMESTAMP_TZ
                )
            ) AS created_at,
        CASE 
            WHEN order_id != '' THEN {{ dbt_utils.generate_surrogate_key(['order_id']) }}
        END AS order_id,
        CAST(IFNULL(_fivetran_deleted, FALSE) AS BOOLEAN) AS is_delete,
        CONVERT_TIMEZONE('UTC', CAST(_fivetran_synced AS TIMESTAMP_TZ)) AS date_load
    FROM src_events
    )   

SELECT * FROM renamed_casted
