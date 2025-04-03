with source as (
  select * 
  from {{ source('test_dataset', 'international_top_terms') }}
),

latest_week as (
  select max(week) as max_week from source
),

filtered as (
  select *
  from source, latest_week
  where week >= date_sub(max_week, interval 7 day)
),

ranked as (
  select region_name, term, score,
    week,
    row_number() over ( partition by region_name 
      order by score desc
    ) as rank
  from filtered
)

select * from ranked where rank <= 10


