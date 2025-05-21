-- Popularidad de tipos productos por cantidad población
-- Supones que en las zonas menos pobladas los clientes tienen más espacio para 
WITH product_sales_by_zip_group AS (
    SELECT
        da.zipcode,
        dp.plant_group,
        dp.mature_size,
        SUM(foi.total_quantity) AS total_quantity_sold
    FROM {{ ref('fct_order_items') }} foi
    INNER JOIN {{ ref('dim_product') }} dp ON foi.product_id = dp.product_id
    INNER JOIN {{ ref('dim_user') }} du ON foi.user_id = du.user_id
    INNER JOIN {{ ref('dim_address') }} da ON du.address_id = da.address_id
    GROUP BY da.zipcode, dp.plant_group, dp.mature_size
    ),

zipcode_info AS (
    SELECT
        zipcode,
        zipcode_population AS population,
        CASE
            WHEN zipcode_population >= 20000 THEN 'Alta Población'
            WHEN zipcode_population >= 5000 THEN 'Media Población'
            ELSE 'Baja Población'
        END AS population_density_group
    FROM {{ ref('dim_address') }}
    )

SELECT
    ps.plant_group,
    ps.mature_size,
    zi.population_density_group,
    SUM(ps.total_quantity_sold) AS total_group_quantity_sold,
    COUNT(DISTINCT ps.zipcode) AS distinct_zipcodes_in_group
FROM product_sales_by_zip_group ps
INNER JOIN zipcode_info zi ON ps.zipcode = zi.zipcode
GROUP BY zi.population_density_group, ps.plant_group
ORDER BY ps.plant_group, zi.population_density_group DESC
