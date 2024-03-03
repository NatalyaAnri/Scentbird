
  
    

  create  table "postgres"."public_nandrianova"."deferred_revenue_report__dbt_tmp"
  
  
    as
  
  (
    
with pre_t as (select date_trunc('month', created_at)::date as created_month
                    , date_trunc('month', shipped_at)::date as shipped_month
                    , amount
               from "postgres"."public_exercises"."orders")
select created_month as report_date
     , sum(amount)   as total_amount
from pre_t
where 1 = 1
  and created_month != shipped_month
group by report_date
  );
  