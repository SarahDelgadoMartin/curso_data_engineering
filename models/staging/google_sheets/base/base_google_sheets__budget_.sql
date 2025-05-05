{{
  config(
    materialized='view'
  )
}}

WITH src_budget AS (
    SELECT * 
    FROM {{ source('google_sheets', 'budget') }}
    ),

renamed_casted AS (
    SELECT
        dbt_utils.generate_surrogate_key(['product_id', 'month']) AS budget_id,
        CAST(product_id AS VARCHAR(256)) AS product_id,
        CAST(quantity AS INT) AS target_quantity,
        MONTH(month) AS month,
        YEAR(month) AS year,
        CAST(CONVERT_TIMEZONE('Europe/Madrid', 'UTC', _fivetran_synced) AS DATE) AS date_load
    FROM src_budget
    )

SELECT * FROM renamed_casted