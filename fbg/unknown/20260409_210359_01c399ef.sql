-- Query ID: 01c399ef-0212-6b00-24dd-07031930a103
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:03:59.441000+00:00
-- Elapsed: 56ms
-- Environment: FBG

select SUM_306 "Deposit Amount", SUM_307 "Withdrawal Amount" from (select sum(DEPOSITAMOUNT) SUM_306, sum(WITHDRAWALAMOUNT) SUM_307 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.VIP_TABLEAU_DS where SK_DATE >= to_date('2026-01-10', 'YYYY-MM-DD') and SK_DATE <= to_date('2026-04-09', 'YYYY-MM-DD')) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/VIP-Customer-Dashboard-5Sd96Rf9IqJJ1z7sZvhkPp?:displayNodeId=YBUhzMBkAg","kind":"adhoc","request-id":"g019d740f1615721393a11ff3bb5edac0","user-id":"KKHxtqTq3l0qSi0sR3WFE0rCwPJuX","email":"vinny.ortega@betfanatics.com"}
