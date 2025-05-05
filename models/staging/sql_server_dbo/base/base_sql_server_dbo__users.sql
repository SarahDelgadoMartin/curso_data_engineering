{{
  config(
    materialized='view'
  )
}}

WITH src_promos AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'products') }}
    ),

renamed_casted AS (
    SELECT
        dbt_utils.generate_surrogate_key(product_id) AS product_id,
        CAST(price AS FLOAT(50)) AS price,
        CAST(name AS VARCHAR(256)) AS name,
        CAST(inventory AS INT) AS inventory,
        CAST(CONVERT_TIMEZONE('Europe/Madrid', 'UTC', _fivetran_deleted) AS DATE) AS date_delete,
        CAST(CONVERT_TIMEZONE('Europe/Madrid', 'UTC', _fivetran_synced) AS DATE) AS date_load
    FROM src_promos
    )   

SELECT * FROM renamed_casted
