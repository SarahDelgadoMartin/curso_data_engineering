{{
  config(
    materialized='view'
  )
    }}

WITH base_addresses AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo__addresses') }}
    ),

renamed_casted AS (
    SELECT
        address_id,
        street,
        number,
        CAST({{ dbt_utils.generate_surrogate_key(['zipcode']) }} AS VARCHAR) AS zipcode_id,
        state,
        country,
        is_deleted,
        date_load
    FROM base_addresses
    )

SELECT * FROM renamed_casted
