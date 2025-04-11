select
    extract(MONTH from order_purchase_timestamp) as month,
    count(*) as total_orders,
    sum(total_item_value) as total_revenue,
    sum(total_items) as total_items_sold,
    round(avg(total_item_value), 2) as avg_order_value
from {{ ref('int_fp_sales_full') }}
group by month
order by month
