-- Query ID: 01c39a09-0212-6dbe-24dd-070319369893
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:29:56.651000+00:00
-- Elapsed: 2367ms
-- Environment: FBG

select ACCOUNT_ID "TopK Value", COUNT_157 "TopK Count", CAST_162 "Text Seach Column" from (select ACCOUNT_ID, COUNT_157, ACCOUNT_ID::text CAST_162 from (select ACCOUNT_ID, count(1) COUNT_157 from FBG_ANALYTICS.TRADING.USER_AGGREGATED_REPORT_DATASOURCE where contains(lower(ACCOUNT_ID::text), lower('31963')) group by ACCOUNT_ID) Q1) Q2 order by COUNT_157 desc, ACCOUNT_ID asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/User-Aggregated-Report-2Ldbx1IVdxCU6guEN5hCqp","kind":"adhoc","request-id":"g019d7426d8b9755395b07e61c9066a3c","user-id":"vmIDr6JeIgfvB7dWYRqc7f8jUv8Ad","email":"jordan.polo@betfanatics.com"}
