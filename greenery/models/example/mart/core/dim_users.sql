{{
  config(
    materialized='table'
  )
}}

with cte_user_address as (
  select *
  from {{ ref('int_user_addresses') }}
),

cte_final as (
  select
    ua.user_id,
    ua.first_name,
    ua.last_name,
    ua.full_name,
    ua.email,
    ua.phone_number,
    ua.address_name,
    ua.zipcode,
    ua.state,
    ua.country
  from cte_user_address as ua
)

select *
from cte_final
