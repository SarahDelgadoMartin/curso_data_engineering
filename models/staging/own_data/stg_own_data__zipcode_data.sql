{{
  config(
    materialized='view'
  )
    }}

WITH src_zipcode AS (
    SELECT * 
    FROM {{ source('own_data', 'zipcode_data') }}
    ),

renamed_casted AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['zipcode']) }} AS zipcode_id,
        CAST(zipcode AS VARCHAR) AS zipcode,
        CAST(city AS VARCHAR) AS city,
        CAST(state_code AS VARCHAR) AS state_code,
        CAST(latitude AS FLOAT) AS latitude,
        CAST(longitude AS FLOAT) AS longitude,
        CAST(IFNULL(population, 0) AS INT) AS population
    FROM src_zipcode
    )

SELECT * FROM renamed_casted
