-- Query ID: 01c399ca-0212-6b00-24dd-07031928842f
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:26:45.191000+00:00
-- Elapsed: 2625ms
-- Environment: FBG

select ACCOUNT_ID "TopK Value", COUNT_157 "TopK Count", CAST_162 "Text Seach Column" from (select ACCOUNT_ID, COUNT_157, ACCOUNT_ID::text CAST_162 from (select ACCOUNT_ID, count(1) COUNT_157 from FBG_ANALYTICS.TRADING.USER_AGGREGATED_REPORT_DATASOURCE where contains(lower(ACCOUNT_ID::text), lower('934937')) group by ACCOUNT_ID) Q1) Q2 order by COUNT_157 desc, ACCOUNT_ID asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/User-Aggregated-Report-2Ldbx1IVdxCU6guEN5hCqp","kind":"adhoc","request-id":"g019d73ecf5e77cdaa3096bda7f5ba5c1","user-id":"5Y1gWd6uJ3TXX6AjyYQE666AwdsMV","email":"owen.brown@betfanatics.com"}
