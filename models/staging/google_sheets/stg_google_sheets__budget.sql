{{
  config(
    materialized='view'
  )
}}

WITH src_budget AS (
    SELECT * 
    FROM {{ ref('base_google_sheets__budget') }}
    ),

renamed_casted AS (
    SELECT
        budget_id AS budget_id,
        product_id AS product_id,
        target_quantity AS target_quantity,
        MONTH(date) AS month,
        YEAR(date) AS year,
        date_load AS date_load
    FROM src_budget
    )

SELECT * FROM renamed_casted