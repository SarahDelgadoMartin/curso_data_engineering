{{
  config(
    materialized='table'
  )
    }}

WITH date_data AS (
    SELECT * 
    FROM {{ ref('stg_own_data__dates') }}

    )

SELECT* FROM date_data
