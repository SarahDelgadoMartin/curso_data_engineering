{{
  config(
    materialized='incremental',
    unique_key='address_id',
    on_schema_change='append_new_columns'
  )
    }}

WITH address_data AS (
    SELECT 
        address_id,
        street,
        number,
        zipcode_id,
        state,
        country,
        is_deleted,
        date_load
    FROM {{ ref('stg_sql_server_dbo__addresses') }}

    {% if is_incremental() %}

	WHERE date_load > (SELECT MAX(date_load) FROM {{ this }} )

    {% endif %}
    )

SELECT * FROM address_data
