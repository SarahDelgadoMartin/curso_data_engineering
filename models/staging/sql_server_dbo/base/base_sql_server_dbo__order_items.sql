{{
  config(
    materialized='view'
  )
}}

WITH src_order_items AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'order_items') }}
    ),

renamed_casted AS (
    SELECT
        dbt_utils.generate_surrogate_key(['order_id', 'product_id') AS order_items_id,
        CAST(price AS FLOAT) AS price,
        CAST(name AS VARCHAR(256)) AS name,
        CAST(inventory AS INT) AS inventory,
        CAST(CONVERT_TIMEZONE('Europe/Madrid', 'UTC', _fivetran_deleted) AS DATE) AS date_delete,
        CAST(CONVERT_TIMEZONE('Europe/Madrid', 'UTC', _fivetran_synced) AS DATE) AS date_load
    FROM src_order_items
    )   

SELECT * FROM renamed_casted
