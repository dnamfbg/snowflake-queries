-- Query ID: 01c399d6-0212-6dbe-24dd-0703192acf97
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:38:55.471000+00:00
-- Elapsed: 1122ms
-- Environment: FBG

select "Deposit/Withdrawal_Method" "Deposit Withdrawal Method", SUM_8 "Amount", SUM_9 "Transaction Count" from (select "Deposit/Withdrawal_Method", sum(AMOUNT) SUM_8, sum(TRANSACTION_COUNT) SUM_9 from FBG_GOVERNANCE.GOVERNANCE.WALLET_HISTORY where ACCOUNT_ID = 3213501 group by "Deposit/Withdrawal_Method") Q1 order by "Deposit/Withdrawal_Method" asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Withdrawal-Review-Dashboard-2NUdxvnoRn7VZK5BPtvRBA?:displayNodeId=wUXnOsyr3X","kind":"adhoc","request-id":"g019d73f822227a9aa299a77a1897da63","user-id":"jq9eEM8S1jbljCS4KzxiXWhnVMGGN","email":"daniel.westerberg@betfanatics.com"}
