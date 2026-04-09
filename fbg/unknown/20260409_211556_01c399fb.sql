-- Query ID: 01c399fb-0212-644a-24dd-07031933695f
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:15:56.309000+00:00
-- Elapsed: 590ms
-- Environment: FBG

select ACCO_ID "Account ID", IF_32 "PB Migrated", VIP, IF_33 "Test Acco Check", STATUS "Acco Status", ACCOUNT_AGE_DAYS "Acco Age (Days)", SUM_35 "Cashout Count", SUM_34 "Short Bet Count" from (select ACCO_ID, ACCOUNT_AGE_DAYS, VIP, STATUS, iff(PB_MIGRATED = 1, 'Yes', 'No') IF_32, iff(TEST = 1, 'Yes', 'No') IF_33, sum(OSB_SHORT_BET_CT) SUM_34, sum(CASHOUT_CT) SUM_35 from FBG_GOVERNANCE.GOVERNANCE.WITHDRAWAL_REVIEW_MASTER where ACCO_ID = 735137 group by ACCO_ID, IF_32, IF_33, VIP, STATUS, ACCOUNT_AGE_DAYS) Q1 order by ACCO_ID asc, IF_32 asc, VIP asc, IF_33 asc, STATUS asc, ACCOUNT_AGE_DAYS asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Withdrawal-Review-Dashboard-2NUdxvnoRn7VZK5BPtvRBA?:displayNodeId=1b9SxwXPKG","kind":"adhoc","request-id":"g019d741a010b704c8d6f96e9caeadcce","user-id":"wM6n64U00BLDwbkn8TYMun3lqzCwz","email":"gorgi.markoski@betfanatics.com"}
