{{
  config(
    materialized='view'
  )
}}

WITH src_events AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'events') }}
    ),

renamed_casted AS (
    SELECT
        generate_surrogate_key(['event_id']) AS event_id,
        


        CAST(_fivetran_deleted AS BOOLEAN) AS is_delete,
        CONVERT_TIMEZONE('UTC', CAST(_fivetran_synced AS TIMESTAMP_TZ)) AS date_load
    FROM src_events
    )   

SELECT * FROM renamed_casted
