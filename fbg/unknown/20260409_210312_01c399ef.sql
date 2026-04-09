-- Query ID: 01c399ef-0212-6cb9-24dd-0703192ffb0f
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:03:12.723000+00:00
-- Elapsed: 72ms
-- Environment: FBG

select V_57 "lab", V_58 "Calc" from (select *, null::text V_58 from (select distinct 'Detailed List' V_57 from FBG_ANALYTICS.OPERATIONS.CSAT_REPORTING) Q1) Q2 limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/CSAT-Dashboard-1Vrb939sp8pEMmrta4ybzV?:displayNodeId=RuFdeiLHCb","kind":"adhoc","request-id":"g019d740e600a7e7d9158fc487a10d1d9","user-id":"3TyUofBuuSbc350EhKutQIJywtJzn","email":"edwin.vargas@betfanatics.com"}
