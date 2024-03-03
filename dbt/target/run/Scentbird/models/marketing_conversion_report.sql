
  
    

  create  table "postgres"."public_nandrianova"."marketing_conversion_report__dbt_tmp"
  
  
    as
  
  (
    

WITH pre_t AS (SELECT ev.id          AS event_id
                    , ev.user_id     AS user_id
                    , ev.created_at  AS event_created_at
                    , ev.event_name  AS event_name
                    , ord.id         AS order_id
                    , ord.amount     AS order_amount
                    , ord.created_at AS order_created_at
               FROM "postgres"."public_exercises"."events" ev
                        LEFT JOIN "postgres"."public_exercises"."orders" ord
               ON ev.user_id = ord.user_id
                   AND (ord.created_at - ev.created_at) <= INTERVAL '24 hour'
               WHERE 1 = 1
                 AND event_name = 'AdvertisingCampaignSet')
SELECT event_name                                  AS campaign_name
     , DATE_TRUNC('month', event_created_at)::date AS report_date
     , SUM(order_amount)                           AS total_revenue
FROM pre_t
GROUP BY campaign_name, report_date
  );
  