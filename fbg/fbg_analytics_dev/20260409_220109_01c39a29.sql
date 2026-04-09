-- Query ID: 01c39a29-0212-6cb9-24dd-0703193e19c3
-- Database: FBG_ANALYTICS_DEV
-- Schema: PUBLIC
-- Warehouse: TABLEAU_XL_PROD
-- Executed: 2026-04-09T22:01:09.869000+00:00
-- Elapsed: 2704ms
-- Environment: FBG

SELECT "Custom SQL Query"."% of Trustly Volume through Trustly VIP" AS "% of Trustly Volume through Trustly VIP",
  "Custom SQL Query"."TIERDAY" AS "TIERDAY",
  "Custom SQL Query"."TOTALTIEREDVOLUME" AS "TOTALTIEREDVOLUME",
  "Custom SQL Query"."TOTALTRUSTLYVOLUME" AS "TOTALTRUSTLYVOLUME"
FROM (
  with distinct_accounts as (
  select
      distinct account_id
  from fbg_source.osb_source.customer_limit_history
  )
  
  
  ,account_details as (
  select account_id,
      date(convert_timezone('UTC','America/New_York', date)) as date_est,
      max_by(tier_name, date_est) as tier
  from fbg_source.osb_source.customer_limit_history
  group by all
  ),
  
  
  date_tiers as (select d.date_value,
      a.account_id,
      COALESCE(TIER, LAG(TIER) IGNORE NULLS OVER (PARTITION BY a.ACCOUNT_ID ORDER BY DATE_VALUE)) AS TIER
  from fbg_finance.finance_mart.dim_date as d
  cross join distinct_accounts as a
  left join account_details as ad
      on d.date_value = ad.date_est
      and a.account_id = ad.account_id
  where date_value <= CURRENT_DATE()),
  
  
  setup as (select d.*, tier, v.HIGH_LEVEL_SEGMENT, V.CASINO_SEGMENT from 
  fbg_source.osb_source.deposits d
  left join date_tiers l on 
  d.acco_id = l.account_id and date(d.created) = l.date_value
  left join fbg_analytics.product_and_customer.value_bands_historical v 
  on d.acco_id = v.acco_id  and to_date(d.created) = v.as_of_date 
   where status = 'DEPOSIT_SUCCESS' and payment_brand not in ('TERMINAL','CASHATCAGE','PAYSAFECASH')  order by created desc),
  
  final as(
  select date_trunc('day',created) as daterange,
  sum(amount) as totalvolume,
  sum(Case when payment_brand in ('TRUSTLY') then amount end) as totalTrustlyVolume,
  sum(case when payment_brand = 'TRUSTLY' and tier in ('trustly_vip_tier_1','trustly_vip_tier_2','trustly_vip_tier_3','trustly_vip_tier_4','trustly_vip_tier_5','trustly_vip_tier_99','trustly_vip_tier_0')then amount end) as totaltieredvolume,
  totaltieredvolume/totalvolume as "% of Volume through Trustly VIP",
  totaltieredvolume/totalTrustlyVolume as "% of Trustly Volume through Trustly VIP",
  sum(case when high_level_segment in ('VIP','Top VIP') or CASINO_SEGMENT in ('Ace','King') then amount end ) as totalvipvolume, 
  sum(case when payment_brand in ('TRUSTLY') and (high_level_segment in ('VIP','Top VIP') or CASINO_SEGMENT in ('Ace','King')) then amount end )  as totalviptrustlyvolume,
  sum(case when payment_brand in ('TRUSTLY') and (high_level_segment in ('VIP','Top VIP') or CASINO_SEGMENT in ('Ace','King')) and (tier in ('trustly_vip_tier_1','trustly_vip_tier_2','trustly_vip_tier_3','trustly_vip_tier_4','trustly_vip_tier_5','trustly_vip_tier_99','trustly_vip_tier_0')) then amount end) as totalviptrustlytieredvolume,
  totalviptrustlytieredvolume/totalvipvolume as "% of VIP Volume through Trustly VIP",
  totalviptrustlytieredvolume/totalviptrustlyvolume as "% of VIP Trustly Volume through Trustly VIP",
  from setup
  where to_date(created) > DATEADD(DAY,-15,current_date) and to_date(created) <> current_date
  group by all
  order by daterange asc)
  
  select to_date(daterange) as tierday, totaltrustlyvolume, totaltieredvolume, "% of Trustly Volume through Trustly VIP"
  from final
  order by daterange asc
) "Custom SQL Query"
