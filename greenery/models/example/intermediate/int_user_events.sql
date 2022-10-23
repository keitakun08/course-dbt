{{
  config(
    materialized='table'
  )
}}

select
  user_id,
  session_id,
  count(session_id) as total_session,
  count(distinct session_id) as total_unique_session,
  min(created_at_utc) as first_session_created_at,
  max(created_at_utc) as latest_session_created_at,
  min(created_at_utc) as session_start,
  max(
    case when event_type != 'package_shipped' then created_at_utc else NULL end
    ) as session_end,
  timediff(
    second, min(created_at_utc), max(case when event_type != 'package_shipped' then created_at_utc else NULL end)
    ) as session_duration,
  sum(iff(event_type = 'page_view', 1, 0)) as total_page_view,
  sum(iff(event_type = 'add_to_cart', 1, 0)) as total_add_to_cart,
  sum(iff(event_type = 'checkout', 1, 0)) as total_checkout,
  sum(iff(event_type = 'package_shipped', 1, 0)) as total_package_shipped
FROM {{ ref('stg_events') }}
GROUP BY 1, 2
