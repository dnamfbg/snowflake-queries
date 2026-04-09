-- Query ID: 01c399eb-0212-67a8-24dd-0703192f6313
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:59:52.172000+00:00
-- Elapsed: 596ms
-- Environment: FBG

select CASE_TYPE "TopK Value", COUNT_58 "TopK Count", ISNULL_63 "TopK Null Sort" from (select CASE_TYPE, COUNT_58, CASE_TYPE is null ISNULL_63 from (select CASE_TYPE, count(1) COUNT_58 from FBG_ANALYTICS.OPERATIONS.CSAT_REPORTING group by CASE_TYPE) Q1) Q2 order by ISNULL_63 desc, COUNT_58 desc, CASE_TYPE asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/CSAT-Dashboard-1Vrb939sp8pEMmrta4ybzV","kind":"adhoc","request-id":"g019d740b50d272468cb34e07daa66800","user-id":"3TyUofBuuSbc350EhKutQIJywtJzn","email":"edwin.vargas@betfanatics.com"}
