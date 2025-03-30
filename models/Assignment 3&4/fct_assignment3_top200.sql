{{ config(materialized='table') }}

with top_200 as(
    select title,
    sum(views) as total_views,
    sum(case when src = 'mobile' then views else 0 end) as total_mobile_views
    from {{ ref('int_assignment3_uk_wiki') }}
    where not is_meta_page
    group by title
    order by total_views desc
    limit 200
)

select
  *,
  round((total_mobile_views / total_views) * 100, 2) as mobile_percentage
from top_200
order by mobile_percentage asc