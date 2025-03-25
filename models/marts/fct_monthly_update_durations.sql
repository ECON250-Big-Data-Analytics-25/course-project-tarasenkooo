
{{ config(materialized = 'table') }}

SELECT 
publish_month,
round(avg(days_until_updated)) as avg_update_period_total,
round(avg(if(is_updated = 1, days_until_updated, null))) as avg_update_period
FROM {{ ref("int_arxiv_duration_llm") }}
 -- where is_updated = 1
group by 1