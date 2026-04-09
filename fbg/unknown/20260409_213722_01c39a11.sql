-- Query ID: 01c39a11-0212-6b00-24dd-07031938aa63
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:37:22.352000+00:00
-- Elapsed: 485ms
-- Environment: FBG

select "Deposit/Withdrawal_Method" "Deposit Withdrawal Method", SUM_8 "Amount", SUM_9 "Transaction Count" from (select "Deposit/Withdrawal_Method", sum(AMOUNT) SUM_8, sum(TRANSACTION_COUNT) SUM_9 from FBG_GOVERNANCE.GOVERNANCE.WALLET_HISTORY where ACCOUNT_ID = 866907 group by "Deposit/Withdrawal_Method") Q1 order by "Deposit/Withdrawal_Method" asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Withdrawal-Review-Dashboard-2NUdxvnoRn7VZK5BPtvRBA?:displayNodeId=wUXnOsyr3X","kind":"adhoc","request-id":"g019d742da50872328ce9466494be6ad7","user-id":"wM6n64U00BLDwbkn8TYMun3lqzCwz","email":"gorgi.markoski@betfanatics.com"}
