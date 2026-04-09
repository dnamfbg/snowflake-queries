-- Query ID: 01c39a47-0212-6dbe-24dd-070319447deb
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:31:18.741000+00:00
-- Elapsed: 39845ms
-- Environment: FBG

SELECT "Custom SQL Query"."Last Updated (EST)" AS "Last Updated (EST)",
  "Custom SQL Query"."MANAGER" AS "MANAGER",
  "Custom SQL Query"."MONTH" AS "MONTH",
  "Custom SQL Query"."NAME" AS "NAME",
  "Custom SQL Query"."OC_ACTUAL_COST" AS "OC_ACTUAL_COST",
  "Custom SQL Query"."OC_BUDGET" AS "OC_BUDGET",
  "Custom SQL Query"."OC_THEO_COST" AS "OC_THEO_COST",
  "Custom SQL Query"."ORG" AS "ORG",
  "Custom SQL Query"."SBK_ACTUAL_COST" AS "SBK_ACTUAL_COST",
  "Custom SQL Query"."SBK_BUDGET" AS "SBK_BUDGET",
  "Custom SQL Query"."SBK_THEO_COST" AS "SBK_THEO_COST",
  "Custom SQL Query"."SR_MANAGER" AS "SR_MANAGER",
  "Custom SQL Query"."TEAM" AS "TEAM"
