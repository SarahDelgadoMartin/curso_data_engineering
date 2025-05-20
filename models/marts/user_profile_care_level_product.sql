-- Perfil del Cliente por Nivel de Cuidado
-- Pregunta: ¿Los clientes que compran plantas de "cuidado fácil" son diferentes de los que compran plantas de "cuidado experto"? ¿Hay una correlación entre el care_level y el valor promedio del pedido o la frecuencia de compra?
-- Utilidad: Segmentar clientes en función de su nivel de experiencia y adaptar mensajes de marketing (tutoriales, promociones) y ofertas de productos.
WITH order_user_product_details AS (
    SELECT
        foi.user_id,
        foi.product_id,
        foi.total_quantity,
        foi.product_price
    FROM
        YOUR_SCHEMA.fct_order_items foi
),
product_care_level AS (
    SELECT
        product_id,
        care_level
    FROM
        YOUR_SCHEMA.dim_product
),
user_info AS (
    SELECT
        user_id,
        first_purchase_date,
        last_purchase_date
    FROM
        YOUR_SCHEMA.dim_user
)
SELECT
    pcl.care_level,
    COUNT(DISTINCT oupd.user_id) AS total_customers,
    AVG(oupd.total_quantity * oupd.product_price) AS average_order_value,
    -- La siguiente línea es una aproximación para la frecuencia, una lógica más detallada sería necesaria
    AVG(DATEDIFF(day, ui.first_purchase_date, ui.last_purchase_date)) AS avg_days_between_purchases
FROM
    order_user_product_details oupd
INNER JOIN
    product_care_level pcl ON oupd.product_id = pcl.product_id
INNER JOIN
    user_info ui ON oupd.user_id = ui.user_id
GROUP BY
    pcl.care_level
ORDER BY
    total_customers DESC;