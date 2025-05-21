-- Análisis de Clientes por Ciudad
{{
  config(
    materialized='table'
  )
    }}

WITH user_location_data AS (
    SELECT
        user_id,
        address_id
    FROM {{ ref('dim_user') }}
    ),

address_details AS (
    SELECT
        address_id,
        country,
        state,
        city
    FROM {{ ref('dim_address') }}
    ),

order_item_sales AS (
    SELECT
        user_id,
        order_id,
        total_quantity,
        product_price
    FROM {{ ref('fct_order_items') }}
    )

SELECT
    ad.country,
    ad.state,
    ad.city,
    COUNT(DISTINCT uld.user_id) AS total_customers,
    COUNT(DISTINCT ois.order_id) AS total_orders_from_city
    ROUND(AVG(ois.total_quantity * ois.product_price), 2) AS average_order_value_from_city
FROM user_location_data uld
INNER JOIN address_details ad ON uld.address_id = ad.address_id
LEFT JOIN order_item_sales ois ON uld.user_id = ois.user_id
GROUP BY ad.country, ad.state, ad.city
ORDER BY total_customers DESC, average_order_value_from_location DESC
