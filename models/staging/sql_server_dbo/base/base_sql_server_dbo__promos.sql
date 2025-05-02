(SELECT dbt_utils.generate_surrogate_key(promo_id) AS promo_id,
       CAST(desc_promo AS VARCHAR(50)) AS promo_id,
       CAST(discount AS INT) AS discount_units,
       CAST(CASE status
            WHEN "inactive" THEN false
            WHEN "active" THEN true
       END, AS BOOLEAN) AS status,
       _fivetran_deleted,
       _fivetran_synced
FROM {{ source('sql_server_dbo', 'promos') }})
UNION ALL
(SELECT dbt_utils.generate_surrogate_key(no_promo) AS promo_id
       no_promo AS promo_id,
       0 AS discount_units,
       true AS status,
       null,
       HOY)
