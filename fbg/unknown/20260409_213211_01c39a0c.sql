-- Query ID: 01c39a0c-0212-67a9-24dd-0703193727bb
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:32:11.665000+00:00
-- Elapsed: 142ms
-- Environment: FBG

select ONE_K_FLAG "TopK Value", COUNT_28 "TopK Count", ISNULL_33 "TopK Null Sort" from (select ONE_K_FLAG, COUNT_28, ONE_K_FLAG is null ISNULL_33 from (select ONE_K_FLAG, count(1) COUNT_28 from FBG_GOVERNANCE.GOVERNANCE.AFFORDABILITY_NECCTON_TRACK group by ONE_K_FLAG) Q1) Q2 order by ISNULL_33 desc, COUNT_28 desc, ONE_K_FLAG asc limit 4

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Affordability-Dashboard-Central-RG-1lxIZPpETvGxFDYFD2Rear","kind":"adhoc","request-id":"g019d7428e89a7a8ea5f690cceeffead9","user-id":"n4W8ScmrfmcfhvhUymXzaOuFfij0V","email":"abraham.mieses@betfanatics.com"}
