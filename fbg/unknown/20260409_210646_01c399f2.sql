-- Query ID: 01c399f2-0212-644a-24dd-07031931411f
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:06:46.430000+00:00
-- Elapsed: 892ms
-- Environment: FBG

select SUM_306 "Sum of Osbgrossrevenue" from (select sum(OSBGROSSREVENUE) SUM_306 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.VIP_TABLEAU_DS where ACCO_ID = 2704087 and SK_DATE >= to_date('2023-03-02', 'YYYY-MM-DD') and SK_DATE <= to_date('2025-12-31', 'YYYY-MM-DD')) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/VIP-Customer-Dashboard-5Sd96Rf9IqJJ1z7sZvhkPp?:displayNodeId=ocMkvlQV7v","kind":"adhoc","request-id":"g019d7411a1227d55b2b00fa7cedbb78e","user-id":"B1FTu9bkRuek0OxmECFzFAk4nZeum","email":"Sameer.Khaled@betfanatics.com"}
