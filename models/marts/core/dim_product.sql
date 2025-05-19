{{
  config(
    materialized='incremental',
    unique_key='product_id',
    on_schema_change='append_new_columns'
  )
    }}

WITH product_data AS (
    SELECT 
        product_id,
        price,
        name,
        inventory,
        plant_group,
        product_weight_kg,
        care_level,
        mature_size,
        is_deleted,
        date_load
    FROM {{ ref('stg_sql_server_dbo__products') }}

    {% if is_incremental() %}

	WHERE date_load > (SELECT MAX(date_load) FROM {{ this }} )

    {% endif %}
    )

SELECT * FROM product_data
