{{
  config(
    materialized='table'
  )
    }}

WITH orders_data AS (
    SELECT
        order_id,
        order_cost,
        promo_id,
        shipping_cost,
        order_total,
        is_deleted
    FROM {{ ref('stg_sql_server_dbo__orders') }}
)
    
SELECT * FROM orders_data 
