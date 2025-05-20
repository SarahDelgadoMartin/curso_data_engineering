-- Podrías descubrir que ciertos productos (por ejemplo, plant_group específicos) son más populares en zonas con alta densidad de población (quizás apartamentos pequeños) frente a zonas rurales. Esto puede guiar tus campañas de marketing segmentado y la oferta de productos por región
WITH product_sales_by_zip_group AS (
    SELECT
        da.zipcode,
        dp.plant_group,
        SUM(foi.total_quantity) AS total_quantity_sold
    FROM
        YOUR_SCHEMA.fct_order_items foi
    INNER JOIN
        YOUR_SCHEMA.dim_product dp ON foi.product_id = dp.product_id
    INNER JOIN
        YOUR_SCHEMA.dim_user du ON foi.user_id = du.user_id
    INNER JOIN
        YOUR_SCHEMA.dim_address da ON du.address_id = da.address_id
    GROUP BY
        da.zipcode,
        dp.plant_group
),
zipcode_info AS (
    SELECT
        zipcode,
        CAST(zipcode_population AS INT) AS population,
        -- Puedes categorizar zipcodes por densidad o población aquí, por ejemplo:
        CASE
            WHEN CAST(zipcode_population AS INT) >= 50000 THEN 'Alta Población'
            WHEN CAST(zipcode_population AS INT) >= 10000 THEN 'Media Población'
            ELSE 'Baja Población'
        END AS population_density_group
    FROM
        YOUR_SCHEMA.dim_address
    WHERE
        zipcode_population IS NOT NULL AND TRY_CAST(zipcode_population AS INT) IS NOT NULL
)
SELECT
    zi.population_density_group,
    ps.plant_group,
    SUM(ps.total_quantity_sold) AS total_group_quantity_sold,
    COUNT(DISTINCT ps.zipcode) AS distinct_zipcodes_in_group
FROM
    product_sales_by_zip_group ps
INNER JOIN
    zipcode_info zi ON ps.zipcode = zi.zipcode
GROUP BY
    zi.population_density_group,
    ps.plant_group
ORDER BY
    zi.population_density_group, total_group_quantity_sold DESC;