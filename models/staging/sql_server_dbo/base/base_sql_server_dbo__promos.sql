{{
  config(
    materialized='view'
  )
}}

WITH src_promos AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'promos') }}
    ),

renamed_casted AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['promo_id']) }} AS promo_id,
        CAST(promo_id AS VARCHAR(50)) AS desc_promo,
        CAST(discount AS INT) AS discount_units,
        CAST(CASE status
            WHEN 'inactive' THEN false
            WHEN 'active' THEN true
        END AS BOOLEAN) AS status,
        CAST(_fivetran_deleted AS BOOLEAN) AS is_delete,
        CONVERT_TIMEZONE('UTC', CAST(_fivetran_synced AS TIMESTAMP_TZ)) AS date_load
    FROM src_promos
    ),

new_row AS (
    SELECT
       {{ dbt.hash(["no promo"]) }} AS promo_id,
       'no promo' AS desc_promo,
       0 AS discount_units,
       true AS status,
       NULL AS date_delete,
       CONVERT_TIMEZONE('UTC', CURRENT_TIMESTAMP()) AS date_load

)    

SELECT * FROM renamed_casted
UNION ALL
SELECT * FROM new_row
