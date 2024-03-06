{{ config(
    materialized="table"
) }}

WITH dedubles_orders AS (SELECT id
                              , amount
                              , user_id
                              , created_at
                         FROM {{source('public_exercises_table', 'orders')}}
                         GROUP BY id
                                , amount
                                , user_id
                                , created_at)
   , pre_t AS (SELECT ev.id          AS event_id
                    , ev.user_id     AS user_id
                    , ev.created_at  AS event_created_at
                    , ev.params->>'utm_campaign' AS event_name
                    , ord.id         AS order_id
                    , ord.amount     AS order_amount
                    , ord.created_at AS order_created_at
               FROM {{source('public_exercises_table', 'events')}} ev
                        LEFT JOIN dedubles_orders ord
               ON ev.user_id = ord.user_id
                   AND (ord.created_at - ev.created_at) <= INTERVAL '24 hour'
               WHERE 1 = 1
                 AND event_name = 'AdvertisingCampaignSet')
SELECT lower(event_name)                                  AS campaign_name
     , DATE_TRUNC('month', event_created_at)::date AS report_date
     , SUM(order_amount)                           AS total_revenue
FROM pre_t
GROUP BY campaign_name, report_date