{{
  config(
    materialized='view'
  )
}}

WITH src_products AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'products') }}
    ),

renamed_casted AS (
    SELECT
        dbt_utils.generate_surrogate_key(product_id) AS product_id,
        CAST(CONVERT_TIMEZONE('Europe/Madrid', 'UTC', _fivetran_deleted) AS DATE) AS date_delete,
        CAST(CONVERT_TIMEZONE('Europe/Madrid', 'UTC', _fivetran_synced) AS DATE) AS date_load
    FROM src_products
    ),

new_row AS (
    
)    

SELECT * FROM renamed_casted UNION ALL new_row
