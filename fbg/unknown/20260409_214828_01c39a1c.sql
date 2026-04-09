-- Query ID: 01c39a1c-0212-6e7d-24dd-0703193b553b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:48:28.338000+00:00
-- Elapsed: 307ms
-- Environment: FBG

select "Deposit/Withdrawal_Method" "Deposit Withdrawal Method", SUM_8 "Amount", SUM_9 "Transaction Count" from (select "Deposit/Withdrawal_Method", sum(AMOUNT) SUM_8, sum(TRANSACTION_COUNT) SUM_9 from FBG_GOVERNANCE.GOVERNANCE.WALLET_HISTORY where ACCOUNT_ID = 6543632 group by "Deposit/Withdrawal_Method") Q1 order by "Deposit/Withdrawal_Method" asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Withdrawal-Review-Dashboard-2NUdxvnoRn7VZK5BPtvRBA?:displayNodeId=wUXnOsyr3X","kind":"adhoc","request-id":"g019d7437cf3b793d931dd9003de900c0","user-id":"zmNf9h66aBZT20t7V3BzC2LbZz0l9","email":"luke.donofrio@betfanatics.com"}
