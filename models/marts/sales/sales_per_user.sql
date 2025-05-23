-- !! SIN TERMINAR !!
{{
  config(
    enabled=false
  )
    }}

WITH fct_order_items AS (
    SELECT
        order_item_id,
        order_id,
        product_id,
        total_quantity,
        product_price,
        user_id,
        address_id,
        order_date,
        order_time,
        order_timestamp,
        estimated_delivery_at_date,
        estimated_delivery_at_time,
        estimated_delivery_at_timestamp,
        delivered_at_date,
        delivered_at_time,
        delivered_at_timestamp
    FROM {{ ref('fct_order_items') }}
    ), 

dim_order AS (
    SELECT
        order_id,
        promo_id,
        shipping_cost,
        order_total,
        is_deleted
    FROM {{ ref('dim_order') }}
    ),

dim_promo AS (
    SELECT
        promo_id,
        discount_on_units
    FROM {{ ref('dim_promo') }}

    ),

dim_user AS (
    SELECT
        user_id,
        first_name,
        last_name,
        email,
        is_valid_email,
        phone_number,
        is_valid_us_phone,
        created_at_timestamp,
        updated_at_timestamp,
        address_id
    FROM {{ ref('dim_user') }}
    ),

dim_address AS (
    SELECT
        address_id,
        street,
        number,
        zipcode,
        state,
        country
    FROM {{ ref('dim_address') }}
    ),

user_discounts AS (
    SELECT
        foi.user_id,
        SUM(COALESCE(dp.discount_on_units, 0)) AS total_discount_usd
    FROM fct_order_items foi
    INNER JOIN dim_order dor ON foi.order_id = dor.order_id
    LEFT JOIN dim_promo dp ON dor.promo_id = dp.promo_id
    GROUP BY foi.user_id
    ),

user_orders AS (
    SELECT
        foi.user_id,
        COUNT(DISTINCT foi.order_id) AS total_numbers_orders,
        ROUND(SUM(dor.shipping_cost), 2) AS total_shipping_cost_usd,
        ROUND(SUM(dor.order_total), 2) AS total_order_cost,
        SUM(foi.total_quantity) AS total_quantity_products_buyed,
        COUNT(DISTINCT foi.product_id) AS total_different_products_buyed,
        ROUND(AVG(CASE
                    WHEN foi.estimated_delivery_at_date = '9999-12-31' THEN NULL
                    ELSE DATEDIFF('day', foi.order_date, foi.estimated_delivery_at_date)
                END), 2) AS avg_day_estimated_delivery,
        ROUND(AVG(CASE 
                    WHEN foi.delivered_at_date = '9999-12-31' THEN NULL
                    ELSE DATEDIFF('day', foi.order_date, foi.delivered_at_date)
                END), 2) AS avg_day_delivered_day,
    FROM fct_order_items foi
    INNER JOIN dim_order dor ON foi.order_id = dor.order_id
    GROUP BY foi.user_id
    )

SELECT
    du.user_id,
    du.first_name,
    du.last_name,
    du.email,
    du.is_valid_email,
    du.phone_number,
    du.is_valid_us_phone,
    du.created_at_timestamp,
    du.updated_at_timestamp,
    da.number || ' ' || da.street AS address,
    da.zipcode,
    da.state,
    da.country,
    uo.total_numbers_orders,
    uo.total_shipping_cost_usd,
    uo.total_order_cost,
    udis.total_discount_usd,
    uo.total_quantity_products_buyed,
    uo.total_different_products_buyed,
    uo.avg_day_estimated_delivery,
    uo.avg_day_delivered_day
FROM dim_user du
INNER JOIN user_orders uo ON du.user_id = uo.user_id
LEFT JOIN dim_address da ON du.address_id = da.address_id
LEFT JOIN user_discounts udis ON du.user_id = udis.user_id
