-- Query ID: 01c39a35-0212-644a-24dd-070319413307
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:13:31.709000+00:00
-- Elapsed: 10527ms
-- Environment: FBG

select ACCOUNT_ID "TopK Value", COUNT_157 "TopK Count", CAST_162 "Text Seach Column" from (select ACCOUNT_ID, COUNT_157, ACCOUNT_ID::text CAST_162 from (select ACCOUNT_ID, count(1) COUNT_157 from FBG_ANALYTICS.TRADING.USER_AGGREGATED_REPORT_DATASOURCE where contains(lower(ACCOUNT_ID::text), lower('4322147')) group by ACCOUNT_ID) Q1) Q2 order by COUNT_157 desc, ACCOUNT_ID asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/User-Aggregated-Report-2Ldbx1IVdxCU6guEN5hCqp","kind":"adhoc","request-id":"g019d744ec0977866a9163f25ae3e15f3","user-id":"ZF390mND5StXOsyQkAEUqG8havXDi","email":"andy.morrissey@betfanatics.com"}
