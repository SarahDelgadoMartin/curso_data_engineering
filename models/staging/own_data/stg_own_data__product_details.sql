{{
  config(
    materialized='view'
  )
    }}

WITH src_product_details AS (
    SELECT * 
    FROM {{ source('own_data', 'zipcode_data') }}
    ),

renamed_casted AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['product_id']) }} AS product_id,
        CAST(plant_group AS VARCHAR) AS plant_group,
        CAST(product_weight_kg AS FLOAT) AS product_weight_kg,
        CAST(care_level AS VARCHAR) AS care_level,
        CAST(mature_size AS VARCHAR) AS mature_size
    FROM src_product_details
    )

SELECT * FROM renamed_casted
