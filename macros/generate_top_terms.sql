{% macro generate_top_terms(group_by_cols, top_n) %}

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
  select
    {{ group_by_cols | join(', ') }}, term, score, week,
    row_number() over (
      partition by {{ group_by_cols | join(', ') }}
      order by score desc
    ) as rank
  from filtered
)

select * from ranked where rank <= {{ top_n }}

{% endmacro %}




{{ generate_top_terms(['country_name'], 10) }}


{{ generate_top_terms(['region_name'], 10) }}


{{ generate_top_terms(['country_name', 'region_name'], 10) }}







