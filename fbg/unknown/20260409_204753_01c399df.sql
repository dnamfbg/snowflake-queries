-- Query ID: 01c399df-0212-6dbe-24dd-0703192ce58b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:47:53.374000+00:00
-- Elapsed: 1517ms
-- Environment: FBG

select "ID", FULL_NAME "Name", "SOURCE" "Source", "YEAR" "Year", DEPOSIT_AMOUNT "Deposit Total", WITHDRAWAL_AMOUNT "Withdrawal Total", TOTAL_WAGER "Total Wagers", TOTAL_WIN "Total Win", TOTAL_LOSS "Total Loss", CORRECTIONS "Total Corrections", WIN_LOSS "Win/Loss" from (select * from FBG_FINANCE.TAX.WIN_LOSS_REPORT_V where "ID" = 1572655 and "YEAR" = 2025) Q1 limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Customer-Win_Loss-Report-1nVh2cTrCjWFEkMGdZgU9o?:displayNodeId=Q4UaymMCDw","kind":"screenshot","request-id":"g019d740059417082a92cd5f53189ace3","user-id":"7xb4W1Kn3opXiufzyeY82xAvku6A3","email":"brandi.valdezmontoya@betfanatics.com"}
