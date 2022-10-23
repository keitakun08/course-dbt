{{
  config(
    materialized='table'
  )
}}

with cte_products as (
  select *
  from {{ ref('stg_products')}}
)

select *
from cte_products
