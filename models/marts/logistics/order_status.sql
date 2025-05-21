-- Estado de los Pedidos
{{
  config(
    materialized='table'
  )
    }}

WITH order_status_data AS (
    SELECT
        order_id,
        actual_status
    FROM {{ ref('fct_order_items') }} 
    )

SELECT
    actual_status,
    COUNT(DISTINCT order_id) AS number_of_orders
FROM order_status_data
GROUP BY actual_status
ORDER BY number_of_orders DESC
