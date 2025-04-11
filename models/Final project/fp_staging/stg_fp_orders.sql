
{{ config(materialized='view') }}

SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    order_status = 'delivered' as is_delivered,

    date_diff(order_delivered_customer_date, order_purchase_timestamp, day) as days_to_deliver,
    date_diff(order_approved_at, order_purchase_timestamp, day) as days_to_approve,
    date_diff(order_delivered_customer_date, order_estimated_delivery_date, day) as delivery_delay


FROM  {{ source('ttarasenko', 'fp_orders') }} 