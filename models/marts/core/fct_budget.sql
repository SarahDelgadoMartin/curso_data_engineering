{{
    config(
        materialized='table'
    )
}}

WITH budget_data AS (
    SELECT
        *
    FROM
        {{ ref('stg_google_sheets__budget') }}
)

SELECT
    budget_id,
    product_id,
    month,
    year,
    date,
    target_quantity,
FROM
    budget_data
