{{ config(
    materialized="table"
) }}

select date_trunc('month', created_at)::date as report_date
     , sum(amount)                           as total_amount
from {{source('public_exercises_table', 'orders')}}
group by report_date
