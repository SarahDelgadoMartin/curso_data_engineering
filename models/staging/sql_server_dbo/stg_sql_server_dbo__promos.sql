{{
  config(
    materialized='incremental'
  )
    }}

WITH src_promos AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'promos') }}

    {% if is_incremental() %}

	WHERE _fivetran_synced > (SELECT MAX(date_load) FROM {{ this }} )

    {% endif %}
    
    UNION ALL

    SELECT
       'no promo' AS promo_id,
       0 AS discount,
       TRUE AS status,
       FALSE AS _fivetran_deleted,
       CURRENT_TIMESTAMP() AS _fivetran_synced 
    ),

renamed_casted AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['promo_id']) }} AS promo_id,
        CAST(promo_id AS VARCHAR(50)) AS desc_promo,
        CAST(discount AS INT) AS discount_on_units,
        CAST(CASE status
            WHEN 'inactive' THEN FALSE
            WHEN 'active' THEN TRUE
        END AS BOOLEAN) AS is_active,
        CAST(IFNULL(FALSE, _fivetran_deleted) AS BOOLEAN) AS is_delete,
        CONVERT_TIMEZONE('UTC', CAST(_fivetran_synced AS TIMESTAMP_TZ)) AS date_load
    FROM src_promos
    ) 

SELECT * FROM renamed_casted
