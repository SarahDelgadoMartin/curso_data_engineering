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
        *
    FROM base_addresses
    WHERE address_id IN (SELECT address_id
                               FROM {{ ref('base_sql_server_dbo__orders') }})
    )   

SELECT * FROM renamed_casted