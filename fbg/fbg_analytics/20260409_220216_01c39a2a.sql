-- Query ID: 01c39a2a-0212-6cb9-24dd-0703193e7693
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:02:16.083000+00:00
-- Elapsed: 832ms
-- Environment: FBG

SELECT TRY_CAST("Custom SQL Query3"."ACCOUNT_PROJECTED_VALUE_NGR__C" AS INT) AS "ACCOUNT_PROJECTED_VALUE_NGR__C",
  "Custom SQL Query3"."ACCO_ID" AS "ACCO_ID (Custom SQL Query3)",
  "Custom SQL Query3"."AMELCO_ACCOUNT__C" AS "AMELCO_ACCOUNT__C"
FROM (
  select
  b.acco_id,
  amelco_account__c,
  b.account_projected_value_ngr__c
  from  FBG_SOURCE.SALESFORCE.O_ACCOUNT a
  inner join fbg_analytics.product_and_customer.status_match b
      on a.amelco_account__c = to_varchar(b.acco_id)
) "Custom SQL Query3"
