-- Script ingesta datos

-- Creación del schema own_data
CREATE OR REPLACE SCHEMA ALUMNO30_DEV_BRONZE_DB.OWN_DATA;

-- Creación del Stage
CREATE OR REPLACE STAGE ALUMNO30_DEV_BRONZE_DB.OWN_DATA.csv_data
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY='"' SKIP_HEADER = 1);

-- Subir archivo csv de zipcode al Stage
-- snowsql -a civicpartner.west-europe.azure --authenticator externalbrowser
-- -d ALUMNO30_DEV_BRONZE_DB -s own_data -q "PUT FILE://zipcode_city_geo_population.csv @csv_data AUTO_COMPRESS=FALSE"

-- Creación de la tabla zipcode
CREATE OR REPLACE TABLE ALUMNO30_DEV_BRONZE_DB.OWN_DATA.zipcode_data(
zipcode STRING,
city STRING,
state_code STRING,
latitude FLOAT,
longitude FLOAT,
population INT
);

-- Ingesta de datos desde el CSV zipcode
COPY INTO ALUMNO30_DEV_BRONZE_DB.OWN_DATA.zipcode_data
FROM @ALUMNO30_DEV_BRONZE_DB.OWN_DATA.csv_data/zipcode_data.csv
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY='"' SKIP_HEADER = 1);

-- Subir archivo product_details CSV al Stage
-- snowsql -a civicpartner.west-europe.azure --authenticator externalbrowser
-- -d ALUMNO30_DEV_BRONZE_DB -s own_data -q "PUT FILE://product_details.csv @csv_data AUTO_COMPRESS=FALSE"

-- Creación de la tabla product_details
CREATE OR REPLACE TABLE ALUMNO30_DEV_BRONZE_DB.OWN_DATA.PRODUCT_DETAILS(
product_id VARCHAR,
plant_group VARCHAR,
product_weight_kg FLOAT,
care_level VARCHAR,
mature_size VARCHAR
);

-- Ingesta de datos desde el csv product_details
COPY INTO ALUMNO30_DEV_BRONZE_DB.OWN_DATA.PRODUCT_DETAILS
FROM @ALUMNO30_DEV_BRONZE_DB.OWN_DATA.csv_data/product_details.csv
FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1);
