{{
  config(
    materialized='table'
  )
}}

WITH cte_products as (
  select *
  from {{ ref('dim_products') }}
),

cte_product_details AS (
  SELECT
    p.product_id,
    p.product_name,
    p.product_price,
    p.product_inventory as total_product_inventory,
    count(oi.order_quantity) as total_product_order,
    total_product_inventory - total_product_order as current_inventory_count,
    iff(current_inventory_count < 10, true, false) as need_restock,
    p.product_price * total_product_order as product_gross_revenue
  FROM cte_products as p
  LEFT JOIN {{ ref('stg_order_items') }} as oi
    ON p.product_id = oi.product_id
  GROUP BY 1, 2, 3, 4
),

cte_product_events as (
  SELECT
    p.product_id,
    sum(case when event_type = 'page_view' then 1 else 0 end) as total_product_page_view_count,
    sum(case when event_type = 'add_to_cart' then 1 else 0 end) as total_product_add_to_cart_count,
    div0(total_product_add_to_cart_count, total_product_page_view_count) as add_to_cart_rate
  FROM cte_products as p
  LEFT JOIN {{ ref('stg_events') }} as e
    ON p.product_id = e.product_id
    AND e.product_id is not null
  GROUP BY 1
),

cte_final as (
  select
    pd.product_id,
    pd.product_name,
    pd.product_price,
    pd.total_product_inventory,
    pd.total_product_order,
    pd.current_inventory_count,
    pd.need_restock,
    pd.product_gross_revenue,
    pe.total_product_page_view_count,
    pe.total_product_add_to_cart_count,
    pe.add_to_cart_rate
  from cte_product_details as pd
  left join cte_product_events as pe
    on pd.product_id = pe.product_id
)

select *
from cte_final
