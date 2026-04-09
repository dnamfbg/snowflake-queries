-- Query ID: 01c399eb-0212-6e7d-24dd-0703192f38df
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:59:05.319000+00:00
-- Elapsed: 717ms
-- Environment: FBG

select CASE_SUBTYPE "TopK Value", COUNT_58 "TopK Count", ISNULL_63 "TopK Null Sort" from (select CASE_SUBTYPE, COUNT_58, CASE_SUBTYPE is null ISNULL_63 from (select CASE_SUBTYPE, count(1) COUNT_58 from FBG_ANALYTICS.OPERATIONS.CSAT_REPORTING group by CASE_SUBTYPE) Q1) Q2 order by ISNULL_63 desc, COUNT_58 desc, CASE_SUBTYPE asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/CSAT-Dashboard-1Vrb939sp8pEMmrta4ybzV","kind":"adhoc","request-id":"g019d740a9a1879eb894879c69235e12b","user-id":"3TyUofBuuSbc350EhKutQIJywtJzn","email":"edwin.vargas@betfanatics.com"}
