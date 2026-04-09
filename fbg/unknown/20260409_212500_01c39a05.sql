-- Query ID: 01c39a05-0212-67a8-24dd-07031935b2b3
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:25:00.766000+00:00
-- Elapsed: 570ms
-- Environment: FBG

select SUM_43 "Sum of Net Profit", SUM_44 "Sum of Total Contracts Traded", SUM_45 "Sum of Total Handle" from (select sum(NET_PROFIT) SUM_43, sum(TOTAL_CONTRACTS_TRADED) SUM_44, sum(TOTAL_HANDLE) SUM_45 from FMX_ANALYTICS.MARKET_MAKER.SIGMA_DAILY_REPORTING_MM) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Market-Maker-Trading-6R2FxbRY8q4N3ynnXwEGa0?:displayNodeId=mUGNos1RBA","kind":"adhoc","request-id":"g019d74224d25781fbf2e68ce0abd5230","user-id":"Zaj53AHEk1C5XVAfcwbJObHz5Z4PM","email":"zach.spergel@betfanatics.com"}
