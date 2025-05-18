{{
  config(
    materialized='table'
  )
    }}

WITH order_items_data AS (
    SELECT
        *
    FROM {{ ref('stg_sql_server_dbo__order_items') }}
    ),

orders_data AS (
    SELECT
        *
    FROM {{ ref('stg_sql_server_dbo__orders') }}
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
        o.estimated_delivery_at_date,
        o.estimated_delivery_at_time,
        o.delivered_at_date,
        o.delivered_at_time,
        o.shipping_service,
        o.tracking_id,
        oi.is_deleted
    FROM order_items_data oi
    INNER JOIN orders_data o ON oi.order_id = o.order_id
    )

SELECT * FROM final
