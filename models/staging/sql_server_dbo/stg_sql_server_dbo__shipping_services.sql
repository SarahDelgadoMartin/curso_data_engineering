{{
  config(
    materialized='view'
  )
    }}

WITH base_orders AS (
    SELECT DISTINCT(shipping_service) 
    FROM {{ ref('base_sql_server_dbo__orders') }}
    ),

renamed_casted AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['shipping_service']) }} AS shipping_service_id,
	    shipping_service AS dec_shipping_service
        -- Añadir dirección y más cosas
    FROM base_orders
    )

SELECT * FROM renamed_casted
