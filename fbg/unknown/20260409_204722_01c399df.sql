-- Query ID: 01c399df-0212-67a9-24dd-0703192c9c9b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:47:22.305000+00:00
-- Elapsed: 454ms
-- Environment: FBG

select LT_DEPOSIT_AMT "Lifetime Deposit Amout", CASHOUT_PCT "% of Deposit Cashed out", PAYMENT_BRAND "Withdrawal Method", DATETRUNC_32 "Last Manual Withdrawal Date", MAX_33 "Withdrawal Method Age (Days)" from (select PAYMENT_BRAND, LT_DEPOSIT_AMT, CASHOUT_PCT, date_trunc(second, LATEST_MANUAL_WD_DATE::timestamp_ltz) DATETRUNC_32, max(WD_METHOD_AGE_DAYS) MAX_33 from FBG_GOVERNANCE.GOVERNANCE.WITHDRAWAL_REVIEW_MASTER where ACCO_ID = 6386296 group by LT_DEPOSIT_AMT, CASHOUT_PCT, PAYMENT_BRAND, DATETRUNC_32) Q1 order by LT_DEPOSIT_AMT asc, CASHOUT_PCT asc, PAYMENT_BRAND asc, DATETRUNC_32 asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Withdrawal-Review-Dashboard-2NUdxvnoRn7VZK5BPtvRBA?:displayNodeId=0TgzBPE3k2","kind":"adhoc","request-id":"g019d73ffde6c753eb785fbe91cbf6f44","user-id":"zmNf9h66aBZT20t7V3BzC2LbZz0l9","email":"luke.donofrio@betfanatics.com"}
