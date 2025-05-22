-- Popularidad de tamaño de plantas por cantidad población
-- Analizar si en las zonas menos pobladas los clientes tienen más espacio para plantas más grandes y viceversa
WITH product_sales_by_zip_group AS (
    SELECT
        da.zipcode,
        dp.mature_size,
        SUM(foi.total_quantity) AS total_quantity_sold
    FROM {{ ref('fct_order_items') }} foi
    INNER JOIN {{ ref('dim_product') }} dp ON foi.product_id = dp.product_id
    INNER JOIN {{ ref('dim_address') }} da ON foi.address_id = da.address_id
    GROUP BY da.zipcode, dp.mature_size
    ),

zipcode_info AS (
    SELECT
        zipcode,
        zipcode_population AS population,
        CASE
            WHEN zipcode_population >= 20000 THEN 'Población Alta '
            WHEN zipcode_population >= 5000 THEN 'Población Media '
            ELSE 'Población Baja '
        END AS population_density_group
    FROM {{ ref('dim_address') }}
    )

SELECT
    zi.population_density_group,
    ps.mature_size,   
    SUM(ps.total_quantity_sold) AS total_group_quantity_sold,
    COUNT(DISTINCT ps.zipcode) AS distinct_zipcodes_in_group
FROM product_sales_by_zip_group ps
INNER JOIN zipcode_info zi ON ps.zipcode = zi.zipcode
GROUP BY zi.population_density_group,  ps.mature_size
ORDER BY zi.population_density_group DESC
