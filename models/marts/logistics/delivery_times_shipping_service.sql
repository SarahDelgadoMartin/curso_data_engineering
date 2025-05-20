-- Tiempos de Entrega por Servicio de Envío
WITH delivered_orders AS (
    SELECT
        order_id,
        order_date,
        delivered_at_date,
        order_timestamp,
        delivered_at_timestamp,
        shipping_service
    FROM
        YOUR_SCHEMA.fct_order_items
    WHERE
        delivered_at_date IS NOT NULL
)
SELECT
    shipping_service,
    AVG(DATEDIFF(day, order_date, delivered_at_date)) AS average_delivery_days,
    AVG(DATEDIFF(hour, order_timestamp, delivered_at_timestamp)) AS average_delivery_hours,
    COUNT(DISTINCT order_id) AS total_orders
FROM
    delivered_orders
GROUP BY
    shipping_service
ORDER BY
    average_delivery_days;