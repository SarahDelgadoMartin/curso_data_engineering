{{
  config(
    materialized='incremental'
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
        {{ dbt_utils.generate_surrogate_key(['status']) }} AS order_status_id,
        order_cost,
        promo_id,
        shipping_cost,
        order_total,
	    shipping_service,
        tracking_id,
        DATE(estimated_delivery_at) AS estimated_delivery_date_at,
        TIME(estimated_delivery_at) AS estimated_delivery_time_at,
        DATE(delivered_at) AS delivered_date_at,
        TIME(delivered_at) AS delivered_time_at,
        DATE(created_at) AS created_date_at,
        TIME(created_at) AS created_time_at,
        is_delete,
        date_load
    FROM base_orders
    )

SELECT * FROM renamed_casted
