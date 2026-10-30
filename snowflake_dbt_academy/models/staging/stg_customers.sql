with 
    source_data as(
        select * 
        from {{ source ( 'raw_data',  'customers') }}
    ),

    country_map as (
        select * from {{ ref('country_mapping') }}
    ),

    cleaned  as (
       SELECT 
           customer_id::integer as customer_id,
           TRIM(UPPER(first_name)) AS  first_name,
           TRIM(UPPER(last_name)) AS  last_name,
           TRIM(LOWER(email)) AS email,
           COALESCE(TRIM(phone, 'N/A')) AS phone_number,
           trim(upper(country)) as country_code,
           coalesce(cm.country_code, trim(upper(s.country))) as country_standarized,
           created_at::timestamp_ntz as created_at
        FROM  source_data 
        LEFT JOIN country_map cm
            on trim(upper(s.country)) = upper(cm.country_raw)
        WHERE created_at IS NOT NULL
            AND email IS NOT NULL
            AND email LIKE '%@%'
        qualify ROW_NUMBER() OVER (PARTITION BY trim(lower(email)) ORDER BY created_at DESC) = 1
    )

select * from cleanded