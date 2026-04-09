-- Query ID: 01c399dc-0212-6b00-24dd-0703192bff17
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:44:16.205000+00:00
-- Elapsed: 1882ms
-- Environment: FBG

select "ID", FULL_NAME "Name", "SOURCE" "Source", "YEAR" "Year", DEPOSIT_AMOUNT "Deposit Total", WITHDRAWAL_AMOUNT "Withdrawal Total", TOTAL_WAGER "Total Wagers", TOTAL_WIN "Total Win", TOTAL_LOSS "Total Loss", CORRECTIONS "Total Corrections", WIN_LOSS "Win/Loss" from (select * from FBG_FINANCE.TAX.WIN_LOSS_REPORT_V where "ID" = 2279510 and "YEAR" = 2025) Q1 limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Customer-Win_Loss-Report-1nVh2cTrCjWFEkMGdZgU9o?:displayNodeId=Q4UaymMCDw","kind":"screenshot","request-id":"g019d73fd08fd76ed8cadfe2b0a117431","user-id":"NGT0yjVYg9Qbdy5SphrIdvFxSMH5E","email":"christ.guzman@betfanatics.com"}
