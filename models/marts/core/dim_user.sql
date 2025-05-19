{{
  config(
    materialized='table'
  )
    }}

WITH user_data AS (
    SELECT
        user_id,
        last_name,
        first_name,
        address_id,
        phone_number,
        is_valid_us_phone,
        email,
        is_valid_email,
        created_at_date,
        created_at_time,
        created_at_timestamp,
        updated_at_date,
        updated_at_time,
        updated_at_timestamp,
        is_deleted
    FROM {{ ref('stg_sql_server_dbo__users') }}
    ),

order_data AS (
    SELECT
        order_id,
        user_id,
        created_at_timestamp
    FROM {{ ref('stg_sql_server_dbo__orders') }}
    ),

last_order_data AS (
    SELECT
        user_id,
        CAST(MAX(created_at_timestamp) AS DATE) AS last_purchase_date
    FROM order_data
    GROUP BY user_id
)
    
SELECT
    ud.user_id,
    ud.last_name,
    ud.first_name,
    ud.address_id,
    ud.phone_number,
    ud.is_valid_us_phone,
    ud.email,
    ud.is_valid_email,
    CASE 
        WHEN lod.last_purchase_date IS NOT NULL THEN TRUE
        ELSE FALSE 
    END AS has_purchased,
    lod.last_purchase_date,
    ud.created_at_date,
    ud.created_at_time,
    ud.created_at_timestamp,
    ud.updated_at_date,
    ud.updated_at_time,
    ud.updated_at_timestamp,
    ud.is_deleted
FROM user_data ud
LEFT JOIN last_order_data lod
ON ud.user_id = lod.user_id