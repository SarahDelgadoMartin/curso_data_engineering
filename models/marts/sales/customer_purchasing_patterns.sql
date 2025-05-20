-- Patrones de Compra de Clientes
WITH user_purchase_data AS (
    SELECT
        foi.user_id,
        foi.order_id,
        foi.total_quantity,
        foi.product_price
    FROM
        YOUR_SCHEMA.fct_order_items foi
),
user_info AS (
    SELECT
        user_id,
        first_name,
        last_name,
        last_purchase_date,
        has_purchased
    FROM
        YOUR_SCHEMA.dim_user
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