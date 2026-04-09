-- Query ID: 01c399f4-0212-6dbe-24dd-070319318b77
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:08:19.773000+00:00
-- Elapsed: 2822ms
-- Environment: FBG

select ACCOUNT_ID "TopK Value", COUNT_157 "TopK Count", CAST_162 "Text Seach Column" from (select ACCOUNT_ID, COUNT_157, ACCOUNT_ID::text CAST_162 from (select ACCOUNT_ID, count(1) COUNT_157 from FBG_ANALYTICS.TRADING.USER_AGGREGATED_REPORT_DATASOURCE where contains(lower(ACCOUNT_ID::text), lower('1482897')) group by ACCOUNT_ID) Q1) Q2 order by COUNT_157 desc, ACCOUNT_ID asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/User-Aggregated-Report-2Ldbx1IVdxCU6guEN5hCqp","kind":"adhoc","request-id":"g019d74130e697d3eb9ec0b64f00762b0","user-id":"5Y1gWd6uJ3TXX6AjyYQE666AwdsMV","email":"owen.brown@betfanatics.com"}
