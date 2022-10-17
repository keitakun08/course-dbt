1) What is our user repeat rate?
Definition: Users who purchased 2 or more times / users who purchased

```
-- CTE to get count of distinct order for each user --
with cte_purchased_users as (
  select
    user_id,
    count(distinct order_id) as user_order_count
  from stg_orders
  group by 1
),

-- Creating a tag for user who did 2 or more orders --
cte_multiple_orders as (
  select
    user_id,
    (user_order_count = 1)::integer as one_purchase,
    (user_order_count >= 2)::integer as two_or_more_purchase
  from cte_purchased_users
)

-- Calculating repeat rate --
select
  count(distinct user_id) as total_user_count,
  sum(two_or_more_purchase) as multiple_order_user,
  div0(multiple_order_user, total_user_count) as repeat_rate
from cte_multiple_orders;
```

2) What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?
   Some high-level things that matters on e-commerce user experience is
   - how long they spend on the website
   - the length of the delivery
   - the length of the user spending on each stage (from add to cart -> checkout -> packaghe shipped)
   - the # of time they apply promo on their purchase
   - the $ amount of their order
   
   An analysis that I would like to conduct would be funnel analysis. With this analysis, we can see their behaviour on each stage (page views, checkout, add to cart) and create multiple user persona. For example. if a user has a high number of page views but they never have a low conversion rate on checkout stage, we can assume that the user won't purchase anything. If a user has a high conversion rate from checkout to package shipped, we can assume that this user will likely to come back and purchase again

3) Within each marts folder, create intermediate models and dimension/fact models.
For my setup, I have decided to create separate schema for intermediate and mart. I'm aware tha it is recommended to create intermediate folder inside mart but here's my reasoning:

From my understanding, intermediate is a layer that involves heavy data transformation for a specific logic so instead of living in different mart, gathering them into one place makes more sense to me. Also I believe I can re-use intermediate models with different tables in different schema in mart.

4) What assumptions are you making about each model? (i.e. why are you adding each test?)
For now, I'm only adding primary key test (not null and unique) to the staging model due to time constraint.

5) Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?

None so far

dbt snapshot

6) Which orders changed from week 1 to week 2? 

Order ID
'05202733-0e17-4726-97c2-0520c024ab85' 
'914b8929-e04a-40f8-86ee-357f2be3a2a2' 
'939767ac-357a-4bec-91f8-a7b25edd46c9'
