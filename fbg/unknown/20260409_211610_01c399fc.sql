-- Query ID: 01c399fc-0212-644a-24dd-070319336aa3
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:16:10.627000+00:00
-- Elapsed: 466ms
-- Environment: FBG

select DATETRUNC_32 "Time Period", SUM_33 "Deposits", NEG_35 "Withdrawals" from (select date_trunc(day, COMPLETED_AT_ALK::timestamp_ltz) DATETRUNC_32, sum(iff(TRANSACTION_TYPE = 'DEPOSIT' and SIMPLIFIED_STATUS = 'SUCCESSFUL', AMOUNT_USD, null)) SUM_33, -sum(iff(TRANSACTION_TYPE = 'WITHDRAWAL' and SIMPLIFIED_STATUS = 'SUCCESSFUL', AMOUNT_USD, null)) NEG_35 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_WALLET_FUNDING_TRANSACTIONS where SIMPLIFIED_STATUS = 'SUCCESSFUL' and COMPLETED_AT_ALK >= to_timestamp_ntz('2026-03-10 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and COMPLETED_AT_ALK <= to_timestamp_ntz('2026-04-08 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') group by DATETRUNC_32) Q1 order by DATETRUNC_32 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=AGs91-blM8","kind":"adhoc","request-id":"g019d741a3e707baa8edae0e8ff0c61fd","user-id":"upxSWBvFzGQ3hkOD2R8HTLHwY6Hwy","email":"karissa.chabalie@betfanatics.com"}
