-- Query ID: 01c399c7-0212-67a9-24dd-07031927f577
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:23:14.504000+00:00
-- Elapsed: 139ms
-- Environment: FBG

select SUM_306 "Deposit Amount", SUM_307 "Withdrawal Amount" from (select sum(DEPOSITAMOUNT) SUM_306, sum(WITHDRAWALAMOUNT) SUM_307 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.VIP_TABLEAU_DS where ACCO_ID = 6452759 and SK_DATE >= to_date('2026-01-01', 'YYYY-MM-DD') and SK_DATE <= to_date('2027-02-23', 'YYYY-MM-DD')) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/VIP-Customer-Dashboard-5Sd96Rf9IqJJ1z7sZvhkPp?:displayNodeId=YBUhzMBkAg","kind":"adhoc","request-id":"g019d73e9c80672f494186973b455599c","user-id":"B1FTu9bkRuek0OxmECFzFAk4nZeum","email":"Sameer.Khaled@betfanatics.com"}
