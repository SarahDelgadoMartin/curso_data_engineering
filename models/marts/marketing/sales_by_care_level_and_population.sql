-- Análisis de Clientes por Nivel de Cuidado y Ubicación Geográfica
WITH user_purchase_dates AS (
    SELECT
        user_id,
        MIN(order_date) AS first_purchase_date
    FROM {{ ref('fct_order_items') }}
    GROUP BY user_id
    ),

user_last_purchase AS (
    SELECT
        user_id,
        last_purchase_date
    FROM {{ ref('dim_user') }}
    WHERE has_purchased != FALSE
    ),

order_user_product_details AS (
    SELECT
        user_id,
        product_id,
        total_quantity,
        product_price
    FROM {{ ref('fct_order_items') }}
    ),

product_care_level AS (
    SELECT
        product_id,
        care_level
    FROM {{ ref('dim_product') }}
    ),

user_location_details AS (
    SELECT
        du.user_id,
        ad.city,
        ad.state
    FROM {{ ref('dim_user') }} du
    INNER JOIN {{ ref('dim_address') }} ad ON du.address_id = ad.address_id
    )

SELECT
    pcl.care_level,
    uld.city,
    uld.state,
    COUNT(DISTINCT oupd.user_id) AS total_customers,
    SUM(oupd.total_quantity * oupd.product_price) AS total_sales_value,
    ROUND(AVG(DATEDIFF(day, upd.first_purchase_date, ulp.last_purchase_date)), 2) AS avg_days_between_purchases
FROM order_user_product_details oupd
INNER JOIN product_care_level pcl ON oupd.product_id = pcl.product_id
INNER JOIN user_purchase_dates upd ON oupd.user_id = upd.user_id
INNER JOIN user_location_details uld ON oupd.user_id = uld.user_id
INNER JOIN user_last_purchase ulp ON oupd.user_id = ulp.user_id
GROUP BY pcl.care_level, uld.city, uld.state
ORDER BY pcl.care_level, total_sales_value DESC
