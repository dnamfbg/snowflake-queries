-- Query ID: 01c399f0-0212-644a-24dd-070319301eab
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:04:00.330000+00:00
-- Elapsed: 732ms
-- Environment: FBG

select ACCO_ID "TopK Value", COUNT_307 "TopK Count", CAST_312 "Text Seach Column" from (select ACCO_ID, COUNT_307, ACCO_ID::text CAST_312 from (select ACCO_ID, count(1) COUNT_307 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.VIP_TABLEAU_DS where contains(lower(ACCO_ID::text), lower('2573375')) group by ACCO_ID) Q1) Q2 order by ACCO_ID asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/VIP-Customer-Dashboard-5Sd96Rf9IqJJ1z7sZvhkPp","kind":"adhoc","request-id":"g019d740f19d273a69947040442cf585a","user-id":"KKHxtqTq3l0qSi0sR3WFE0rCwPJuX","email":"vinny.ortega@betfanatics.com"}
