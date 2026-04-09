-- Query ID: 01c399ef-0212-6dbe-24dd-0703193067ef
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:03:40.703000+00:00
-- Elapsed: 47ms
-- Environment: FBG

select AGENT_NAME "TopK Value", COUNT_58 "TopK Count", ISNULL_63 "TopK Null Sort" from (select AGENT_NAME, COUNT_58, AGENT_NAME is null ISNULL_63 from (select AGENT_NAME, count(1) COUNT_58 from FBG_ANALYTICS.OPERATIONS.CSAT_REPORTING group by AGENT_NAME) Q1) Q2 order by ISNULL_63 desc, COUNT_58 desc, AGENT_NAME asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/CSAT-Dashboard-1Vrb939sp8pEMmrta4ybzV","kind":"adhoc","request-id":"g019d740ecd9c73eb85ba7cdb25b0bd45","user-id":"3TyUofBuuSbc350EhKutQIJywtJzn","email":"edwin.vargas@betfanatics.com"}
