-- Query ID: 01c399f2-0212-6dbe-24dd-070319310c97
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:06:49.405000+00:00
-- Elapsed: 72ms
-- Environment: FBG

select ACCO_ID "TopK Value", COUNT_307 "TopK Count" from (select ACCO_ID, count(1) COUNT_307 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.VIP_TABLEAU_DS group by ACCO_ID) Q1 order by ACCO_ID asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/VIP-Customer-Dashboard-5Sd96Rf9IqJJ1z7sZvhkPp","kind":"adhoc","request-id":"g019d7411ae957ffe85341fcaef48c1ff","user-id":"B1FTu9bkRuek0OxmECFzFAk4nZeum","email":"Sameer.Khaled@betfanatics.com"}
