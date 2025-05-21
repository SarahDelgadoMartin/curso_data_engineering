{{
  config(
    materialized='table'
  )
    }}

WITH product_data AS (
    SELECT 
        product_id,
        product_price,
        product_name,
        inventory,
        plant_group,
        product_weight_kg,
        care_level,
        mature_size,
        is_deleted
    FROM {{ ref('stg_sql_server_dbo__products') }}
    )

SELECT * FROM product_data
