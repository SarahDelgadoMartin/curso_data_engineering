-- Patrones de Compra de Clientes !! SIN TERMINAR !!
{{
  config(
    enabled=false
  )
    }}

WITH user_purchase_data AS (
    SELECT
        user_id,
        order_id,
        total_quantity,
        product_price
    FROM {{ ref('fct_order_items') }}
    ),

user_info AS (
    SELECT
        user_id,
        first_name,
        last_name,
        last_purchase_date,
        has_purchased
    FROM {{ ref('dim_user') }}
    )

SELECT
    ui.user_id,
    ui.first_name,
    ui.last_name,
    COUNT(DISTINCT upd.order_id) AS total_orders,
    SUM(upd.total_quantity) AS total_products_purchased,
    SUM(upd.total_quantity * upd.product_price) AS total_spent,
    ui.last_purchase_date,
    ui.has_purchased
FROM
    user_info ui
LEFT JOIN
    user_purchase_data upd ON ui.user_id = upd.user_id
GROUP BY
    ui.user_id,
    ui.first_name,
    ui.last_name,
    ui.last_purchase_date,
    ui.has_purchased
ORDER BY
    total_spent DESC;