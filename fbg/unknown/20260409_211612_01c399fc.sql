-- Query ID: 01c399fc-0212-644a-24dd-070319336ad3
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:16:12.621000+00:00
-- Elapsed: 450ms
-- Environment: FBG

select DATETRUNC_11 "Time Period", COALESCE_32 "$ Idle Funds", LAG_44 "$ Idle Funds period before", COALESCE_33 "$ Active Funds", LAG_45 "$ Active Funds period before" from (select DATETRUNC_11, coalesce(SUM_20, SUM_25) COALESCE_32, coalesce(SUM_26, SUM_31) COALESCE_33, lag(SUM_20, 1) over ( order by DATETRUNC_11 asc) LAG_44, lag(SUM_26, 1) over ( order by DATETRUNC_11 asc) LAG_45 from (select date_trunc(day, ACTIVITY_DATE::timestamp_ltz) DATETRUNC_11, sum(IDLE_FUNDS_USD) SUM_20, sum(iff(ACTIVITY_DATE = to_date('2026-04-09', 'YYYY-MM-DD'), IDLE_FUNDS_USD, null)) SUM_25, sum(ACTIVE_FUNDS_USD) SUM_26, sum(iff(ACTIVITY_DATE = to_date('2026-04-09', 'YYYY-MM-DD'), ACTIVE_FUNDS_USD, null)) SUM_31 from FMX_ANALYTICS.CUSTOMER.CUST_FMX_CUSTOMER_DAILY_BALANCE where date_trunc(day, ACTIVITY_DATE::timestamp_ltz) is not null and date_trunc(day, ACTIVITY_DATE::timestamp_ltz) >= to_timestamp_ltz('2026-03-10T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and date_trunc(day, ACTIVITY_DATE::timestamp_ltz) <= to_timestamp_ltz('2026-04-08T23:59:59.999000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') group by DATETRUNC_11) Q1) Q2 order by DATETRUNC_11 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=8-M0pdDgx3","kind":"adhoc","request-id":"g019d741a45e270a9bd72a5439f1434d6","user-id":"upxSWBvFzGQ3hkOD2R8HTLHwY6Hwy","email":"karissa.chabalie@betfanatics.com"}
