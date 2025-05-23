{{
  config(
    materialized='view'
  )
    }}

WITH base_products AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo__products') }}
    ),

base_product_details AS (
    SELECT * 
    FROM {{ ref('base_own_data__product_details') }}
    ),

renamed_casted AS (
    SELECT
        bp.product_id,
        bp.product_price,
        bp.product_name,
        bp.inventory,
        bpd.plant_group,
        bpd.product_weight_kg,
        bpd.care_level,
        bpd.mature_size,
        bp.is_deleted,
        bp.date_load
    FROM base_products bp
    INNER JOIN base_product_details bpd 
    ON bp.product_id = bpd.product_id
    )

SELECT * FROM renamed_casted
