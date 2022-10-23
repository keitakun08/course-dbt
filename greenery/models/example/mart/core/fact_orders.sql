{{
  config(
    materialized='table'
  )
}}

with cte_orders as (
  SELECT
    o.order_id,
    o.created_at_utc as order_created_at_utc,
    o.order_cost,
    o.shipping_cost,
    o.order_total,
    o.tracking_id,
    o.user_id,
    o.shipping_service,
    o.estimated_delivery_at_utc,
    o.delivered_at_utc,
    datediff('day', o.created_at_utc, o.delivered_at_utc) as delivery_days,
    oi.order_quantity,
    p.promo_id as promo_name,
    coalesce(p.discount, 0) as promo_discount,
    p.promo_status
  FROM {{ ref('stg_orders') }} as o
  LEFT JOIN {{ ref('stg_order_items') }} as oi
    ON o.order_id = oi.order_id
  LEFT JOIN {{ ref('stg_promos') }} as p
    ON o.promo_id = p.promo_id
)

select *
from cte_orders
