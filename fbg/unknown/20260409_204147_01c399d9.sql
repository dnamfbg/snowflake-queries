-- Query ID: 01c399d9-0212-6dbe-24dd-0703192be283
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:41:47+00:00
-- Elapsed: 45ms
-- Environment: FBG

select ACCO_ID "Account ID", IF_32 "PB Migrated", VIP, IF_33 "Test Acco Check", STATUS "Acco Status", ACCOUNT_AGE_DAYS "Acco Age (Days)", SUM_35 "Cashout Count", SUM_34 "Short Bet Count" from (select ACCO_ID, ACCOUNT_AGE_DAYS, VIP, STATUS, iff(PB_MIGRATED = 1, 'Yes', 'No') IF_32, iff(TEST = 1, 'Yes', 'No') IF_33, sum(OSB_SHORT_BET_CT) SUM_34, sum(CASHOUT_CT) SUM_35 from FBG_GOVERNANCE.GOVERNANCE.WITHDRAWAL_REVIEW_MASTER group by IF_32, IF_33, ACCO_ID, VIP, STATUS, ACCOUNT_AGE_DAYS) Q1 order by ACCO_ID asc, IF_32 asc, VIP asc, IF_33 asc, STATUS asc, ACCOUNT_AGE_DAYS asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Withdrawal-Review-Dashboard-2NUdxvnoRn7VZK5BPtvRBA?:displayNodeId=1b9SxwXPKG","kind":"adhoc","request-id":"g019d73fac0527971a1ce634110c5e8f4","user-id":"jq9eEM8S1jbljCS4KzxiXWhnVMGGN","email":"daniel.westerberg@betfanatics.com"}
