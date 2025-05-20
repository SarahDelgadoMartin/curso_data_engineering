-- Demanda y Rentabilidad por Grupo de Plantas
-- Pregunta: ¿Qué grupos de plantas son los más populares o los que generan mayores ingresos? ¿Hay grupos que, a pesar de su bajo volumen de ventas, tienen un alto margen de beneficio?
-- Utilidad: Identificar los productos estrella o los que necesitan más promoción. Ajustar el inventario y las campañas de marketing para enfocarse en los grupos más rentables o de mayor demanda.
WITH order_item_details AS (
    SELECT
        foi.product_id,
        foi.total_quantity,
        foi.product_price
    FROM
        YOUR_SCHEMA.fct_order_items foi
),
product_group_info AS (
    SELECT
        product_id,
        plant_group
    FROM
        YOUR_SCHEMA.dim_product
)
SELECT
    pgi.plant_group,
    SUM(oid.total_quantity) AS total_quantity_sold,
    SUM(oid.total_quantity * oid.product_price) AS total_revenue,
    COUNT(DISTINCT oid.product_id) AS distinct_products_sold_in_group
FROM
    order_item_details oid
INNER JOIN
    product_group_info pgi ON oid.product_id = pgi.product_id
GROUP BY
    pgi.plant_group
ORDER BY
    total_revenue DESC;