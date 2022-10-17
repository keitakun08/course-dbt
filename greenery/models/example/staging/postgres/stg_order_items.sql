{{
  config(
    materialized='table'
  )
}}

SELECT
  order_id,
  product_id,
  quantity as order_quantity
FROM {{ source('postgres', 'order_items') }}
