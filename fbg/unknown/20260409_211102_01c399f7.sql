-- Query ID: 01c399f7-0212-6cb9-24dd-07031932851f
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:11:02.333000+00:00
-- Elapsed: 2532ms
-- Environment: FBG

select ACCOUNT_ID "TopK Value", COUNT_157 "TopK Count", CAST_162 "Text Seach Column" from (select ACCOUNT_ID, COUNT_157, ACCOUNT_ID::text CAST_162 from (select ACCOUNT_ID, count(1) COUNT_157 from FBG_ANALYTICS.TRADING.USER_AGGREGATED_REPORT_DATASOURCE where contains(lower(ACCOUNT_ID::text), lower('6512554')) group by ACCOUNT_ID) Q1) Q2 order by COUNT_157 desc, ACCOUNT_ID asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/User-Aggregated-Report-2Ldbx1IVdxCU6guEN5hCqp","kind":"adhoc","request-id":"g019d741587ce7d0e93a31735b1b9439a","user-id":"aeL4H6No1lRpjKKr7lyoS9BWG9kDl","email":"Zach.Hughes@betfanatics.com"}
