{{
  config(
    materialized='incremental'
  )
    }}

WITH src_users AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'users') }}
    
{% if is_incremental() %}

	WHERE _fivetran_synced > (SELECT MAX(date_load) FROM {{ this }} )

{% endif %}
    ),

renamed_casted AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['user_id']) }} AS user_id,
        CAST(last_name AS VARCHAR) AS last_name,
        CAST(first_name AS VARCHAR) AS first_name,
        {{ dbt_utils.generate_surrogate_key(['address_id']) }} AS address_id,
        CAST(phone_number AS VARCHAR) AS phone_number,
        CAST(email AS VARCHAR) AS email,
        CONVERT_TIMEZONE(
            'UTC',
            CAST(IFNULL(
                    created_at,
                    CAST('9999-12-31 23:59:59' AS TIMESTAMP_TZ)
                    ) AS TIMESTAMP_TZ
                )
            ) AS created_at,
        CONVERT_TIMEZONE(
            'UTC',
            CAST(IFNULL(
                    updated_at,
                    CAST('9999-12-31 23:59:59' AS TIMESTAMP_TZ)
                    ) AS TIMESTAMP_TZ
                )
            ) AS updated_at,
        CAST(IFNULL(_fivetran_deleted, FALSE) AS BOOLEAN) AS is_delete,
        CONVERT_TIMEZONE('UTC', CAST(_fivetran_synced AS TIMESTAMP_TZ)) AS date_load
    FROM src_users
    )   

SELECT * FROM renamed_casted
