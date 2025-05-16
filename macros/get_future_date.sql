{% macro get_future_date(years_to_add) %}
    {% set current_date = run_started_at.date() %}
    {% set future_date = current_date.replace(year=current_date.year + years_to_add) %}
    {{ return(future_date.isoformat()) }}
{% endmacro %}