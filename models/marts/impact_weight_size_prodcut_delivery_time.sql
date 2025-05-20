--Impacto del Peso y Tamaño en el Tiempo de Entrega
--Pregunta: ¿Los productos más pesados o de mayor tamaño maduro (mature_size) tienden a tener tiempos de entrega más largos o mayores tasas de incidentes de envío?
-- Utilidad: Mejorar las expectativas de entrega al cliente, evaluar el rendimiento de los transportistas para ciertos tipos de productos y optimizar el embalaje.
WITH delivered_order_items AS (
    SELECT
        foi.product_id,
        foi.order_date,
        foi.delivered_at_date,
        foi.order_id -- para contar órdenes
    FROM
        YOUR_SCHEMA.fct_order_items foi
    WHERE
        foi.delivered_at_date IS NOT NULL
),
product_characteristics AS (
    SELECT
        product_id,
        plant_group,
        mature_size,
        weight
    FROM
        YOUR_SCHEMA.dim_product
)
SELECT
    pc.plant_group,
    pc.mature_size,
    pc.weight,
    AVG(DATEDIFF(day, doi.order_date, doi.delivered_at_date)) AS average_delivery_days,
    COUNT(DISTINCT doi.order_id) AS total_orders
FROM
    delivered_order_items doi
INNER JOIN
    product_characteristics pc ON doi.product_id = pc.product_id
GROUP BY
    pc.plant_group,
    pc.mature_size,
    pc.weight
ORDER BY
    average_delivery_days DESC;
