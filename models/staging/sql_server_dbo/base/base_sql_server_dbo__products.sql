{{
  config(
    materialized='incremental',
    unique_key='product_id',
    on_schema_change='append_new_columns'
  )
    }}

WITH src_products AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'products') }}

    {% if is_incremental() %}

	WHERE _fivetran_synced > (SELECT MAX(date_load) FROM {{ this }} )

    {% endif %}
    ),

renamed_casted AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['product_id']) }} AS product_id,
        CAST(REPLACE(REPLACE(price, ',', '.'), ' ', '') AS FLOAT) AS price,
        CAST(name AS VARCHAR) AS name,
        CAST(inventory AS INT) AS inventory,
        CAST(IFNULL(_fivetran_deleted, FALSE) AS BOOLEAN) AS is_deleted,
        CONVERT_TIMEZONE('UTC', CAST(_fivetran_synced AS TIMESTAMP_TZ)) AS date_load
    FROM src_products
    )

SELECT * FROM renamed_casted
