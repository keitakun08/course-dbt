{{
  config(
    materialized='table'
  )
}}

with cte_user_address as (
  select *
  from {{ ref('int_user_addresses') }}
),

cte_user_orders as (
  select *
  from {{ ref('int_user_orders') }}
),

cte_user_events as (
  select *
  from {{ ref('int_user_events') }}
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
    ua.country,
    uo.user_created_at_utc,
    uo.first_order_date_utc,
    uo.latest_order_date_utc,
    uo.have_ordered,
    uo.days_to_first_order,
    uo.total_gross_order_amount,
    uo.total_shipping_amount,
    uo.total_net_order_amount,
    uo.total_order_quantity,
    ue.total_session,
    ue.total_unique_session,
    ue.first_session_created_at,
    ue.latst_session_created_at,
    ue.total_page_view,
    ue.total_add_to_cart,
    ue.total_checkout,
    ue.total_package_shipped
  from cte_user_address as ua
  left join cte_user_orders as uo
    on ua.user_id = uo.user_id
  left join cte_user_events as ue
    on ua.user_id = ue.user_id
)

select *
from cte_final
