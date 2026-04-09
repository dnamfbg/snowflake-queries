-- Query ID: 01c39a42-0212-6cb9-24dd-07031943d557
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:26:32.118000+00:00
-- Elapsed: 1814ms
-- Environment: FBG

select ACCOUNT_ID "TopK Value", COUNT_157 "TopK Count", CAST_162 "Text Seach Column" from (select *, ACCOUNT_ID::text CAST_162 from (select ACCOUNT_ID, count(1) COUNT_157 from FBG_ANALYTICS.TRADING.USER_AGGREGATED_REPORT_DATASOURCE where BET_TYPE = 'Single' and contains(lower(ACCOUNT_ID::text), lower('5661050')) group by ACCOUNT_ID) Q1) Q2 order by COUNT_157 desc, ACCOUNT_ID asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/User-Aggregated-Report-2Ldbx1IVdxCU6guEN5hCqp","kind":"adhoc","request-id":"g019d745ae9d670abab7ab1ae1e7ff7e7","user-id":"Q865QMSIDojkW21Ng6YL94Hp7BeVK","email":"owen.wright@betfanatics.com"}
