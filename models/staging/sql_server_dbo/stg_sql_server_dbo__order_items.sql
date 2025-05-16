{{
  config(
    materialized='incremental'
  )
    }}

WITH base_order_items AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo__order_items') }}

    {% if is_incremental() %}

	WHERE date_load > (SELECT MAX(date_load) FROM {{ this }} )
    
    {% endif %}
    ),

final AS (
    SELECT
        boi.*,
        bp.price AS product_price
    FROM base_order_items boi
    INNER JOIN {{ ref('stg_sql_server_dbo__products') }} sp
       ON boi.product_id = sp.product_id 
    )

SELECT * FROM final
