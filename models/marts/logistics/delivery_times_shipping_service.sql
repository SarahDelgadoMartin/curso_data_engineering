-- Tiempos de Entrega por Servicio de Envío
{{
  config(
    materialized='table'
  )
    }}
    
WITH delivered_orders AS (
    SELECT
        DISTINCT order_id,
        order_date,
        delivered_at_date,
        order_timestamp,
        delivered_at_timestamp,
        shipping_service
    FROM {{ ref('fct_order_items') }}
    WHERE delivered_at_date != '9999-12-31'
    )

SELECT
    shipping_service,
    ROUND(AVG(DATEDIFF('day', order_date, delivered_at_date)), 2) AS average_delivery_days,
    ROUND(AVG(DATEDIFF('hour', order_timestamp, delivered_at_timestamp)), 2) AS average_delivery_hours,
    COUNT(order_id) AS total_orders
FROM delivered_orders
GROUP BY shipping_service
ORDER BY average_delivery_days
