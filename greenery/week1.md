1) How many users do we have? 130

## Query ##
select
  count(distinct user_id)
from stg_users;

2) On average, how many orders do we receive per hour? 15 orders per hour

## Query ##
-- Creating a CTE to get the # of order per hour --
with cte_order as (
  select
    hour(created_at) as hour,
    count(distinct order_id) as order_count
  from stg_orders
  group by 1
)

-- Getting the average order count--
select
  avg(order_count) as avg_order_count
from cte_order;

3) On average, how long does an order take from being placed to being delivered? 4 days (Rounding off from 3.89)

## Query ##
select
  avg(datediff(day,created_at, delivered_at)) as day_diff
from stg_orders
where delivered_at is not null;

4) How many users have only made one purchase? Two purchases? Three+ purchases?
One purchase: 25
Two purchases: 28
Three+ purchases: 71

Note: you should consider a purchase to be a single order. In other words, if a user places one order for 3 products, they are considered to have made 1 purchase.

## Query ##
-- Creating a CTE to group the user based on their number of order --
with cte_order_num as (
  select
    user_id,
    case
      when count(order_id) = 1
        then 'one_purchase'
      when count(order_id) = 2
        then 'two_purchase'
      when count(order_id) >= 3
        then 'three_and_more_purchase'
      else null
    end as num_of_order,
    count(order_id) as order_count
  from stg_orders
  group by 1
)

-- Getting the count of user per order group --
select
  num_of_order,
  count(user_id)
from cte_order_num
group by 1;

5) On average, how many unique sessions do we have per hour? 39 unique sessions

## Query ##

-- Creating a CTE to get the # of unique session per hour --
with cte_session as (
  select
    hour(created_at) as hour,
    count(distinct session_id) as count_unique_session
  from stg_events
  group by 1
)

-- Getting the average unique session --
select
  avg(count_unique_session) as avg_unique_session
from cte_session;