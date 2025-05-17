{{
  config(
    materialized='incremental',
    unique_key='order_id',
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
        order_id,
        user_id,
        address_id,
        status,
        order_cost,
        promo_id,
        shipping_cost,
        order_total,
	    shipping_service,
        tracking_id,
        DATE(estimated_delivery_at_timestamp) AS estimated_delivery_at_date,
        TIME(estimated_delivery_at_timestamp) AS estimated_delivery_at_time,
        DATE(delivered_at_timestamp) AS delivered_at_date,
        TIME(delivered_at_timestamp) AS delivered_at_time,
        DATE(created_at_timestamp) AS created_at_date,
        TIME(created_at_timestamp) AS created_at_time,
        is_deleted,
        date_load
    FROM base_orders
    )

SELECT * FROM renamed_casted
