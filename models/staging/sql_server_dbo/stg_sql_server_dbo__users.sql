{{
  config(
    materialized='view'
  )
    }}

WITH base_users AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo__users') }}

    ),

renamed_casted AS (
    SELECT
        user_id,
        last_name,
        first_name,
        address_id,
        phone_number,
        CAST(CASE
              WHEN REGEXP_LIKE(phone_number, '^[0-9]{3}-[0-9]{3}-[0-9]{4}$') THEN TRUE
              ELSE FALSE
            END AS BOOLEAN) AS is_valid_us_phone,
        email,
        CAST(CASE
              WHEN REGEXP_LIKE(email, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$') THEN TRUE
              ELSE FALSE
            END AS BOOLEAN) AS is_valid_email,
        DATE(created_at_timestamp) AS created_at_date,
        TIME(created_at_timestamp) AS created_at_time,
        created_at_timestamp,
        DATE(updated_at_timestamp) AS updated_at_date,
        TIME(updated_at_timestamp) AS updated_at_time,
        updated_at_timestamp,
        is_deleted,
        date_load
    FROM base_users
    )   

SELECT * FROM renamed_casted
