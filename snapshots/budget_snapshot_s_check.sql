{% snapshot budget_snapshot_s_check %}

{{
    config(
      target_schema='snapshots',
      unique_key='_row',
      strategy='check',
      check_cols=['quantity'],
        )
}}

select * from {{ source('google_sheets', 'budget') }}

{% endsnapshot %}