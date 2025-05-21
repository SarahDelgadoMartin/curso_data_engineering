{{
  config(
    materialized='incremental',
    unique_key='order_id',
    on_schema_change='append_new_columns'
  )
    }}

WITH orders_data AS (
    SELECT
        order_id,
        order_cost,
        promo_id,
        shipping_cost,
        order_total,
        is_deleted,
        date_load
    FROM {{ ref('stg_sql_server_dbo__orders') }}

    {% if is_incremental() %}

	WHERE date_load > (SELECT MAX(date_load) FROM {{ this }} )

    {% endif %}
    )
    
SELECT * FROM orders_data 
