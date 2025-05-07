{{
  config(
    materialized='incremental'
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
        CAST(name AS VARCHAR(256)) AS name,
        CAST(inventory AS INT) AS inventory,
        CAST(IFNULL(FALSE, _fivetran_deleted) AS BOOLEAN) AS is_delete,
        CONVERT_TIMEZONE('UTC', CAST(_fivetran_synced AS TIMESTAMP_TZ)) AS date_load
    FROM src_products
    )

SELECT * FROM renamed_casted
