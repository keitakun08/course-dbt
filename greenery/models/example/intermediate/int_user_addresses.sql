{{
  config(
    materialized='table'
  )
}}

SELECT
  u.user_id,
  u.first_name as first_name,
  u.last_name as last_name,
  concat(first_name, ' ', last_name) as full_name,
  u.email,
  u.phone_number,
  u.created_at_utc,
  u.updated_at_utc,
  a.address as address_name,
  a.zipcode,
  a.state,
  a.country
FROM {{ ref('stg_users') }} as u
LEFT JOIN {{ ref('stg_addresses') }} as a
  ON u.address_id = a.address_id
