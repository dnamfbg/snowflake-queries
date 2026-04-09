-- Query ID: 01c399d7-0212-6cb9-24dd-0703192b4387
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:39:11.183000+00:00
-- Elapsed: 935ms
-- Environment: FBG

with W1 as (select date_trunc(month, SESSION_DATE_ALK::timestamp_ltz) DATETRUNC_110, count(distinct SESSION_UUID) COUNTDISTINCT_168 from FBG_ANALYTICS.CASINO.PHH_CASINO_SESSIONS_TO_GAME_LAUNCHES_REPORT where not CASINO_SUPER_VIP and SESSION_DATE_ALK >= to_timestamp_ntz('2026-02-23 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and SESSION_DATE_ALK <= to_timestamp_ntz('2026-04-05 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') group by DATETRUNC_110) select AVG_294 "kpi_global_a9iSdAcXaO", DATETRUNC_111 "Switch Date_Granularity_DM", COUNTDISTINCT_169 "Avg of Casino Sessions" from (select Q3.COUNTDISTINCT_169, Q3.DATETRUNC_111, Q5.AVG_294 from (select COUNTDISTINCT_168 COUNTDISTINCT_169, DATETRUNC_110 DATETRUNC_111 from W1 Q2 where DATETRUNC_110 is not null order by DATETRUNC_111 asc limit 25001) Q3 cross join (select avg(COUNTDISTINCT_168) AVG_294 from W1 Q4 where DATETRUNC_110 is not null) Q5) Q7 order by DATETRUNC_111 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Product-Health-Hub-5K7wHNcDUTxTnU49MXx3Xu?:displayNodeId=qJWdXIsEFN","kind":"adhoc","request-id":"g019d73f85e5473acac4423b9ebd7938a","user-id":"XFnSY8L83Bb6SJzIJ82MNBv1Jmmyp","email":"Jaime.Meek@betfanatics.com"}
