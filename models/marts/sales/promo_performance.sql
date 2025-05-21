-- Rendimiento de Promociones
WITH order_item_details AS (
    SELECT
        order_id,
        total_quantity,
        product_price
    FROM {{ ref('fct_order_items') }}
    ),

order_promo_details AS (
    SELECT
        order_id,
        promo_id,
        shipping_cost,
        order_total
    FROM {{ ref('dim_order') }}
    ),

promo_info AS (
    SELECT
        promo_id,
        desc_promo,
        is_active
    FROM {{ ref('dim_promo') }}
    WHERE desc_promo != 'no promo'
    ),

joined_promo_data AS (
    SELECT
        total_quantity,
        product_price,
        order_total,
        desc_promo AS promotion_description,
        is_active AS promotion_is_active
    FROM order_item_details oid
    INNER JOIN order_promo_details opd ON oid.order_id = opd.order_id
    RIGHT JOIN promo_info pi ON opd.promo_id = pi.promo_id
    )

SELECT
    promotion_description,
    promotion_is_active,
    SUM(total_quantity) AS total_quantity_sold_with_promo,
    SUM(total_quantity * product_price) AS gross_revenue_with_promo,
    ROUND(AVG(product_price), 2) AS average_product_price,
    order_total
FROM joined_promo_data
GROUP BY promotion_description, promotion_is_active, order_total
ORDER BY total_quantity_sold_with_promo DESC
