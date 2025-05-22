-- Relación Inventario-Ventas !! SIN TERMINAR !!
{{
  config(
    enabled=false
  )
    }}
    
WITH monthly_product_sales AS (
    SELECT
        foi.product_id,
        dd.year_number AS sales_year,
        dd.month_of_year AS sales_month,
        SUM(foi.total_quantity) AS monthly_quantity_sold
    FROM {{ ref('fct_order_items') }} foi
    INNER JOIN {{ ref('dim_date') }} dd ON foi.order_date = dd.date_day
    GROUP BY foi.product_id, sales_year, sales_month
    ),

historical_monthly_inventory AS (
    SELECT
        product_id,
        YEAR(dbt_update_at) AS inventory_year,
        MONTH(dbt_update_at) AS inventory_month,
        AVG(inventory) AS average_monthly_inventory
    FROM {{ ref('products_inventory_daily_snp') }}
    GROUP BY product_id, inventory_year, inventory_month
    ),

product_details AS (
    SELECT
        product_id,
        product_name
    FROM {{ ref('dim_product') }}
    )

SELECT
    pd.product_name,
    mps.sales_year,
    mps.sales_month,
    COALESCE(hmi.average_monthly_inventory, 0) AS monthly_inventory_at_sales_time,
    mps.monthly_quantity_sold
FROM monthly_product_sales mps
INNER JOIN product_details pd ON mps.product_id = pd.product_id
LEFT JOIN historical_monthly_inventory hmi ON mps.product_id = hmi.product_id
    AND mps.sales_year = hmi.inventory_year
    AND mps.sales_month = hmi.inventory_month
ORDER BY pd.product_name, mps.sales_year, mps.sales_month