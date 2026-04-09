-- Query ID: 01c39a18-0212-6b00-24dd-0703193a5a3f
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:44:18.153000+00:00
-- Elapsed: 47ms
-- Environment: FBG

select COUNT_156 "row-count" from (select count(1) COUNT_156 from (select 1 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.FANCASH_MULTIS where TIER is not null and date_trunc(day, SETTLED_DATE_ALK::timestamp_ltz) >= to_timestamp_ltz('2026-01-01T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and date_trunc(day, SETTLED_DATE_ALK::timestamp_ltz) <= to_timestamp_ltz('2026-04-09T23:59:59.999000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') group by X_MULTIPLIER, ATS_ACCOUNT_ID) Q1) Q2

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FanCash-Loyalty-Report-2Txc2ivoGjIwZ2PP9h6ynB?:displayNodeId=EAjRPtmNPh","kind":"adhoc","request-id":"g019d7433fed27920afa6512f6b8c0dc0","user-id":"1ob9mcmKybrCoq32r1DMUmaXfv3vH","email":"andrew.tsentner@betfanatics.com"}
