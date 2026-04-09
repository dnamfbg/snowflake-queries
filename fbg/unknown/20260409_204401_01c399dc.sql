-- Query ID: 01c399dc-0212-6cb9-24dd-0703192bdddb
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:44:01.657000+00:00
-- Elapsed: 2348ms
-- Environment: FBG

select "ID", FULL_NAME "Name", "SOURCE" "Source", "YEAR" "Year", DEPOSIT_AMOUNT "Deposit Total", WITHDRAWAL_AMOUNT "Withdrawal Total", TOTAL_WAGER "Total Wagers", TOTAL_WIN "Total Win", TOTAL_LOSS "Total Loss", CORRECTIONS "Total Corrections", WIN_LOSS "Win/Loss" from (select * from FBG_FINANCE.TAX.WIN_LOSS_REPORT_V where "ID" = 2279510 and "YEAR" = 2025) Q1 limit 106901

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Customer-Win_Loss-Report-1nVh2cTrCjWFEkMGdZgU9o?:displayNodeId=Q4UaymMCDw","kind":"adhoc","request-id":"g019d73fcca9d7dba8b5951b79a8d1ad8","user-id":"NGT0yjVYg9Qbdy5SphrIdvFxSMH5E","email":"christ.guzman@betfanatics.com"}
