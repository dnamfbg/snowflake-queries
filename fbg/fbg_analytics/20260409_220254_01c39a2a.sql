-- Query ID: 01c39a2a-0212-6e7d-24dd-0703193e93df
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:02:54.977000+00:00
-- Elapsed: 3564ms
-- Environment: FBG

SELECT "Custom SQL Query4"."ACCO_ID" AS "ACCO_ID (Custom SQL Query4)",
  "Custom SQL Query4"."CREATED_DATE" AS "CREATED_DATE"
FROM (
  select
  acco_id,
  to_date(LEFT(b.createddate, 10)) AS created_date
  from fbg_analytics.product_and_customer.fast_track_attribute a
  inner join FBG_SOURCE.SALESFORCE.O_ACCOUNT b on to_varchar(a.acco_id) = to_varchar(b.amelco_account__c)
) "Custom SQL Query4"
