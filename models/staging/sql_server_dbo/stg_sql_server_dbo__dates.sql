{{
    config(
        materialized='incremental',
        unique_key='date_actual',
        incremental_strategy='insert_overwrite'
    )
    }}

{% set current_date = dbt.date_trunc('day', dbt.current_timestamp()) %}
{% set future_end_date = dbt.dateadd('year', 2, current_date) %}

WITH existing_dates AS (
    SELECT MAX(date_actual) AS max_date
    FROM {{ this }}
    ),

future_spine AS (
    SELECT date_day AS date_actual
    FROM {{ dbt_utils.date_spine(
        datepart="day",
        start_date="(SELECT COALESCE(MAX(max_date), '2020-01-01') FROM existing_dates)",
        end_date="future_end_date"
    ) }}
    WHERE date_day > (SELECT max_date FROM existing_dates)
    )

SELECT
    fs.date_actual,
    EXTRACT(YEAR FROM fs.date_actual) AS year_actual,
    EXTRACT(MONTH FROM fs.date_actual) AS month_actual,
    MONTHNAME(fs.date_actual) AS month_name_actual,
    EXTRACT(DAY FROM fs.date_actual) AS day_actual,
    EXTRACT(DAYOFWEEK FROM fs.date_actual) AS day_of_week_actual,
    DAYNAME(fs.date_actual) AS day_name_actual,
    EXTRACT(WEEK FROM fs.date_actual) AS week_of_year_actual,
    EXTRACT(QUARTER FROM fs.date_actual) AS quarter_actual,
    CASE
        WHEN EXTRACT(MONTH FROM fs.date_actual) IN (1, 2, 3) THEN 1
        WHEN EXTRACT(MONTH FROM fs.date_actual) IN (4, 5, 6) THEN 2
        WHEN EXTRACT(MONTH FROM fs.date_actual) IN (7, 8, 9) THEN 3
        ELSE 4
    END AS quarter_of_year_actual,
    (year_actual * 100) + month_actual AS year_month_actual,
    current_date AS date_load
FROM future_spine fs

{% if is_incremental() %}
    WHERE fs.date_actual > (SELECT max_date FROM existing_dates)
{% endif %}
