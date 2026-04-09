-- Query ID: 01c399da-0212-6e7d-24dd-0703192bce0f
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:42:36.200000+00:00
-- Elapsed: 161ms
-- Environment: FBG

select SUM_306 "Deposit Amount", SUM_307 "Withdrawal Amount" from (select sum(DEPOSITAMOUNT) SUM_306, sum(WITHDRAWALAMOUNT) SUM_307 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.VIP_TABLEAU_DS where ACCO_ID = 3674844 and SK_DATE >= to_date('2026-01-10', 'YYYY-MM-DD') and SK_DATE <= to_date('2026-04-09', 'YYYY-MM-DD')) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/VIP-Customer-Dashboard-5Sd96Rf9IqJJ1z7sZvhkPp?:displayNodeId=YBUhzMBkAg","kind":"adhoc","request-id":"g019d73fb81e970c0966a174e81fcd66d","user-id":"KKHxtqTq3l0qSi0sR3WFE0rCwPJuX","email":"vinny.ortega@betfanatics.com"}
