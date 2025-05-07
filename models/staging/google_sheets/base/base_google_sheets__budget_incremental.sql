 {{ config(
    materialized='incremental',
    unique_key = '_row'
    ) 
}}

WITH stg_budget_products AS (
    SELECT * 
    FROM {{ source('google_sheets', 'budget') }}

{% if is_incremental() %}

	WHERE _fivetran_synced > (SELECT MAX(date_load) FROM {{ this }} )

{% endif %}
    ),

renamed_casted AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['product_id', 'month']) }} AS budget_id,
        {{ dbt_utils.generate_surrogate_key(['product_id']) }} AS product_id,
        CAST(quantity AS INT) AS target_quantity,
        CAST(month AS DATE) AS date,
        CONVERT_TIMEZONE('UTC', CAST(_fivetran_synced AS DATE)) AS date_load
    FROM stg_budget_products
    )
  
SELECT * FROM renamed_casted 