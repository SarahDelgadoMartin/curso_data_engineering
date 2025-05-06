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
        {{ dbt_utils.generate_surrogate_key(['product_id']) }} AS product_id,
        CAST(price AS FLOAT) AS price,
        CAST(name AS VARCHAR(256)) AS name,
        CAST(inventory AS INT) AS inventory,
        CAST(_fivetran_deleted AS BOOLEAN) AS is_delete,
        CONVERT_TIMEZONE('UTC', CAST(_fivetran_synced AS TIMESTAMP_TZ)) AS date_load
    FROM src_products
    ),

new_row AS (
    SELECT
       {{ dbt.hash(["no product"]) }} AS product_id,
       0.0 AS price,
       'no product' AS name,
       0 AS inventory,
       NULL AS date_delete,
       CONVERT_TIMEZONE('UTC', CURRENT_TIMESTAMP()) AS date_load
)    

SELECT * FROM renamed_casted
UNION ALL
SELECT * FROM new_row
