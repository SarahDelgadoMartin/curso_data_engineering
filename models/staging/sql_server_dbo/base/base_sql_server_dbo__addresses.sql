{{
  config(
    materialized='incremental',
    unique_key='address_id',
    on_schema_change='append_new_columns'
  )
}}

WITH src_addresses AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'addresses') }}

    {% if is_incremental() %}

	WHERE _fivetran_synced > (SELECT MAX(date_load) FROM {{ this }} )

    {% endif %}
    ),

renamed_casted AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['address_id']) }} AS address_id,
        CAST(SPLIT(address, ' ')[1] AS VARCHAR(256)) AS street,
        CAST(SPLIT(address, ' ')[0] AS INT) AS number,
        LPAD(CAST(zipcode AS VARCHAR), 5, '0') AS zipcode,
        CAST(state AS VARCHAR(256)) AS state,
        CAST(country AS VARCHAR(256)) AS country,
        CAST(IFNULL(_fivetran_deleted, FALSE) AS BOOLEAN) AS is_delete,
        CONVERT_TIMEZONE('UTC', CAST(_fivetran_synced AS TIMESTAMP_TZ)) AS date_load
    FROM src_addresses
    )

SELECT * FROM renamed_casted
