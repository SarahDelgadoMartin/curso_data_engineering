{{
  config(
    materialized='incremental',
    unique_key='shipping_service_id',
    on_schema_change='append_new_columns'
  )
    }}

WITH base_orders AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo__orders') }}
 
    {% if is_incremental() %}

	WHERE date_load > (SELECT MAX(date_load) FROM {{ this }} )

    {% endif %}
    ),

renamed_casted AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['shipping_service']) }} AS shipping_service_id,
	    shipping_service AS dec_shipping_service
        -- Añadir dirección y más cosas
    FROM base_orders
    )

SELECT * FROM renamed_casted
