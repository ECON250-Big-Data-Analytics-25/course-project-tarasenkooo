{{ config(materialized='view') }}

with both_tables as (
    select 
    'desktop' as src,
    *
    from {{ source("test_dataset", "assignment3_input_uk") }} 

    union all

    select
    'mobile' as src,
    *
    from {{ source("test_dataset", "assignment3_input_uk_m") }}
)


select *,
date(datehour) as date,
case
    when extract(dayofweek from datehour) = 1 then 7
    else extract(dayofweek from datehour) - 1
end as day_of_week,
extract(hour from datehour) as hour_of_day

 from both_tables