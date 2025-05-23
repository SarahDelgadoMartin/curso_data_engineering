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
        {{ dbt_utils.generate_surrogate_key(['product_id', 'month']) }} AS budget_id,
        {{ dbt_utils.generate_surrogate_key(['product_id']) }} AS product_id,
        CAST(quantity AS INT) AS target_quantity,
        CAST(month AS DATE) AS date,
        CONVERT_TIMEZONE('UTC', CAST(_fivetran_synced AS TIMESTAMP_TZ)) AS date_load
    FROM src_budget
    )

SELECT * FROM renamed_casted