FROM (
  with sbk as(
  select
  'sbk' as product,
  date(a.month) as month,
  CASE WHEN sd.acco_id is not null THEN 'Standing Deal'
       ELSE COALESCE(c.vip_host, c.lead_owner, cm.lead_owner, 'Other')
  END as name,
  CASE WHEN z.acco_id IS NOT NULL THEN 'Business Relationships'
       WHEN ("Bonus Category" IN ('Acquisition', 'CS Acquisition') OR "SubCategory" = 'Migration') THEN 'Acquisition'
       WHEN ("Bonus Category" in ('Retention') and "SubCategory" = 'FanCash 5/3/1') THEN 'Baseline'
       WHEN ("Bonus Category" in ('Lifecycle')) THEN 'Lifecycle'
       WHEN ("Bonus Category" in ('Retention') and "SubCategory" = 'Direct') THEN 'Direct'
       WHEN ("Bonus Category" in ('Retention', 'CS Retention') and ("SubCategory" ilike '%VIP%' or "SubCategory" = 'Conversion') and sd.acco_id is null) THEN 'VIP Host Spend'
       WHEN ("Bonus Category" in ('Retention', 'CS Retention') and ("SubCategory" ilike '%VIP%' or "SubCategory" = 'Conversion') and sd.acco_id is not null) THEN 'VIP Standing Deals'
       WHEN ("SubCategory" = 'Gauntlet') THEN 'Fast Track'
       WHEN ("Bonus Category" = 'Retention' and "SubCategory" = 'FanCash Drop') THEN 'FC Drop'
       WHEN ("Bonus Category" in ('Retention', 'CS Retention') and "SubCategory" ilike '%Fanatics ONE%') THEN 'Fanatics ONE'
       WHEN ("Bonus Category" in ('Retention', 'CS Retention') and "SubCategory" = 'GDG') THEN 'GDG'
       WHEN ("Bonus Category" in ('Retention', 'CS Retention') and "SubCategory" = 'F1 Deposit Matches') THEN 'F1 Deposit Matches'
       WHEN ("Bonus Category" in ('Retention', 'CS Retention') and "SubCategory" = 'FanCash Multipliers') THEN 'FC Multipliers'
       ELSE 'Other'
  END as bonus_category,
  sum(case when transaction = 'bonus awarded' and promo_type = 'cash_back' THEN amount
           when transaction = 'bonus awarded' and promo_type = 'fancash' THEN amount * COALESCE(fc.fc_cost_factor,.6)
           when transaction = 'bonus awarded' and promo_type not in ('cash_back', 'fancash') THEN amount*.64
           else 0 end) as sbk_theo_cost,
  sum(case when "SubCategory" != 'Cashout' and transaction = 'bonus winnings' then amount else 0 end) as sbk_actual_cost
  from FBG_P13N.PROMO_SILVER_TABLE.PROMOTIONS_LEDGER_FINAL as a
  left join fbg_analytics.vip.vip_standing_deals as sd
      on a.acco_id = sd.acco_id
  left join fbg_analytics.vip.vip_host_lead_historical as c
      on a.acco_id = c.acco_id
      and date(a.date) = c.as_of_date
  left join fbg_analytics_engineering.customers.customer_mart cm
      on a.acco_id = cm.acco_id
  LEFT JOIN fbg_analytics.vip.business_relations_users z
      on z.acco_id = a.acco_id
  left join fbg_analytics.product_and_customer.fancash_burn_distribution fc
      on a.acco_id = fc.acco_id
  where 1=1
  and date(a.month) >= '2025-10-01'
  and a.promo_type not in ('boost_market', 'profit_boost')
  and bonus_category in ('VIP Host Spend', 'VIP Standing Deals')
  and transaction in ('bonus awarded', 'bonus winnings')
  group by all
  ),
  
  casino as(
  select
  'casino' as product,
  date(a.month) as month,
  CASE WHEN sd.acco_id is not null THEN 'Standing Deal'
       ELSE COALESCE(c.vip_host, c.lead_owner, cm.lead_owner, 'Other')
  END as name,
  CASE WHEN z.acco_id IS NOT NULL THEN 'Business Relationships'
       WHEN ("Bonus Category" in ('Acquisition', 'CS Acquisition') or "SubCategory" = 'Migration') THEN 'Acquisition'
       WHEN "Bonus Category" in ('Retention') and "SubCategory" ilike '%Headline%' THEN 'Headline'
       WHEN "Bonus Category" in ('Retention') and "SubCategory" = 'FanCash 5/3/1' THEN 'Baseline'
       WHEN "Bonus Category" in ('Lifecycle') THEN 'Lifecycle'
       WHEN "Bonus Category" in ('Retention') and "SubCategory" = 'Direct' THEN 'Direct'
       WHEN "Bonus Category" in ('Retention', 'CS Retention') and ("SubCategory" ilike '%VIP%' or "SubCategory" = 'Conversion') and sd.acco_id is null THEN 'VIP Host Spend'
       WHEN "Bonus Category" in ('Retention', 'CS Retention') and ("SubCategory" ilike '%VIP%' or "SubCategory" = 'Conversion') and sd.acco_id is not null THEN 'VIP Standing Deals'
       WHEN ("SubCategory" = 'Gauntlet') THEN 'Fast Track'
       WHEN "Bonus Category" = 'Retention' and "SubCategory" = 'FanCash Drop' THEN 'FC_Drop'
       WHEN ("Bonus Category" = 'CS Retention' and "SubCategory" not ilike '%VIP%' and "SubCategory" not in ('Gauntlet', 'Conversion')) or ("Bonus Category" = 'Retention' and "SubCategory" ilike '%P1%') THEN 'CS'
       ELSE 'Other'
  END as bonus_category,
  sum(case when transaction = 'bonus awarded' and promo_type = 'cash_back' THEN amount
           when transaction = 'bonus awarded' and promo_type = 'fancash' THEN amount * COALESCE(fc.fc_cost_factor,.6)
           when transaction = 'bonus awarded' and promo_type not in ('cash_back', 'fancash') THEN amount*.64
           else 0 end) as oc_theo_cost,
  sum(case when transaction = 'bonus winnings' then amount else 0 end) as oc_actual_cost
  from fbg_analytics.product_and_customer.casino_promotions_ledger as a
  left join fbg_analytics.vip.vip_standing_deals as sd
      on a.acco_id = sd.acco_id
  inner join fbg_analytics.vip.vip_host_lead_historical as c
      on a.acco_id = c.acco_id
      and date(a.date) = c.as_of_date
  left join fbg_analytics_engineering.customers.customer_mart cm
      on a.acco_id = cm.acco_id
  LEFT JOIN fbg_analytics.vip.business_relations_users z
      on z.acco_id = a.acco_id
  left join fbg_analytics.product_and_customer.fancash_burn_distribution fc
      on a.acco_id = fc.acco_id
  where 1=1
  and date(a.month) >= '2025-10-01'
  and transaction in ('bonus awarded', 'bonus winnings')
  and bonus_category in ('VIP Host Spend', 'VIP Standing Deals')
  group by all
  ),
  
  sbk_staging as(
  select
  CASE WHEN b.name is null then 'Other'
       ELSE b.name
  END as name,
  a.month,
  a.bonus_category,
  sum(sbk_theo_cost) as sbk_theo_cost,
  sum(sbk_actual_cost) as sbk_actual_cost
  
  from sbk a
  left join fbg_analytics.vip.monthly_rtc_budget b
      on a.name = b.name
      and a.month = b.month
  group by all
  ),
  
  oc_staging as(
  select
  CASE WHEN b.name is null then 'Other'
       ELSE b.name
  END as name,
  a.month,
  a.bonus_category,
  sum(oc_theo_cost) as oc_theo_cost,
  sum(oc_actual_cost) as oc_actual_cost
  
  from casino a
  left join fbg_analytics.vip.monthly_rtc_budget b
      on a.name = b.name
      and a.month = b.month
  group by all
  ),
  
  final as(
  select
  convert_timezone('UTC','America/New_York',current_timestamp) as "Last Updated (EST)",
  a.*,
  em.sr_manager,
  COALESCE(b.sbk_theo_cost,0) as sbk_theo_cost,
  COALESCE(b.sbk_actual_cost,0) as sbk_actual_cost,
  COALESCE(c.oc_theo_cost,0) as oc_theo_cost,
  COALESCE(c.oc_actual_cost,0) as oc_actual_cost
  
  from fbg_analytics.vip.monthly_rtc_budget a
  left join fbg_analytics.vip.vip_employee_mapping em
      on a.name = em.name
  left join sbk_staging b
      on a.name = b.name
      and a.month = b.month
  left join oc_staging c
      on a.name = c.name
      and a.month = c.month
  )
  select * from final
) "Custom SQL Query"
