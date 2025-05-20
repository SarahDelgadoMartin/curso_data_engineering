-- Análisis de Clientes por Ubicación
WITH user_location_data AS (
    SELECT
        du.user_id,
        du.address_id
    FROM
        YOUR_SCHEMA.dim_user du
),
address_details AS (
    SELECT
        address_id,
        country,
        state,
        city
    FROM
        YOUR_SCHEMA.dim_address
),
order_item_sales AS (
    SELECT
        foi.user_id,
        foi.order_id,
        foi.total_quantity,
        foi.product_price
    FROM
        YOUR_SCHEMA.fct_order_items foi
)
SELECT
    ad.country,
    ad.state,
    ad.city,
    COUNT(DISTINCT uld.user_id) AS total_customers,
    COUNT(DISTINCT ois.order_id) AS total_orders_from_location,
    AVG(ois.total_quantity * ois.product_price) AS average_order_value_from_location
FROM
    user_location_data uld
INNER JOIN
    address_details ad ON uld.address_id = ad.address_id
LEFT JOIN
    order_item_sales ois ON uld.user_id = ois.user_id
GROUP BY
    ad.country,
    ad.state,
    ad.city
ORDER BY
    total_customers DESC, average_order_value_from_location DESC;