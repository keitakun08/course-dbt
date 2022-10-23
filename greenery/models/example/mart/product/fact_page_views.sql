{{
  config(
    materialized='table'
  )
}}

WITH cte_user as (
  select *
  from {{ ref('int_user_addresses') }}
),

cte_page_views as (
  select
    ue.session_id,
    ue.user_id,
    u.first_name,
    u.last_name,
    ue.total_page_view,
    ue.total_add_to_cart,
    ue.total_checkout,
    ue.total_package_shipped,
    ue.first_session_created_at as first_session_event,
    ue.latest_session_created_at as last_session_event,
    datediff('minute', first_session_event, last_session_event) as session_length_minutes
  from {{ ref('int_user_events')}} as ue
  left join cte_user as u
    on ue.user_id = u.user_id
)

SELECT *
from cte_page_views
