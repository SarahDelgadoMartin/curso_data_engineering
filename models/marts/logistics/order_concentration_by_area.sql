-- Concentración de Pedidos por Zona 
WITH order_details_zipcode AS (
    SELECT
        foi.order_id,
        da.zipcode,
        da.city,
        da.state,
        da.zipcode_population,
        da.zipcode_latitude,
        da.zipcode_longitude,
        foi.total_quantity,
        foi.product_price
    FROM {{ ref('fct_order_items') }} foi
    INNER JOIN {{ ref('dim_address') }} da ON foi.address_id = da.address_id
    )

SELECT
    zipcode,
    city,
    state,
    zipcode_population,
    zipcode_latitude,
    zipcode_longitude,
    COUNT(DISTINCT order_id) AS orders_in_zipcode,
    ROUND(SUM(total_quantity * product_price)) AS revenue_in_zipcode
FROM order_details_zipcode
GROUP BY zipcode, city, state, zipcode_population, zipcode_latitude, zipcode_longitude
ORDER BY orders_in_zipcode DESC, revenue_in_zipcode DESC
