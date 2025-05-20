-- Ventas por Producto y Tiempo (Mensual, Trimestral, Anual)
WITH product_sales AS (
    SELECT
        foi.product_id,
        foi.total_quantity,
        foi.product_price,
        foi.order_date
    FROM
        YOUR_SCHEMA.fct_order_items foi
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
    FROM
        product_sales ps
    INNER JOIN
        YOUR_SCHEMA.dim_product dd ON ps.product_id = dd.product_id
    INNER JOIN
        YOUR_SCHEMA.dim_date dd ON ps.order_date = dd.date_day
)
SELECT
    product_name,
    plant_group,
    sale_year,
    sale_month,
    sale_quarter,
    SUM(total_quantity) AS total_quantity_sold,
    SUM(total_quantity * product_price) AS total_revenue
FROM
    joined_data
GROUP BY
    product_name,
    plant_group,
    sale_year,
    sale_month,
    sale_quarter
ORDER BY
    product_name,
    sale_year,
    sale_month;