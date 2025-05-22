-- Popularidad por Tamaño Maduro (mature_size)
WITH order_item_details AS (
    SELECT
        product_id,
        total_quantity,
        product_price
    FROM {{ ref('fct_order_items') }}
    ),

product_info AS (
    SELECT
        product_id,
        mature_size
    FROM {{ ref('dim_product') }}
    )

SELECT
    pi.mature_size,
    COUNT(DISTINCT oid.product_id) AS distinct_products_offered,
    SUM(oid.total_quantity) AS total_quantity_sold,
    ROUND(SUM(oid.total_quantity * oid.product_price), 2) AS total_revenue
FROM order_item_details oid
INNER JOIN product_info pi ON oid.product_id = pi.product_id
GROUP BY pi.mature_size
ORDER BY total_quantity_sold DESC
