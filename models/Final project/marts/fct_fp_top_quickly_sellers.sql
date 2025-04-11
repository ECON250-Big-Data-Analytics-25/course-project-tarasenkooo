with sellerss as (
    select
        seller_id,
        days_to_deliver,
        total_item_value
    from {{ ref('int_fp_sales_full') }},
    unnest(seller_ids) as seller_id
    where is_delivered = true
)

select
    seller_id,
    count(*) as total_orders,
    round(avg(days_to_deliver), 2) as avg_delivery_days,
    round(sum(total_item_value), 2) as total_revenue
from sellerss
group by seller_id
order by avg_delivery_days
limit 10

