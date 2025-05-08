{{
  config(
    materialized='incremental',
    enabled = false
  )
}}

WITH src_events AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'events') }}

{% if is_incremental() %}

	WHERE _fivetran_synced > (SELECT MAX(date_load) FROM {{ this }} )

{% endif %}
),

renamed_casted AS (
    SELECT
        generate_surrogate_key(['event_id']) AS event_id,
        EVENT_ID VARCHAR(1024) NOT NULL,
	PAGE_URL VARCHAR(1024),
	EVENT_TYPE VARCHAR(100),
	USER_ID VARCHAR(1024),
	PRODUCT_ID VARCHAR(1024),
	SESSION_ID VARCHAR(1024),
	CREATED_AT TIMESTAMP_NTZ(9),
	ORDER_ID VARCHAR(1024),
	_FIVETRAN_DELETED BOOLEAN,
	_FIVETRAN_SYNCED TIMESTAMP_TZ(9),


        CAST(IFNULL(FALSE, _fivetran_deleted) BOOLEAN) AS is_delete,
        CONVERT_TIMEZONE('UTC', CAST(_fivetran_synced AS TIMESTAMP_TZ)) AS date_load
    FROM src_events
    )   

SELECT * FROM renamed_casted
