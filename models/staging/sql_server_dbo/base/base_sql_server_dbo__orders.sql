{{
  config(
    materialized='incremental',
    unique_key='order_id',
    on_schema_change='fail'
  )
    }}

WITH src_orders AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'orders') }}
 
    {% if is_incremental() %}

	WHERE _fivetran_synced > (SELECT MAX(date_load) FROM {{ this }} )

    {% endif %}
    ),

renamed_casted AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['order_id']) }} AS order_id,
        {{ dbt_utils.generate_surrogate_key(['user_id']) }} AS user_id,
        {{ dbt_utils.generate_surrogate_key(['address_id']) }} AS address_id,
        CAST(status AS VARCHAR) AS status,
        CAST(REPLACE(REPLACE(order_cost, ',', '.'), ' ', '') AS FLOAT) AS order_cost,
        CASE promo_id
            WHEN '' THEN {{ dbt_utils.generate_surrogate_key(["'no promo'"]) }}
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
                    estimated_delivery_at,
                    CAST('9999-12-31 23:59:59' AS TIMESTAMP_TZ)
                    ) AS TIMESTAMP_TZ
                )
            ) AS estimated_delivery_at_timestamp,
        CONVERT_TIMEZONE(
            'UTC',
            CAST(
                IFNULL(
                    delivered_at,
                    CAST('9999-12-31 23:59:59' AS TIMESTAMP_TZ)
                    ) AS TIMESTAMP_TZ
                )
            ) AS delivered_at_timestamp,
        CONVERT_TIMEZONE(
            'UTC',
            CAST(
                IFNULL(
                    created_at,
                    CAST('9999-12-31 23:59:59' AS TIMESTAMP_TZ)
                    ) AS TIMESTAMP_TZ
                )
            ) AS created_at_timestamp,
        CAST(IFNULL(_fivetran_deleted, FALSE) AS BOOLEAN) AS is_deleted,
        CONVERT_TIMEZONE('UTC', CAST(_fivetran_synced AS TIMESTAMP_TZ)) AS date_load
    FROM src_orders
    )

SELECT * FROM renamed_casted
