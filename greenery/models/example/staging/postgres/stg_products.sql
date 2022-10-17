{{
  config(
    materialized='table'
  )
}}

SELECT
  product_id,
  name,
  price as product_price,
  inventory
FROM {{ source('postgres', 'products') }}
