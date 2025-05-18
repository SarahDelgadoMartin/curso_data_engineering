-- models/fact_sales.sql

{{
    config(
        materialized='table',
        indexes=[
            {'columns': ['sale_id']}
        ]
    )
}}

WITH sales_data AS (
    SELECT
        sale_id,
        sale_date,
        product_id,
        quantity,
        unit_price,
        customer_id
    FROM
        {{ ref('fct_events') }}
),

-- Añadir la tabla de dimensiones para el tiempo
dimension_time AS (
    SELECT
        sale_date,
        date_trunc('month', sale_date) AS month_start,
        date_trunc('year', sale_date) AS year_start
    FROM
        {{ ref('dim_date') }}
),

-- Añadir la tabla de dimensiones para los productos
dimension_products AS (
    SELECT
        product_id,
        product_name
    FROM
        {{ ref('dim_product') }}
),

-- Añadir la tabla de dimensiones para los clientes
dimension_customers AS (
    SELECT
        customer_id,
        customer_name
    FROM
        {{ ref('dim_user') }}
)

SELECT
    sale_id,
    sale_date,
    dimension_time.month_start,
    dimension_time.year_start,
    dimension_products.product_name,
    quantity,
    unit_price,
    dimension_customers.customer_name,
    product_id,
    customer_id
FROM
    sales_data
    INNER JOIN dimension_time ON sales_data.sale_date = dimension_time.sale_date
    INNER JOIN dimension_products ON sales_data.product_id = dimension_products.product_id
    INNER JOIN dimension_customers ON sales_data.customer_id = dimension_customers.customer_id