-- Query ID: 01c39a05-0212-6dbe-24dd-07031935991b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:25:19.062000+00:00
-- Elapsed: 509ms
-- Environment: FBG

select DATETRUNC_33 "Time Period", SUM_34 "Deposit", LAG_40 "Lag of Sum of Deposit", AVG_35 "Average Deposit", LAG_41 "Lag of Sum of Average Deposit", AVG_36 "Average Withdrawal", LAG_42 "Lag of Sum of Average Withdrawal" from (select DATETRUNC_33, SUM_34, AVG_35, AVG_36, lag(SUM_34, 1) over ( order by DATETRUNC_33 asc) LAG_40, lag(AVG_35, 1) over ( order by DATETRUNC_33 asc) LAG_41, lag(AVG_36, 1) over ( order by DATETRUNC_33 asc) LAG_42 from (select date_trunc(day, INITIATED_AT_ALK::timestamp_ltz) DATETRUNC_33, sum(iff(SIMPLIFIED_STATUS = 'SUCCESSFUL' and TRANSACTION_TYPE = 'DEPOSIT', AMOUNT_USD, null)) SUM_34, avg(iff(SIMPLIFIED_STATUS = 'SUCCESSFUL' and TRANSACTION_TYPE = 'DEPOSIT', AMOUNT_USD, null)) AVG_35, avg(iff(SIMPLIFIED_STATUS = 'SUCCESSFUL' and TRANSACTION_TYPE = 'WITHDRAWAL', AMOUNT_USD, null)) AVG_36 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_WALLET_FUNDING_TRANSACTIONS where COMPLETED_AT_ALK >= to_timestamp_ntz('2026-03-10 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and COMPLETED_AT_ALK <= to_timestamp_ntz('2026-04-08 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and date_trunc(day, INITIATED_AT_ALK::timestamp_ltz) is not null group by DATETRUNC_33) Q1) Q2 order by DATETRUNC_33 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=skMgvxkpj6","kind":"adhoc","request-id":"g019d74229c877c9ba3aa4a40548af45e","user-id":"upxSWBvFzGQ3hkOD2R8HTLHwY6Hwy","email":"karissa.chabalie@betfanatics.com"}
