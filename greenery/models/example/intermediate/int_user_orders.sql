{{
  config(
    materialized='table'
  )
}}

WITH cte_user_orders as (
  SELECT
    u.user_id,
    u.first_name,
    u.last_name,
    u.created_at_utc as user_created_at_utc,
    min(o.created_at_utc) as first_order_date_utc,
    min(o.created_at_utc) as latest_order_date_utc,
    case
        when first_order_date_utc is not null
        then 'true'
        else 'false'
    end as have_ordered,
    datediff('day', user_created_at_utc, first_order_date_utc) as days_to_first_order,
    sum(o.order_cost) as total_gross_order_amount,
    sum(o.shipping_cost) as total_shipping_amount,
    sum(o.order_total) as total_net_order_amount,
    sum(oi.order_quantity) as total_order_quantity
  FROM {{ ref('stg_users') }} as u
  LEFT JOIN {{ ref('stg_orders') }} as o
    ON u.user_id = o.user_id
  LEFT JOIN {{ ref('stg_order_items') }} as oi
    ON o.order_id = oi.order_id
  GROUP BY 1, 2, 3, 4
)

select *
from cte_user_orders
