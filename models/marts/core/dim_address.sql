WITH address_data AS (
    SELECT 
        address_id,
        street,
        number,
        zipcode_id,
        state,
        country,
        is_deleted,
        date_load
    FROM {{ ref('stg_sql_server_dbo__addresses') }}
    ),

zipcode_data AS (
    SELECT
        zipcode_id,
        zipcode,
        city,
        state_code,
        latitude AS zipcode_latitude,
        longitude AS zipcode_longitude,
        population AS zipcode_population
    FROM {{ ref('stg_own_data__zipcode_data') }}
    )

SELECT 
    ad.address_id,
    ad.street,
    ad.number,
    zd.zipcode,
    zd.city,
    ad.state,
    zd.state_code,
    ad.country,
    zd.zipcode_latitude,
    zd.zipcode_longitude,
    zd.zipcode_population,
    ad.is_deleted
FROM address_data ad
INNER JOIN zipcode_data zd ON ad.zipcode_id = zd.zipcode_id
