{% snapshot budget_snapshot_s_timestamp %}

{{
    config(
      target_schema='snapshots',
      unique_key='_row',
      strategy='timestamp',
      updated_at='_fivetran_synced',
    )
}}

select * from {{ source('google_sheets', 'budget') }}

{% endsnapshot %}