-- Ventas por Producto y Tiempo (Mensual, Trimestral, Anual) !! SIN TERMINAR !!
{{
  config(
    enabled=false
  )
    }}

WITH product_sales AS (
    SELECT
        product_id,
        total_quantity,
        product_price,
        order_date
    FROM {{ ref('fct_order_items') }}
    ),

joined_data AS (
    SELECT
        ps.product_id,
        ps.total_quantity,
        ps.product_price,
        dd.name AS product_name,
        dd.plant_group,
        dd.year_number AS sale_year,
        dd.month_of_year AS sale_month,
        dd.quarter_of_year AS sale_quarter
    FROM product_sales ps
    INNER JOIN {{ ref('dim_product') }} dd ON ps.product_id = dd.product_id
    INNER JOIN {{ ref('dim_date') }} dd ON ps.order_date = dd.date_day
    )

SELECT
    product_name,
    plant_group,
    sale_year,
    sale_month,
    sale_quarter,
    SUM(total_quantity) AS total_quantity_sold,
    SUM(total_quantity * product_price) AS total_revenue
FROM joined_data
GROUP BY product_name, plant_group, sale_year, sale_month, sale_quarter
ORDER BY product_name, sale_year, sale_month
