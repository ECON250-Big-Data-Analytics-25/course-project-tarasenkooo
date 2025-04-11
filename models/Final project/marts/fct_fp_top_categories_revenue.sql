
with categories as (
  select
    order_id,
    total_item_value,
    category
  from {{ ref('int_fp_sales_full') }},
  unnest(product_category_names_english) as category
)

select
  category,
  count(distinct order_id) as total_orders,
  sum(total_item_value) as total_revenue,
  round(avg(total_item_value), 2) as avg_order_value
from exploded
group by category
order by total_revenue desc
limit 10

