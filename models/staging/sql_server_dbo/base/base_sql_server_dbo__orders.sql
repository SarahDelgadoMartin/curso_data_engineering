{{
  config(
    materialized='view'
  )
}}

WITH src_orders AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'orders') }}
    ),

renamed_casted AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['order_id']) }} AS order_id,
        {{ dbt_utils.generate_surrogate_key(['user_id']) }} AS user_id,
        {{ dbt_utils.generate_surrogate_key(['address_id']) }} AS address_id,
        CAST(status AS VARCHAR) AS order_status,
        CAST(order_cost AS FLOAT) AS order_cost,
        CASE promo_id
            WHEN '' THEN {{dbt.hash(["no promo"])}}
            ELSE {{ dbt_utils.generate_surrogate_key(['promo_id']) }}
        END AS promo_id,
        CAST(shipping_cost AS FLOAT) AS shipping_cost,
        CAST(order_total AS FLOAT) AS order_total,
	    CAST(shipping_service AS VARCHAR) AS shipping_service,
        CAST(tracking_id AS VARCHAR) AS tracking_id,
        CONVERT_TIMEZONE('UTC', CAST(estimated_delivery_at AS TIMESTAMP_TZ)) AS estimated_delivery_at,
        CONVERT_TIMEZONE('UTC', CAST(delivered_at AS TIMESTAMP_TZ)) AS delivered_at,
        CONVERT_TIMEZONE('UTC', CAST(created_at AS TIMESTAMP_TZ)) AS created_at,
        CAST(_fivetran_deleted AS BOOLEAN) AS is_delete,
        CONVERT_TIMEZONE('UTC', CAST(_fivetran_synced AS TIMESTAMP_TZ)) AS date_load
    FROM src_orders
    )   

SELECT * FROM renamed_casted
