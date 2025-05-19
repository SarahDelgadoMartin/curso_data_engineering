{% snapshot orders_check_snp %}
-- Historificar estado de los pedidos
{{
  config(
    unique_key='order_id',
    strategy='check',
    check_cols=['status']
  )
    }}

SELECT 
    order_id,
    status,
    date_load
FROM {{ ref('base_sql_server_dbo__orders') }}

{% endsnapshot %}