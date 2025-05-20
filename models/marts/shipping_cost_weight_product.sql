-- Costos de Envío y Viabilidad por Peso
-- Pregunta: ¿Qué productos o grupos de plantas (plant_group) tienen los mayores costos de envío debido a su peso? ¿Podríamos ajustar los precios de venta o las políticas de envío para productos muy pesados?
-- Utilidad: Identificar oportunidades para optimizar los costos de envío, negociar con transportistas o establecer tarifas de envío diferenciadas.
WITH order_product_shipping_data AS (
    SELECT
        foi.product_id,
        foi.total_quantity,
        foi.shipping_cost,
        foi.order_id -- Necesario para COUNT DISTINCT de órdenes
    FROM
        YOUR_SCHEMA.fct_order_items foi
),
product_weight_info AS (
    SELECT
        product_id,
        name AS product_name,
        plant_group,
        weight
    FROM
        YOUR_SCHEMA.dim_product
)
SELECT
    pwi.product_name,
    pwi.plant_group,
    pwi.weight AS product_weight,
    SUM(opsd.total_quantity) AS total_quantity_sold,
    SUM(opsd.shipping_cost) AS total_shipping_cost_for_product,
    -- Nota: Asumiendo que shipping_cost es para el ítem o puede ser prorrateado si es por pedido.
    -- La lógica puede necesitar ajuste si shipping_cost es el costo total del pedido.
    AVG(opsd.shipping_cost / opsd.total_quantity) AS avg_shipping_cost_per_item
FROM
    order_product_shipping_data opsd
INNER JOIN
    product_weight_info pwi ON opsd.product_id = pwi.product_id
GROUP BY
    pwi.product_name,
    pwi.plant_group,
    pwi.weight
ORDER BY
    total_shipping_cost_for_product DESC;