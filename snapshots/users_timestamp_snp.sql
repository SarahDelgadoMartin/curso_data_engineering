{% snapshot users_timestamp_snp %}

{{
  config(
    unique_key='user_id',
    strategy='timestamp',
    updated_at='updated_at_timestamp',
    hard_deletes='invalidate',
  )
    }}

SELECT 
    user_id,
    last_name,
    first_name,
    address_id,
    phone_number,
    is_valid_us_phone,
    email,
    is_valid_email,
    created_at_timestamp,
    updated_at_timestamp
FROM {{ ref('base_sql_server_dbo__users') }}

{% endsnapshot %}