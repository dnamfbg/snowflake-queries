-- Query ID: 01c399c6-0212-67a8-24dd-07031927d4c3
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:22:49.323000+00:00
-- Elapsed: 129ms
-- Environment: FBG

select DATETRUNC_308 "Day of Dynamic Date", SUM_309 "Sum of Select Chart" from (select date_trunc(day, date_trunc(day, SK_DATE::timestamp_ltz)) DATETRUNC_308, sum(NETREVENUE) SUM_309 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.VIP_TABLEAU_DS where ACCO_ID = 2704087 and SK_DATE >= to_date('2023-03-02', 'YYYY-MM-DD') and SK_DATE <= to_date('2025-12-31', 'YYYY-MM-DD') group by DATETRUNC_308) Q1 order by DATETRUNC_308 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/VIP-Customer-Dashboard-5Sd96Rf9IqJJ1z7sZvhkPp?:displayNodeId=VWLmAaA_Az","kind":"adhoc","request-id":"g019d73e965a57f6384ec4f9361e48275","user-id":"B1FTu9bkRuek0OxmECFzFAk4nZeum","email":"Sameer.Khaled@betfanatics.com"}
