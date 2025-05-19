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
        CAST(REPLACE(REPLACE(price, ',', '.'), ' ', '') AS FLOAT) AS price,
        CAST(name AS VARCHAR) AS name,
        CAST(inventory AS INT) AS inventory,
        CAST(IFNULL(_fivetran_deleted, FALSE) AS BOOLEAN) AS is_deleted,
        CONVERT_TIMEZONE('UTC', CAST(_fivetran_synced AS TIMESTAMP_TZ)) AS date_load
    FROM src_products
    )

SELECT * FROM renamed_casted
