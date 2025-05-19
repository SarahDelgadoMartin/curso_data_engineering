{{ config(
    materialized='incremental',
    partition_by={'field': 'inventory_date', 'data_type': 'date'},
    unique_key=['product_id', 'inventory_date'],
    incremental_strategy='insert_overwrite'
) }}

SELECT
    p.product_id,
    CAST({{ dbt.date_trunc('day', 'p.date_load') }} AS DATE) AS inventory_date,
    p.inventory,
    p.date_load AS loaded_at
FROM {{ ref('base_sql_server_dbo__products') }} p
{% if is_incremental() %}
WHERE CAST(p.date_load AS DATE) = CURRENT_DATE() - INTERVAL '1 day' 
{% endif %}