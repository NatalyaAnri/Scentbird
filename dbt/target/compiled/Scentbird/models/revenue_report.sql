

select date_trunc('month', created_at)::date as report_date
     , sum(amount)                           as total_amount
from "postgres"."public_exercises"."orders"
group by report_date