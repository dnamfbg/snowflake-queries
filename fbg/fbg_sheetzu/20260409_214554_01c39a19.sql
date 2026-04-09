-- Query ID: 01c39a19-0212-67a8-24dd-0703193a9ce3
-- Database: FBG_SHEETZU
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:45:54.126000+00:00
-- Elapsed: 11436ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."CAMPAIGN" AS "CAMPAIGN",
  "Custom SQL Query"."CAMPAIGN_TIER" AS "CAMPAIGN_TIER",
  "Custom SQL Query"."CARRIER" AS "CARRIER",
  "Custom SQL Query"."CASH_ACTIVES" AS "CASH_ACTIVES",
  "Custom SQL Query"."CASH_EGGR" AS "CASH_EGGR",
  "Custom SQL Query"."CASH_HANDLE" AS "CASH_HANDLE",
  "Custom SQL Query"."DATE" AS "DATE",
  "Custom SQL Query"."DW_LAST_UPDATED" AS "DW_LAST_UPDATED",
  "Custom SQL Query"."EXPECTED_DELIVERY" AS "EXPECTED_DELIVERY",
  "Custom SQL Query"."FINANCE_ENGR" AS "FINANCE_ENGR",
  "Custom SQL Query"."FINANCE_NGR" AS "FINANCE_NGR",
  "Custom SQL Query"."GIFT_TYPE" AS "GIFT_TYPE",
  "Custom SQL Query"."LOYALTY_TIER" AS "LOYALTY_TIER",
  TRY_CAST("Custom SQL Query"."ORDER_DATE" AS DATE) AS "ORDER_DATE",
  "Custom SQL Query"."POINTS_TIER" AS "POINTS_TIER",
  "Custom SQL Query"."PRODUCT_DESCRIPTION" AS "PRODUCT_DESCRIPTION",
  "Custom SQL Query"."PRODUCT_PREFERENCE" AS "PRODUCT_PREFERENCE",
  "Custom SQL Query"."QUANTITY" AS "QUANTITY",
  "Custom SQL Query"."REAL_GIFT_COST" AS "REAL_GIFT_COST",
  "Custom SQL Query"."RETAIL_GIFT_COST" AS "RETAIL_GIFT_COST",
  "Custom SQL Query"."SENDER" AS "SENDER",
  "Custom SQL Query"."SEND_DATE" AS "SEND_DATE",
  "Custom SQL Query"."SEND_TASK" AS "SEND_TASK",
  "Custom SQL Query"."TRACKING" AS "TRACKING",
  "Custom SQL Query"."TYPE" AS "TYPE",
  "Custom SQL Query"."VIP_HOST" AS "VIP_HOST",
  "Custom SQL Query"."VIP_STATUS" AS "VIP_STATUS"
FROM (
  SELECT
      a.*,
      b.loyalty_tier,
      b.points_tier,
      CASE
        WHEN COALESCE(d.is_vip, FALSE)
          OR COALESCE(d.is_casino_vip, FALSE)
          OR d.vip_host IS NOT NULL
        THEN 'vip' ELSE 'not vip'
      END AS vip_status,
      d.vip_host,
      e.product_preference,
      cash_actives,
      cash_handle,
      finance_engr,
      finance_ngr,
      cash_eggr
  FROM "FBG_SHEETZU"."DEFAULT"."LOYALTY_GIFTING_TRACKER" a
  INNER JOIN fbg_analytics.product_and_customer.f1_attributes b 
    ON a.acco_id = TO_VARCHAR(b.acco_id)
  LEFT JOIN (
    SELECT
      acco_id,
      count(distinct case when coalesce(osb_cash_handle,0) > 0 then a.acco_id else null end) as cash_actives,
      sum(coalesce(osb_cash_handle,0)) as cash_handle,
      sum(coalesce(osb_finance_engr,0)) as finance_engr,
      sum(coalesce(osb_finance_ngr,0)) as finance_ngr,
      sum(coalesce(osb_cash_eggr,0)) as cash_eggr
    FROM fbg_analytics.product_and_customer.customer_variable_profit as a
      where 1=1
      --and c.is_test_account = FALSE
      and a.date >= '2025-01-01'
  group by all
  ) w
    ON a.acco_id = TO_VARCHAR(cast(w.acco_id as integer))
  LEFT JOIN fbg_analytics_engineering.customers.customer_mart d
    ON a.acco_id = TO_VARCHAR(d.acco_id)
  inner join FBG_ANALYTICS.VIP.VIP_USER_INFO e 
      on a.acco_id = TO_VARCHAR(e.acco_id)
  --where finance_engr < 0
) "Custom SQL Query"
