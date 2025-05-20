{{
  config(
    materialized='incremental',
    unique_key='order_item_id',
    on_schema_change='append_new_columns'
  )
    }}

WITH base_order_items AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo__order_items') }}

    {% if is_incremental() %}

	WHERE date_load > (SELECT MAX(date_load) FROM {{ this }} )
    
    {% endif %}
    ),

base_product AS (
    SELECT 
        product_id,
        price
    FROM {{ ref('base_sql_server_dbo__products') }}
),

final AS (
    SELECT
        boi.order_item_id,
        boi.order_id,
        boi.product_id,
        boi.total_quantity,
        bp.price AS product_price,
        boi.is_deleted,
        boi.date_load
    FROM base_order_items boi
    INNER JOIN base_product bp
       ON boi.product_id = bp.product_id 
    )

SELECT * FROM final
