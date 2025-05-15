{{
  config(
    materialized='incremental',
    unique_key='address_id',
    on_schema_change='append_new_columns'
  )
    }}

WITH base_addresses AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo__addresses') }}

    {% if is_incremental() %}

	WHERE date_load > (SELECT MAX(date_load) FROM {{ this }} )

    {% endif %}
    ),

renamed_casted AS (
    SELECT
        address_id,
        street,
        number,
        {{ dbt_utils.generate_surrogate_key(['zipcode']) }} AS zipcode_id,
        state,
        country,
        is_delete,
        date_load
    FROM base_addresses
    ),

SELECT * FROM renamed_casted
