{{ 
    config(materialized='table') 
}}

{% set end_date = get_future_date(2) %}

{{ dbt_date.get_date_dimension(start_date='2018-01-01', end_date=end_date) }}
