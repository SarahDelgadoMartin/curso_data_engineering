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
        {{ dbt_utils.generate_surrogate_key(['order_id', 'product_id']) }} AS order_items_id,
        {{ dbt_utils.generate_surrogate_key(['order_id']) }} AS order_id,
        {{ dbt_utils.generate_surrogate_key(['product_id']) }} AS product_id,
        CAST(quantity AS INT) AS total_quantity,
        CAST(_fivetran_deleted AS BOOLEAN) AS is_delete,
        CONVERT_TIMEZONE('UTC', CAST(_fivetran_synced AS TIMESTAMP_TZ)) AS date_load
    FROM src_order_items
    )   

SELECT * FROM renamed_casted
