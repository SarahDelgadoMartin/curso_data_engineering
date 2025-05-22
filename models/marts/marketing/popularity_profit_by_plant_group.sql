-- Popularidad y ganancia por Grupo de Plantas
WITH order_item_details AS (
    SELECT
        product_id,
        total_quantity,
        product_price
    FROM {{ ref('fct_order_items') }}
    ),
    
product_group_info AS (
    SELECT
        product_id,
        plant_group
    FROM {{ ref('dim_product') }}
    )

SELECT
    pgi.plant_group,
    SUM(oid.total_quantity) AS total_quantity_sold,
    SUM(oid.total_quantity * oid.product_price) AS total_revenue,
    COUNT(DISTINCT oid.product_id) AS distinct_products_sold_in_group
FROM order_item_details oid
INNER JOIN product_group_info pgi ON oid.product_id = pgi.product_id
GROUP BY pgi.plant_group
ORDER BY total_revenue DESC
