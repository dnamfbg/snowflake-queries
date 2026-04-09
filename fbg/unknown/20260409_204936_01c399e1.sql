-- Query ID: 01c399e1-0212-6dbe-24dd-0703192d60ef
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:49:36.128000+00:00
-- Elapsed: 63ms
-- Environment: FBG

select ACCOUNTMANAGER "TopK Value", COUNT_307 "TopK Count", ISNULL_312 "TopK Null Sort" from (select ACCOUNTMANAGER, COUNT_307, ACCOUNTMANAGER is null ISNULL_312 from (select ACCOUNTMANAGER, count(1) COUNT_307 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.VIP_TABLEAU_DS group by ACCOUNTMANAGER) Q1) Q2 order by ISNULL_312 desc, ACCOUNTMANAGER asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/VIP-Customer-Dashboard-5Sd96Rf9IqJJ1z7sZvhkPp","kind":"adhoc","request-id":"g019d7401e9f174adaae7353fbf79ef4a","user-id":"KKHxtqTq3l0qSi0sR3WFE0rCwPJuX","email":"vinny.ortega@betfanatics.com"}
