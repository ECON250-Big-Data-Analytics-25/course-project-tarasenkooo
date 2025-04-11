
{{ config(materialized='view') }}

SELECT
  customer_id,
  customer_unique_id,
  customer_zip_code_prefix,
  lower(customer_city) as customer_city,
  lower(customer_state) as customer_state,

FROM  {{ source('ttarasenko', 'fp_customers') }} 