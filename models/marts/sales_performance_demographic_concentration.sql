--permite ver si tus ventas están alineadas con la densidad de población. ¿Vendes más en ciudades grandes o en áreas suburbanas específicas? Esto puede influir en la personalización de ofertas y la segmentación de audiencias para anuncios.
WITH sales_by_zipcode AS (
    SELECT
        da.zipcode,
        SUM(foi.total_quantity) AS total_products_sold,
        SUM(foi.total_quantity * foi.product_price) AS total_revenue
    FROM
        YOUR_SCHEMA.fct_order_items foi
    INNER JOIN
        YOUR_SCHEMA.dim_user du ON foi.user_id = du.user_id
    INNER JOIN
        YOUR_SCHEMA.dim_address da ON du.address_id = da.address_id
    GROUP BY
        da.zipcode
),
zipcode_population AS (
    SELECT
        zipcode,
        CAST(zipcode_population AS INT) AS population,
        CAST(zipcode_latitude AS FLOAT) AS latitude,
        CAST(zipcode_longitude AS FLOAT) AS longitude
    FROM
        YOUR_SCHEMA.dim_address
    WHERE
        zipcode_population IS NOT NULL AND TRY_CAST(zipcode_population AS INT) IS NOT NULL
)
SELECT
    sbz.zipcode,
    zp.population,
    zp.latitude,
    zp.longitude,
    sbz.total_products_sold,
    sbz.total_revenue,
    (CAST(sbz.total_products_sold AS FLOAT) / zp.population) AS products_per_capita,
    (sbz.total_revenue / zp.population) AS revenue_per_capita
FROM
    sales_by_zipcode sbz
INNER JOIN
    zipcode_population zp ON sbz.zipcode = zp.zipcode
WHERE
    zp.population > 0
ORDER BY
    revenue_per_capita DESC;