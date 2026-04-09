-- Query ID: 01c39a22-0212-6dbe-24dd-0703193c3fab
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:54:24.061000+00:00
-- Elapsed: 108ms
-- Environment: FBG

select COUNT_67 "row-count" from (select count(1) COUNT_67 from FBG_GOVERNANCE.GOVERNANCE.AFFORDABILITY_CENTRALIZE_DATA left join FBG_GOVERNANCE.GOVERNANCE.SIGMA_AFFORDABILITY_CONDENSED Q2 on AFFORDABILITY_CENTRALIZE_DATA.ACCO_ID = Q2.ACCO_ID) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Affordability-Dashboard-Central-RG-1lxIZPpETvGxFDYFD2Rear?:displayNodeId=ISB0GYOtve","kind":"adhoc","request-id":"g019d743d3d5572e68744969b5689b25a","user-id":"n4W8ScmrfmcfhvhUymXzaOuFfij0V","email":"abraham.mieses@betfanatics.com"}
