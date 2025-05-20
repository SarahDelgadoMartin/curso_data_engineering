-- Rendimiento de Promociones
WITH order_item_details AS (
    SELECT
        foi.order_id,
        foi.total_quantity,
        foi.product_price
    FROM
        YOUR_SCHEMA.fct_order_items foi
),
order_promo_details AS (
    SELECT
        dord.order_id,
        dord.promo_id,
        dord.shipping_cost,
        dord.order_total
    FROM
        YOUR_SCHEMA.dim_order dord
),
promo_info AS (
    SELECT
        dp.promo_id,
        dp.desc_promo,
        dp.is_active
    FROM
        YOUR_SCHEMA.dim_promo dp
),
joined_promo_data AS (
    SELECT
        oid.total_quantity,
        oid.product_price,
        opd.shipping_cost,
        opd.order_total,
        pi.desc_promo AS promotion_description,
        pi.is_active AS promotion_is_active
    FROM
        order_item_details oid
    INNER JOIN
        order_promo_details opd ON oid.order_id = opd.order_id
    LEFT JOIN
        promo_info pi ON opd.promo_id = pi.promo_id
)
SELECT
    promotion_description,
    promotion_is_active,
    SUM(total_quantity) AS total_quantity_sold_with_promo,
    SUM(total_quantity * product_price) AS gross_revenue_with_promo,
    AVG(product_price) AS average_product_price,
    shipping_cost,
    order_total
FROM
    joined_promo_data
GROUP BY
    promotion_description,
    promotion_is_active,
    shipping_cost,
    order_total
ORDER BY
    total_quantity_sold_with_promo DESC;