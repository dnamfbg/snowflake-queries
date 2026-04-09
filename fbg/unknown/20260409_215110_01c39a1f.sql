-- Query ID: 01c39a1f-0212-67a8-24dd-0703193bcccf
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:51:10.286000+00:00
-- Elapsed: 88ms
-- Environment: FBG

select ACCO_ID "Account ID", IF_32 "PB Migrated", VIP, IF_33 "Test Acco Check", STATUS "Acco Status", ACCOUNT_AGE_DAYS "Acco Age (Days)", SUM_35 "Cashout Count", SUM_34 "Short Bet Count" from (select ACCO_ID, ACCOUNT_AGE_DAYS, VIP, STATUS, iff(PB_MIGRATED = 1, 'Yes', 'No') IF_32, iff(TEST = 1, 'Yes', 'No') IF_33, sum(OSB_SHORT_BET_CT) SUM_34, sum(CASHOUT_CT) SUM_35 from FBG_GOVERNANCE.GOVERNANCE.WITHDRAWAL_REVIEW_MASTER where ACCO_ID is null group by ACCO_ID, IF_32, IF_33, VIP, STATUS, ACCOUNT_AGE_DAYS) Q1 order by ACCO_ID asc, IF_32 asc, VIP asc, IF_33 asc, STATUS asc, ACCOUNT_AGE_DAYS asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Withdrawal-Review-Dashboard-2NUdxvnoRn7VZK5BPtvRBA?:displayNodeId=1b9SxwXPKG","kind":"adhoc","request-id":"g019d743a461e7b8da61ec7a779650085","user-id":"dvA9SYMIqL0snRgDJMPvFYBY4SyK2","email":"bowen.smith@betfanatics.com"}
