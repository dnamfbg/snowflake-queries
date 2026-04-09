-- Query ID: 01c399fb-0212-6dbe-24dd-07031933c137
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:15:58.637000+00:00
-- Elapsed: 567ms
-- Environment: FBG

select "Deposit/Withdrawal_Method" "Deposit Withdrawal Method", SUM_8 "Amount", SUM_9 "Transaction Count" from (select "Deposit/Withdrawal_Method", sum(AMOUNT) SUM_8, sum(TRANSACTION_COUNT) SUM_9 from FBG_GOVERNANCE.GOVERNANCE.WALLET_HISTORY where ACCOUNT_ID = 735137 group by "Deposit/Withdrawal_Method") Q1 order by "Deposit/Withdrawal_Method" asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Withdrawal-Review-Dashboard-2NUdxvnoRn7VZK5BPtvRBA?:displayNodeId=wUXnOsyr3X","kind":"adhoc","request-id":"g019d741a0d267028ab34affb100e0021","user-id":"wM6n64U00BLDwbkn8TYMun3lqzCwz","email":"gorgi.markoski@betfanatics.com"}
