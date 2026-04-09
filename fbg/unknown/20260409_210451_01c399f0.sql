-- Query ID: 01c399f0-0212-6e7d-24dd-07031930f2f7
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:04:51.912000+00:00
-- Elapsed: 236ms
-- Environment: FBG

select AGENT_NAME "TopK Value", COUNT_58 "TopK Count", ISNULL_63 "TopK Null Sort", AGENT_NAME_64 "Text Seach Column" from (select AGENT_NAME, COUNT_58, AGENT_NAME is null ISNULL_63, AGENT_NAME AGENT_NAME_64 from (select AGENT_NAME, count(1) COUNT_58 from FBG_ANALYTICS.OPERATIONS.CSAT_REPORTING where contains(lower(AGENT_NAME), lower('Andrew')) group by AGENT_NAME) Q1) Q2 order by ISNULL_63 desc, COUNT_58 desc, AGENT_NAME asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/CSAT-Dashboard-1Vrb939sp8pEMmrta4ybzV","kind":"adhoc","request-id":"g019d740fe39279c096fd36e44ab376ed","user-id":"3TyUofBuuSbc350EhKutQIJywtJzn","email":"edwin.vargas@betfanatics.com"}
