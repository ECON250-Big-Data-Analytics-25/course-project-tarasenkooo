
{{ config(
    materialized='table',
    partition_by={
        "field": "order_purchase_timestamp",
        "data_type": "timestamp"
    },
    cluster_by=["order_status"]
) }}

with orders as (
    select * from {{ ref('stg_fp_orders') }}
),

payments as (
    select
        order_id,
        sum(payment_value) as total_payment,
        count(*) as payment_count,
        array_agg(distinct payment_type) as payment_methods,
    from {{ ref('stg_fp_order_payments') }}
    group by order_id
),

customers as (
    select * from {{ ref('stg_fp_customers') }}
),

order_items as (
    select
        oi.order_id,
        sum(oi.price) as total_price,
        sum(oi.freight_value) as total_freight,
        sum(oi.price + oi.freight_value) as total_item_value,  
        count(*) as total_items,
        array_agg(distinct oi.product_id) as product_ids,
        array_agg(distinct oi.seller_id) as seller_ids,
        array_agg(distinct ct.product_category_name_english ignore nulls) as product_category_names_english
    from {{ ref('stg_fp_order_items') }} oi
    left join {{ ref('stg_fp_products') }} p using(product_id)
    left join {{ ref('stg_fp_category_name_translation') }} ct using(product_category_name)
    group by oi.order_id
)



select
    o.*,
    c.customer_unique_id,
    c.customer_zip_code_prefix,
    c.customer_city,
    c.customer_state,
    p.total_payment,
    p.payment_count,
    p.payment_methods,
    oi.total_price,
    oi.total_freight,
    oi.total_item_value,  
    oi.total_items,
    oi.product_ids,
    oi.product_category_names_english,
    oi.seller_ids

from orders o
left join payments p using(order_id)
left join customers c using(customer_id)
left join order_items oi using(order_id)
