{{
  config(
    materialized='view'
  )
}}

WITH src_users AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'users') }}
    ),

renamed_casted AS (
    SELECT
        dbt_utils.generate_surrogate_key(['user_id']) AS user_id,
        CAST(last_name AS VARCHAR(256)) AS last_name,
        CAST(first_name AS VARCHAR(256)) AS first_name,
        dbt_utils.generate_surrogate_key(['address_id']) AS address_id,
        CAST(REPLACE(phone_number, "-", "") AS INT) AS phone_number,
        CAST(email AS VARCHAR(256)) AS email,
        CAST(CONVERT_TIMEZONE('Europe/Madrid', 'UTC', created_at) AS DATE) AS created_at,
        CAST(CONVERT_TIMEZONE('Europe/Madrid', 'UTC', updated_at) AS DATE) AS updated_at,
        CAST(CONVERT_TIMEZONE('Europe/Madrid', 'UTC', _fivetran_deleted) AS DATE) AS date_delete,
        CAST(CONVERT_TIMEZONE('Europe/Madrid', 'UTC', _fivetran_synced) AS DATE) AS date_load
    FROM src_users
    )   

SELECT * FROM renamed_casted
