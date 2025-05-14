{{
  config(
    materialized='incremental'
  )
    }}

WITH base_products AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo__products') }}

    {% if is_incremental() %}

	WHERE date_load > (SELECT MAX(date_load) FROM {{ this }} )

    {% endif %}
    ),

renamed_casted AS (
    SELECT
        product_id,
        price,
        name,
        inventory,
        is_delete,
        date_load
    FROM base_products
    )

SELECT * FROM renamed_casted
