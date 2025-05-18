{{
  config(
    materialized='table'
  )
    }}

WITH budget_data AS (
    SELECT
        budget_id,
        product_id,
        month,
        year,
        date,
        target_quantity
    FROM
        {{ ref('stg_google_sheets__budget') }}
    ),

order_data AS (
    SELECT
        order_id,
        created_at_date
    FROM {{ ref('stg_sql_server_dbo__orders') }}
    ),

order_item_data AS (
    SELECT
        order_id,
        product_id,
        total_quantity
    FROM {{ ref('stg_sql_server_dbo__order_items') }}
    ),

dates AS (
    SELECT 
        date_day,
        month_of_year,
        year_number
    FROM ALUMNO30_DEV_SILVER_DB.OWN_DATA.STG_OWN_DATA__DATES
    ),

monthly_sales AS (
    SELECT
        d.month_of_year AS sale_month,
        d.year_number AS sale_year,
        oi.product_id,
        SUM(oi.total_quantity) AS total_quantity_sold
    FROM order_data o
    JOIN order_item_data oi ON o.order_id = oi.order_id
    JOIN dates d ON o.created_at_date = d.date_day
    GROUP BY sale_month, sale_year, product_id
    )

SELECT
    bd.budget_id,
    bd.product_id,
    bd.month,
    bd.year,
    bd.date,
    bd.target_quantity,
    ms.total_quantity_sold,
FROM budget_data bd
LEFT JOIN monthly_sales ms
    ON ms.product_id = bd.product_id
    AND ms.sale_month = bd.month
    AND ms.sale_year = bd.year
ORDER BY bd.product_id, bd.date