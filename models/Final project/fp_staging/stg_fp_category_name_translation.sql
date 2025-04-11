{{ config(materialized='view') }}

SELECT 
    string_field_0 as product_category_name,
    string_field_1 as product_category_name_english
    
FROM  {{ source('ttarasenko', 'fp_category_name_translation') }} 
