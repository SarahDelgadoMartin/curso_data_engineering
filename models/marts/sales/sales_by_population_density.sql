-- Ventas por densidad de población.
WITH sales_by_zipcode AS (
    SELECT
        da.zipcode,
        SUM(foi.total_quantity) AS total_products_sold,
        SUM(foi.total_quantity * foi.product_price) AS total_revenue
    FROM {{ ref('fct_order_items') }} foi
    INNER JOIN {{ ref('dim_address') }} da ON foi.address_id = da.address_id
    GROUP BY da.zipcode
    ),

zipcode_population AS (
    SELECT
        zipcode,
        zipcode_population AS population,
        zipcode_latitude AS latitude,
        zipcode_longitude AS longitude
    FROM {{ ref('dim_address') }}
    )

SELECT
    sbz.zipcode,
    zp.population,
    zp.latitude,
    zp.longitude,
    sbz.total_products_sold,
    sbz.total_revenue,
    ROUND(sbz.total_products_sold / zp.population, 2) AS products_per_capita,
    ROUND(sbz.total_revenue / zp.population, 2) AS revenue_per_capita
FROM sales_by_zipcode sbz
INNER JOIN zipcode_population zp ON sbz.zipcode = zp.zipcode
WHERE zp.population > 0
ORDER BY revenue_per_capita DESC
