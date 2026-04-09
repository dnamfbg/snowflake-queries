-- Query ID: 01c399e1-0212-644a-24dd-0703192d555f
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:49:40.339000+00:00
-- Elapsed: 1144ms
-- Environment: FBG

select SUM_306 "Deposit Amount", SUM_307 "Withdrawal Amount" from (select sum(DEPOSITAMOUNT) SUM_306, sum(WITHDRAWALAMOUNT) SUM_307 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.VIP_TABLEAU_DS where SK_DATE >= to_date('2026-01-10', 'YYYY-MM-DD') and SK_DATE <= to_date('2026-04-09', 'YYYY-MM-DD')) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/VIP-Customer-Dashboard-5Sd96Rf9IqJJ1z7sZvhkPp?:displayNodeId=YBUhzMBkAg","kind":"adhoc","request-id":"g019d7401f93c724fb7e0cd4e931471fd","user-id":"KKHxtqTq3l0qSi0sR3WFE0rCwPJuX","email":"vinny.ortega@betfanatics.com"}
