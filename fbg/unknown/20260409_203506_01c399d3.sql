-- Query ID: 01c399d3-0212-6b00-24dd-0703192a554b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:35:06.465000+00:00
-- Elapsed: 1280ms
-- Environment: FBG

select "ID", FULL_NAME "Name", "SOURCE" "Source", "YEAR" "Year", DEPOSIT_AMOUNT "Deposit Total", WITHDRAWAL_AMOUNT "Withdrawal Total", TOTAL_WAGER "Total Wagers", TOTAL_WIN "Total Win", TOTAL_LOSS "Total Loss", CORRECTIONS "Total Corrections", WIN_LOSS "Win/Loss" from (select * from FBG_FINANCE.TAX.WIN_LOSS_REPORT_V where "ID" = 5970693 and "YEAR" = 2026) Q1 limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Customer-Win_Loss-Report-1nVh2cTrCjWFEkMGdZgU9o?:displayNodeId=uTBmND4f-L","kind":"screenshot","request-id":"g019d73f4a5717d6eb4306ab491063691","user-id":"amLtz2ieL7N15bY7Q2X9exzreZxoB","email":"jake.knowlton@betfanatics.com"}
