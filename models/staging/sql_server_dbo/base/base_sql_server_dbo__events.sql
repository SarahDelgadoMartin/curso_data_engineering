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
        generate_surrogate_key(['address_id']) AS address_id,
        CAST(STRING_SPLIT(address, " ", 2) AS VARCHAR(256)) AS street,
        CAST(STRING_SPLIT(address, " ", 1) AS INT) AS number,
        CAST(zipcode AS INT) AS zipcode,
        CAST(state AS VARCHAR(256)) AS state,
        CAST(country AS VARCHAR(256)) AS country,
        CAST(CONVERT_TIMEZONE('Europe/Madrid', 'UTC', _fivetran_deleted) AS DATE) AS date_delete,
        CAST(CONVERT_TIMEZONE('Europe/Madrid', 'UTC', _fivetran_synced) AS DATE) AS date_load
    FROM src_events
    )   

SELECT * FROM renamed_casted
