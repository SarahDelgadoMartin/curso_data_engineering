-- Impacto del Peso y Tamaño en el Tiempo de Entrega
--Pregunta: ¿Los productos más pesados o de mayor tamaño maduro (mature_size) tienden a tener tiempos de entrega más largos o mayores tasas de incidentes de envío?
-- Utilidad: Mejorar las expectativas de entrega al cliente, evaluar el rendimiento de los transportistas para ciertos tipos de productos y optimizar el embalaje.
WITH delivered_order_items AS (
    SELECT
        order_id,
        product_id,
        order_date,
        delivered_at_date,
    FROM {{ ref('fct_order_items') }}
    WHERE delivered_at_date != '9999-12-31'
    ),

product_characteristics AS (
    SELECT
        product_id,
        plant_group,
        product_weight_kg
    FROM {{ ref('dim_product') }}
    )

SELECT
    pc.plant_group,
    CASE
        WHEN product_weight_kg >= 4 THEN 'Muy pesado'
        WHEN product_weight_kg >= 1.5 THEN 'Medio pesado'
        ELSE 'Poco pesado'
    END AS product_weight_group,
    AVG(DATEDIFF('day', doi.order_date, doi.delivered_at_date)) AS average_delivery_days,
    COUNT(DISTINCT doi.order_id) AS total_orders
FROM delivered_order_items doi
INNER JOIN product_characteristics pc ON doi.product_id = pc.product_id
GROUP BY pc.plant_group, pc.product_weight_kg
ORDER BY average_delivery_days
