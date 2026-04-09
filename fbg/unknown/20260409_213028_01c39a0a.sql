-- Query ID: 01c39a0a-0212-644a-24dd-070319367f6f
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:30:28.203000+00:00
-- Elapsed: 107ms
-- Environment: FBG

select "Deposit/Withdrawal_Method" "Deposit Withdrawal Method", SUM_8 "Amount", SUM_9 "Transaction Count" from (select "Deposit/Withdrawal_Method", sum(AMOUNT) SUM_8, sum(TRANSACTION_COUNT) SUM_9 from FBG_GOVERNANCE.GOVERNANCE.WALLET_HISTORY where ACCOUNT_ID = 6571256 group by "Deposit/Withdrawal_Method") Q1 order by "Deposit/Withdrawal_Method" asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Withdrawal-Review-Dashboard-2NUdxvnoRn7VZK5BPtvRBA?:displayNodeId=wUXnOsyr3X","kind":"adhoc","request-id":"g019d74274f78773c9a5108556222a479","user-id":"zmNf9h66aBZT20t7V3BzC2LbZz0l9","email":"luke.donofrio@betfanatics.com"}
