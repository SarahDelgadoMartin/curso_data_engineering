{{
  config(
    materialized='incremental',
    unique_key='order_item_id',
    on_schema_change='append_new_columns'
  )
    }}

WITH order_items_data AS (
    SELECT *
    FROM {{ ref('stg_sql_server_dbo__order_items') }}

    {% if is_incremental() %}

	WHERE date_load > (SELECT MAX(date_load) FROM {{ this }} )
    
    {% endif %}
    ),

orders_data AS (
    SELECT *
    FROM {{ ref('stg_sql_server_dbo__orders') }}

    {% if is_incremental() %}

	WHERE date_load > (SELECT MAX(date_load) FROM {{ this }} )
    
    {% endif %}
    ),

final AS (
    SELECT
        oi.order_item_id,
        oi.order_id,
        oi.product_id,
        oi.total_quantity,
        oi.product_price,
        o.user_id,
        o.address_id,
        o.status AS actual_status,
        o.created_at_date AS order_date,
        o.created_at_time AS order_time,
        o.created_at_timestamp AS order_timestamp,
        o.estimated_delivery_at_date,
        o.estimated_delivery_at_time,
        o.estimated_delivery_at_timestamp,
        o.delivered_at_date,
        o.delivered_at_time,
        o.delivered_at_timestamp,
        o.shipping_service,
        o.tracking_id,
        oi.is_deleted,
        date_load
    FROM order_items_data oi
    INNER JOIN orders_data o ON oi.order_id = o.order_id
    )

SELECT * FROM final
