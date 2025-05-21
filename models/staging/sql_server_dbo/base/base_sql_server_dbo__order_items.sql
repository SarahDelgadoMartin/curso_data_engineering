{{
  config(
    materialized='incremental',
    unique_key='order_item_id',
    on_schema_change='fail'
  )
    }}

WITH src_order_items AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'order_items') }}

    {% if is_incremental() %}

	WHERE _fivetran_synced > (SELECT MAX(date_load) FROM {{ this }} )
    
    {% endif %}
    ),

renamed_casted AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['order_id', 'product_id']) }} AS order_item_id,
        {{ dbt_utils.generate_surrogate_key(['order_id']) }} AS order_id,
        {{ dbt_utils.generate_surrogate_key(['product_id']) }} AS product_id,
        CAST(quantity AS INT) AS total_quantity,
        CAST(IFNULL(_fivetran_deleted, FALSE) AS BOOLEAN) AS is_deleted,
        CONVERT_TIMEZONE('UTC', CAST(_fivetran_synced AS TIMESTAMP_TZ)) AS date_load
    FROM src_order_items
    )

SELECT * FROM renamed_casted