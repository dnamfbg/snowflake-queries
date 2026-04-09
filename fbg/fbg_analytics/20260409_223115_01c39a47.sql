-- Query ID: 01c39a47-0212-67a9-24dd-07031944bcbb
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:31:15.108000+00:00
-- Elapsed: 856ms
-- Environment: FBG

SELECT "Custom SQL Query4"."ACCO_ID" AS "ACCO_ID (Custom SQL Query4)"
FROM (
  select
  acco_id,
  to_date(LEFT(b.createddate, 10)) AS created_date
  from fbg_analytics.product_and_customer.fast_track_attribute a
  inner join FBG_SOURCE.SALESFORCE.O_ACCOUNT b on to_varchar(a.acco_id) = to_varchar(b.amelco_account__c)
) "Custom SQL Query4"
