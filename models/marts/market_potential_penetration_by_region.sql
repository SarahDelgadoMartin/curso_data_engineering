-- Ayuda a entender dónde tienes una fuerte presencia y dónde hay oportunidades sin explotar. Si vendes mucho en un código postal pequeño, pero poco en uno grande y cercano, es una señal para investigar. Permite identificar mercados objetivo de alto potencial para campañas de marketing digital o expansión de servicios de envío.
WITH customer_counts AS (
    SELECT
        da.city,
        da.state,
        COUNT(DISTINCT du.user_id) AS total_customers
    FROM
        YOUR_SCHEMA.dim_user du
    INNER JOIN
        YOUR_SCHEMA.dim_address da ON du.address_id = da.address_id
    GROUP BY
        da.city,
        da.state
),
population_data AS (
    SELECT
        da.city,
        da.state,
        SUM(CAST(da.zipcode_population AS INT)) AS total_city_population -- Convertir a INT si está como VARCHAR
    FROM
        YOUR_SCHEMA.dim_address da
    GROUP BY
        da.city,
        da.state
)
SELECT
    pc.city,
    pc.state,
    pc.total_customers,
    pd.total_city_population,
    (CAST(pc.total_customers AS FLOAT) / pd.total_city_population) * 100 AS market_penetration_percentage
FROM
    customer_counts pc
INNER JOIN
    population_data pd ON pc.city = pd.city AND pc.state = pd.state
WHERE
    pd.total_city_population > 0 -- Evitar división por cero
ORDER BY
    market_penetration_percentage DESC;