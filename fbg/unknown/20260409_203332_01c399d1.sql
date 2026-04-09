-- Query ID: 01c399d1-0212-6b00-24dd-07031929bb2f
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:33:32.614000+00:00
-- Elapsed: 1402ms
-- Environment: FBG

select "ID", FULL_NAME "Name", "SOURCE" "Source", "YEAR" "Year", DEPOSIT_AMOUNT "Deposit Total", WITHDRAWAL_AMOUNT "Withdrawal Total", TOTAL_WAGER "Total Wagers", TOTAL_WIN "Total Win", TOTAL_LOSS "Total Loss", CORRECTIONS "Total Corrections", WIN_LOSS "Win/Loss" from (select * from FBG_FINANCE.TAX.WIN_LOSS_REPORT_V where "ID" = 5970693 and "YEAR" = 2025) Q1 limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Customer-Win_Loss-Report-1nVh2cTrCjWFEkMGdZgU9o?:displayNodeId=Q4UaymMCDw","kind":"adhoc","request-id":"g019d73f330827dc186156c0e836df04c","user-id":"amLtz2ieL7N15bY7Q2X9exzreZxoB","email":"jake.knowlton@betfanatics.com"}
