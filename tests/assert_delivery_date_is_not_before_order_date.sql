-- Comprueba si hay algún caso en el que la fecha de entrega sea
-- anterior a la fecha en que se realizó el pedido
SELECT *
FROM {{ ref('base_sql_server_dbo__orders') }}
WHERE delivered_at_timestamp < created_at_timestamp
