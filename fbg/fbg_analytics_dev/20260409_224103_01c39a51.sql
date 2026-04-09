-- Query ID: 01c39a51-0212-67a9-24dd-07031946bd8f
-- Database: FBG_ANALYTICS_DEV
-- Schema: DANIEL_RUSTICO
-- Warehouse: BI_SM_WH
-- Executed: 2026-04-09T22:41:03.574000+00:00
-- Elapsed: 221ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."AMOUNT_DEPOSITED" AS "AMOUNT_DEPOSITED",
  "Custom SQL Query"."DEPOSIT_ID" AS "DEPOSIT_ID",
  "Custom SQL Query"."DEPOSIT_TIME" AS "DEPOSIT_TIME",
  "Custom SQL Query"."DESCRIPTION" AS "DESCRIPTION",
  "Custom SQL Query"."PAYMENT_BRAND" AS "PAYMENT_BRAND",
  "Custom SQL Query"."PSEUDONYM" AS "PSEUDONYM",
  "Custom SQL Query"."STATE" AS "STATE",
  "Custom SQL Query"."VIP" AS "VIP",
  "Custom SQL Query"."VIP_HOST" AS "VIP_HOST"
FROM (
  select a.* from FBG_ANALYTICS_DEV.DANIEL_RUSTICO.big_deposit_alert_100k as a
  left join FBG_ANALYTICS.TRADING.FCT_VALUE_BANDS as b
  on a.acco_id = b.acco_id
  where (b.high_level_segment <> 'Super VIP' or b.high_level_segment is null)
) "Custom SQL Query"
