-- Relación Inventario-Ventas
WITH monthly_product_sales AS (
    SELECT
        foi.product_id,
        dd.year_number AS sales_year,
        dd.month_of_year AS sales_month,
        SUM(foi.total_quantity) AS monthly_quantity_sold
    FROM
        YOUR_SCHEMA.fct_order_items foi
    INNER JOIN
        YOUR_SCHEMA.dim_date dd ON foi.order_date = dd.date_day
    GROUP BY
        foi.product_id,
        sales_year,
        sales_month
),
product_details AS (
    SELECT
        product_id,
        name AS product_name,
        inventory AS current_inventory -- Asumiendo que esta es la columna de inventario actual en dim_product
    FROM
        YOUR_SCHEMA.dim_product
)
SELECT
    pd.product_name,
    mps.sales_year,
    mps.sales_month,
    pd.current_inventory,
    mps.monthly_quantity_sold
FROM
    monthly_product_sales mps
INNER JOIN
    product_details pd ON mps.product_id = pd.product_id
ORDER BY
    pd.product_name,
    mps.sales_year,
    mps.sales_month;