-- Query ID: 01c399dc-0212-67a9-24dd-0703192c1a0f
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:44:00.897000+00:00
-- Elapsed: 29806ms
-- Environment: FBG

select "ID" "TopK Value", COUNT_12 "TopK Count", CAST_17 "Text Seach Column" from (select "ID", COUNT_12, "ID"::text CAST_17 from (select "ID", count(1) COUNT_12 from FBG_FINANCE.TAX.WIN_LOSS_REPORT_V where contains(lower("ID"::text), lower('2279510')) group by "ID") Q1) Q2 order by "ID" asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Customer-Win_Loss-Report-1nVh2cTrCjWFEkMGdZgU9o","kind":"adhoc","request-id":"g019d73fcc9c17444bc5acb2d2a9db9ac","user-id":"NGT0yjVYg9Qbdy5SphrIdvFxSMH5E","email":"christ.guzman@betfanatics.com"}
