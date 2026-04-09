-- Query ID: 01c39a0b-0212-6e7d-24dd-070319375283
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:31:32.486000+00:00
-- Elapsed: 490ms
-- Environment: FBG

select ACCO_ID_NECCTON "TopK Value", COUNT_28 "TopK Count", ISNULL_33 "TopK Null Sort" from (select ACCO_ID_NECCTON, COUNT_28, ACCO_ID_NECCTON is null ISNULL_33 from (select ACCO_ID_NECCTON, count(1) COUNT_28 from FBG_GOVERNANCE.GOVERNANCE.AFFORDABILITY_NECCTON_TRACK group by ACCO_ID_NECCTON) Q1) Q2 order by ISNULL_33 desc, COUNT_28 desc, ACCO_ID_NECCTON asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Affordability-Dashboard-Central-RG-1lxIZPpETvGxFDYFD2Rear","kind":"adhoc","request-id":"g019d74284f48771eaf8334a9c1925546","user-id":"n4W8ScmrfmcfhvhUymXzaOuFfij0V","email":"abraham.mieses@betfanatics.com"}
