{{
  config(
    materialized='table'
  )
    }}

WITH promo_data AS (
    SELECT
        promo_id,
        desc_promo,
        discount_on_units,
        is_active,
        is_deleted,
    FROM {{ ref('stg_sql_server_dbo__promos') }}
)
    
SELECT * FROM promo_data 