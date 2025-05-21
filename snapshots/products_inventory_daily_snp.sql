{% snapshot products_inventory_daily_snp %}
-- Historificar inventario por día para saber la cantidad que hay en el tiempo
{{
  config(
    target_schema='snapshots',
    unique_key='product_id',
    strategy='check',
    check_cols=['inventory'],
  )
    }}

SELECT
    product_id,
    inventory
FROM {{ ref('base_sql_server_dbo__products') }}

{% endsnapshot %}