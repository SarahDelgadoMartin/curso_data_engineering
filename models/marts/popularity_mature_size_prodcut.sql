-- Popularidad por Tamaño Maduro (mature_size)
-- Pregunta: ¿Qué tamaños maduros son los más buscados o vendidos? ¿Los clientes de plantas pequeñas (mature size 'S') son recurrentes y se interesan por plantas más grandes con el tiempo?
-- Utilidad: Informar el desarrollo de nuevos productos, la estrategia de precios y la disposición del inventario.
WITH order_item_details AS (
    SELECT
        foi.product_id,
        foi.total_quantity,
        foi.product_price
    FROM
        YOUR_SCHEMA.fct_order_items foi
),
product_mature_size_info AS (
    SELECT
        product_id,
        mature_size
    FROM
        YOUR_SCHEMA.dim_product
)
SELECT
    pmsi.mature_size,
    COUNT(DISTINCT oid.product_id) AS distinct_products_offered,
    SUM(oid.total_quantity) AS total_quantity_sold,
    SUM(oid.total_quantity * oid.product_price) AS total_revenue
FROM
    order_item_details oid
INNER JOIN
    product_mature_size_info pmsi ON oid.product_id = pmsi.product_id
GROUP BY
    pmsi.mature_size
ORDER BY
    total_quantity_sold DESC;