-- Query ID: 01c399da-0212-67a9-24dd-0703192c13ab
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:42:59.909000+00:00
-- Elapsed: 1213ms
-- Environment: FBG

select CAST_112 "FLASH-Switch Date_Granularity", DIV_439 "Calc", IF_440 "Sessions per Active", NULL_EQ_437 from (select CAST_111 CAST_112, equal_null(min(COUNTDISTINCT_131 / nullif(COUNTDISTINCT_117, 0)), max(COUNTDISTINCT_131 / nullif(COUNTDISTINCT_117, 0))) NULL_EQ_437, sum(PERCENTILECONT_119) / 60 DIV_439, iff(NULL_EQ_437, max(COUNTDISTINCT_131 / nullif(COUNTDISTINCT_117, 0)), null) IF_440 from (select SESSION_WEEK_ALK::timestamp_ltz CAST_111, count(distinct USER_ID) COUNTDISTINCT_117, percentile_cont(0.75) within group (order by iff(PRODUCT_NAME <> 'Web_app', SECONDS_SESSION_FIRST_CASINO_INTERACTION_TO_END, null) asc) PERCENTILECONT_119, count(distinct SESSION_UUID) COUNTDISTINCT_131 from FBG_ANALYTICS.CASINO.PHH_CASINO_SESSIONS_TO_GAME_LAUNCHES_REPORT where not CASINO_SUPER_VIP and SESSION_DATE_ALK >= to_timestamp_ntz('2026-03-01 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and SESSION_DATE_ALK <= to_timestamp_ntz('2026-03-31 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and PRODUCT_NAME = 'Sportsbook_app' and SESSION_WEEK_ALK is not null group by CAST_111, PRODUCT_NAME, dateadd(week, -1, CAST_111)) Q1 group by CAST_111) Q2 order by CAST_112 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Product-Health-Hub-5K7wHNcDUTxTnU49MXx3Xu?:displayNodeId=Jnsm1D0jhr","kind":"adhoc","request-id":"g019d73fbdc7979729ec441088e6b8a6c","user-id":"XFnSY8L83Bb6SJzIJ82MNBv1Jmmyp","email":"Jaime.Meek@betfanatics.com"}
