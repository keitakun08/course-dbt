{{
  config(
    materialized='table'
  )
}}

with cte_user_address as (
  select *
  from {{ ref('int_user_addresses') }}
),

cte_orders as (
  select
    user_id,
    count(*) as order_count,
    min(order_created_at_utc) as first_order,
    max(order_created_at_utc) as last_order,
    sum(order_cost) as total_gross_order_amount,
    sum(shipping_cost) as total_shipping_amount,
    sum(order_total) as total_net_order_amount,
    sum(order_quantity) as total_order_quantity
  from {{ ref('fact_orders') }}
  group by 1
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
    o.order_count,
    o.first_order,
    o.last_order,
    o.total_gross_order_amount,
    o.total_shipping_amount,
    o.total_net_order_amount,
    o.total_order_quantity,
    ue.first_session_created_at,
    ue.latest_session_created_at,
    ue.total_session,
    ue.total_page_view,
    ue.total_add_to_cart,
    ue.total_checkout,
    ue.total_package_shipped
  from cte_user_address as ua
  left join cte_orders as o
    on ua.user_id = o.user_id
  left join cte_user_events as ue
    on ua.user_id = ue.user_id 
)

select *
from cte_final
