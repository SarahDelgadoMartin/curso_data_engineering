{{
  config(
    materialized='incremental'
  )
}}

WITH base_users AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo__users') }}
    
{% if is_incremental() %}

	WHERE _fivetran_synced > (SELECT MAX(date_load) FROM {{ this }} )

{% endif %}
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
        DATE(created_at) AS created_date_at,
        TIME(created_at) AS created_time_at,
        DATE(updated_at) AS updated_date_at,
        TIME(updated_at) AS updated_time_at,
        is_delete,
        date_load
    FROM base_users
    )   

SELECT * FROM renamed_casted
