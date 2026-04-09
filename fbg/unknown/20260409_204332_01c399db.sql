-- Query ID: 01c399db-0212-6dbe-24dd-0703192beb3b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:43:32.373000+00:00
-- Elapsed: 751ms
-- Environment: FBG

with W1 as (select SESSION_WEEK_ALK::timestamp_ltz CAST_110, count(distinct iff(CASH_STAKE > 0, USER_ID, null)) COUNTDISTINCT_118, count(distinct iff(CASH_STAKE > 0, SESSION_DATE_ALK::timestamp_ltz, null)) COUNTDISTINCT_122 from FBG_ANALYTICS.CASINO.PHH_CASINO_SESSIONS_TO_GAME_LAUNCHES_REPORT where not CASINO_SUPER_VIP and SESSION_DATE_ALK >= to_timestamp_ntz('2026-03-01 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and SESSION_DATE_ALK <= to_timestamp_ntz('2026-03-31 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') group by CAST_110, USER_ID) select DIV_178 "kpi_global_N1y14Qf6_-", CAST_111 "Switch Date_Granularity_DM", DIV_172 "Avg APDs" from (select Q4.CAST_111, Q4.DIV_172, Q6.DIV_178 from (select CAST_111, SUM_170 / nullif(SUM_171, 0) DIV_172 from (select CAST_110 CAST_111, sum(COUNTDISTINCT_122) SUM_170, sum(COUNTDISTINCT_118) SUM_171 from W1 Q2 where CAST_110 is not null group by CAST_110 order by CAST_111 asc limit 25001) Q3) Q4 cross join (select sum(COUNTDISTINCT_122) / nullif(sum(COUNTDISTINCT_118), 0) DIV_178 from W1 Q5 where CAST_110 is not null) Q6) Q8 order by CAST_111 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Product-Health-Hub-5K7wHNcDUTxTnU49MXx3Xu?:displayNodeId=tOwpmsQKo5","kind":"adhoc","request-id":"g019d73fc5d3472f5b05e53ebd88ff654","user-id":"XFnSY8L83Bb6SJzIJ82MNBv1Jmmyp","email":"Jaime.Meek@betfanatics.com"}
