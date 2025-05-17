{{
  config(
    materialized='view'
  )
    }}

WITH base_orders AS (
    SELECT DISTINCT(status)
    FROM {{ ref('base_sql_server_dbo__orders') }}
    ),

renamed_casted AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['status']) }} AS order_status_id,
        status AS desc_status
    FROM base_orders
    )

SELECT * FROM renamed_casted