{{
  config(
    materialized='incremental',
    unique_key='user_id',
    on_schema_change='append_new_columns'
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
)
    
SELECT * FROM user_data 