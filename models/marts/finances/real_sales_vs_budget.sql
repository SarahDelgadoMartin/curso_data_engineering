-- Comparación de Ventas Reales Mensuales por Producto vs Objetivo Mensual por Producto
{{
  config(
    materialized='table'
  )
    }}

WITH budget_and_sales AS (
    SELECT
        product_id,
        year AS budget_year,
        month AS budget_month,
        target_quantity,
        total_quantity_sold AS actual_quantity_sold
    FROM {{ ref('fct_budget') }}
    ),

product_names AS (
    SELECT
        product_id,
        name AS product_name
    FROM {{ ref('dim_product') }}
    )

SELECT
    pn.product_name,
    bas.budget_year,
    bas.budget_month,
    bas.target_quantity,
    bas.actual_quantity_sold,
    ROUND(COALESCE(
            ((CAST(bas.actual_quantity_sold AS FLOAT) - bas.target_quantity) / bas.target_quantity) * 100,
            0
    ), 2) AS percentage_deviation
FROM budget_and_sales bas
INNER JOIN product_names pn ON bas.product_id = pn.product_id
ORDER BY pn.product_name, bas.budget_year, bas.budget_month