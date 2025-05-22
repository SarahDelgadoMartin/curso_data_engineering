-- Impacto del Peso en el Tiempo de Entrega
WITH delivered_order_items AS (
    SELECT
        order_id,
        product_id,
        order_date,
        delivered_at_date,
    FROM {{ ref('fct_order_items') }}
    WHERE delivered_at_date != '9999-12-31'
    ),

product_characteristics AS (
    SELECT
        product_id,
        product_weight_kg
    FROM {{ ref('dim_product') }}
    )

SELECT
    CASE
        WHEN product_weight_kg >= 4 THEN 'Muy pesado'
        WHEN product_weight_kg >= 1 THEN 'Medio pesado'
        ELSE 'Poco pesado'
    END AS product_weight_group,
    ROUND(AVG(DATEDIFF(day, doi.order_date, doi.delivered_at_date))) AS average_delivery_days,
    COUNT(DISTINCT doi.order_id) AS total_orders
FROM delivered_order_items doi
INNER JOIN product_characteristics pc ON doi.product_id = pc.product_id
GROUP BY 
    CASE
        WHEN product_weight_kg >= 4 THEN 'Muy pesado'
        WHEN product_weight_kg >= 1 THEN 'Medio pesado'
        ELSE 'Poco pesado'
    END
ORDER BY average_delivery_days
