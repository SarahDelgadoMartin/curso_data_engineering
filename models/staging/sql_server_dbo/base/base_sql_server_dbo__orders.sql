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
        CAST(REPLACE(REPLACE(order_cost, ',', '.'), ' ', '') AS FLOAT) AS order_cost,
        CASE promo_id
            WHEN '' THEN {{dbt.hash(["no promo"])}}
            ELSE {{ dbt_utils.generate_surrogate_key(['promo_id']) }}
        END AS promo_id,
        CAST(REPLACE(REPLACE(shipping_cost, ',', '.'), ' ', '') AS FLOAT) AS shipping_cost,
        CAST(REPLACE(REPLACE(order_total, ',', '.'), ' ', '') AS FLOAT) AS order_total,
	    CAST(CASE shipping_service
                WHEN '' THEN 'not delivered'
                ELSE shipping_service
            END AS VARCHAR) AS shipping_service,
        CAST(CASE tracking_id
               WHEN '' THEN 'not delivered'
               ELSE tracking_id
            END AS VARCHAR) AS tracking_id,
        CONVERT_TIMEZONE(
            'UTC',
            CAST(IFNULL(
                    CAST('9999-12-31 23:59:59' AS TIMESTAMP_TZ),
                    estimated_delivery_at
                    ) AS TIMESTAMP_TZ
                )
            ) AS estimated_delivery_at,
        CONVERT_TIMEZONE(
            'UTC',
            CAST(
                IFNULL(
                    CAST('9999-12-31 23:59:59' AS TIMESTAMP_TZ),
                    delivered_at
                    ) AS TIMESTAMP_TZ
                )
            ) AS delivered_at,
        CONVERT_TIMEZONE(
            'UTC',
            CAST(
                IFNULL(
                    CAST('9999-12-31 23:59:59' AS TIMESTAMP_TZ),
                    created_at
                    ) AS TIMESTAMP_TZ
                )
            ) AS created_at,
        CAST(IFNULL(FALSE, _fivetran_deleted) AS BOOLEAN) AS is_delete,
        CONVERT_TIMEZONE('UTC', CAST(_fivetran_synced AS TIMESTAMP_TZ)) AS date_load
    FROM src_orders
    ),

new_row AS (
    SELECT
       {{ dbt.hash(["no order"]) }} AS promo_id,
       CONVERT_TIMEZONE('UTC', CURRENT_TIMESTAMP()) AS date_load

)    

SELECT * FROM renamed_casted
UNION ALL
SELECT * FROM new_row