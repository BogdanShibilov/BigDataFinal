{{config(materialized='table')}}

with daily_symptomes as(
    select *,
        'daily' as type 
    from {{ ref('stg_daily_symptomes') }}
),
weekly_symptomes as(
    select *,
        'weekly' as type  
    from {{ ref('stg_weekly_symptomes') }}
),
unioned_data as (
    select * from daily_symptomes
    union all 
    select * from weekly_symptomes
)

select * from unioned_data