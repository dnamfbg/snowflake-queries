-- Query ID: 01c399d2-0212-67a9-24dd-0703192a42eb
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:34:44.659000+00:00
-- Elapsed: 3707ms
-- Environment: FBG

select "ID", FULL_NAME "Name", "SOURCE" "Source", "YEAR" "Year", DEPOSIT_AMOUNT "Deposit Total", WITHDRAWAL_AMOUNT "Withdrawal Total", TOTAL_WAGER "Total Wagers", TOTAL_WIN "Total Win", TOTAL_LOSS "Total Loss", CORRECTIONS "Total Corrections", WIN_LOSS "Win/Loss" from (select * from FBG_FINANCE.TAX.WIN_LOSS_REPORT_V where "ID" = 5970693 and "YEAR" = 2026) Q1 limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Customer-Win_Loss-Report-1nVh2cTrCjWFEkMGdZgU9o?:displayNodeId=uTBmND4f-L","kind":"adhoc","request-id":"g019d73f44a4c7c2894a92903f39d10dc","user-id":"amLtz2ieL7N15bY7Q2X9exzreZxoB","email":"jake.knowlton@betfanatics.com"}
