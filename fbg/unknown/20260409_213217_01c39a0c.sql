-- Query ID: 01c39a0c-0212-6cb9-24dd-0703193774af
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:32:17.981000+00:00
-- Elapsed: 151ms
-- Environment: FBG

select MONETARY_RISK_FLAG "TopK Value", COUNT_28 "TopK Count", ISNULL_33 "TopK Null Sort" from (select MONETARY_RISK_FLAG, COUNT_28, MONETARY_RISK_FLAG is null ISNULL_33 from (select MONETARY_RISK_FLAG, count(1) COUNT_28 from FBG_GOVERNANCE.GOVERNANCE.AFFORDABILITY_NECCTON_TRACK group by MONETARY_RISK_FLAG) Q1) Q2 order by ISNULL_33 desc, COUNT_28 desc, MONETARY_RISK_FLAG asc limit 4

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Affordability-Dashboard-Central-RG-1lxIZPpETvGxFDYFD2Rear","kind":"adhoc","request-id":"g019d742900127a7780a06be10a2ac85c","user-id":"n4W8ScmrfmcfhvhUymXzaOuFfij0V","email":"abraham.mieses@betfanatics.com"}
