{{
  config(
    materialized='table'
  )
}}

select
  u.user_id,
  count(session_id) as total_session,
  count(distinct session_id) as total_unique_session,
  min(e.created_at_utc) as first_session_created_at,
  max(e.created_at_utc) as latst_session_created_at,
  sum(iff(e.event_type = 'page_view', 1, 0)) as total_page_view,
  sum(iff(e.event_type = 'add_to_cart', 1, 0)) as total_add_to_cart,
  sum(iff(e.event_type = 'checkout', 1, 0)) as total_checkout,
  sum(iff(e.event_type = 'package_shipped', 1, 0)) as total_package_shipped
from {{ ref('stg_users') }} as u
left join {{ ref('stg_events') }} as e
  on u.user_id = e.user_id
group by 1
