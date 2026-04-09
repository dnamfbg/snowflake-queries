-- Query ID: 01c399c6-0212-6cb9-24dd-07031927c747
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:22:54.162000+00:00
-- Elapsed: 560ms
-- Environment: FBG

select ACCO_ID "TopK Value", COUNT_307 "TopK Count", CAST_312 "Text Seach Column" from (select ACCO_ID, COUNT_307, ACCO_ID::text CAST_312 from (select ACCO_ID, count(1) COUNT_307 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.VIP_TABLEAU_DS where contains(lower(ACCO_ID::text), lower('6452759')) group by ACCO_ID) Q1) Q2 order by ACCO_ID asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/VIP-Customer-Dashboard-5Sd96Rf9IqJJ1z7sZvhkPp","kind":"adhoc","request-id":"g019d73e977887f7880dc5f5ed18d6170","user-id":"B1FTu9bkRuek0OxmECFzFAk4nZeum","email":"Sameer.Khaled@betfanatics.com"}
