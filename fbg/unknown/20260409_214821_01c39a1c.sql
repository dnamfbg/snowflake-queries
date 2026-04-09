-- Query ID: 01c39a1c-0212-644a-24dd-0703193b8123
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:48:21.322000+00:00
-- Elapsed: 163ms
-- Environment: FBG

select LT_DEPOSIT_AMT "Lifetime Deposit Amout", CASHOUT_PCT "% of Deposit Cashed out", PAYMENT_BRAND "Withdrawal Method", DATETRUNC_32 "Last Manual Withdrawal Date", MAX_33 "Withdrawal Method Age (Days)" from (select PAYMENT_BRAND, LT_DEPOSIT_AMT, CASHOUT_PCT, date_trunc(second, LATEST_MANUAL_WD_DATE::timestamp_ltz) DATETRUNC_32, max(WD_METHOD_AGE_DAYS) MAX_33 from FBG_GOVERNANCE.GOVERNANCE.WITHDRAWAL_REVIEW_MASTER where ACCO_ID = 901109 group by LT_DEPOSIT_AMT, CASHOUT_PCT, PAYMENT_BRAND, DATETRUNC_32) Q1 order by LT_DEPOSIT_AMT asc, CASHOUT_PCT asc, PAYMENT_BRAND asc, DATETRUNC_32 asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Withdrawal-Review-Dashboard-2NUdxvnoRn7VZK5BPtvRBA?:displayNodeId=0TgzBPE3k2","kind":"adhoc","request-id":"g019d7437b33174b293a301b2707fa910","user-id":"wM6n64U00BLDwbkn8TYMun3lqzCwz","email":"gorgi.markoski@betfanatics.com"}
