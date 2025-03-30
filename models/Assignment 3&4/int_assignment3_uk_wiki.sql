{{ config(materialized='view') }}

select
    *,
    case when regexp_extract(title, r'^([^:]+):') in (
            'Категорія', 'Файл', 'Вікіпедія', 'Шаблон', 'Користувач', 
            'Портал', 'Обговорення_користувача', 'Спеціальна', 'Обговорення', 'Довідка'
        ) then true
        else false
    end as is_meta_page,

    case when regexp_extract(title, r'^([^:]+):') in (
            'Категорія', 'Файл', 'Вікіпедія', 'Шаблон', 'Користувач', 'Портал', 
            'Обговорення_користувача', 'Спеціальна', 'Обговорення', 'Довідка'
        ) then regexp_extract(title, r'^([^:]+):')
        else null
    end as meta_page_type

from {{ ref("stg_assignment3_uk_wiki") }}