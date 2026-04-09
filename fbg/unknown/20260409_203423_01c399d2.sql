-- Query ID: 01c399d2-0212-6dbe-24dd-0703192a259f
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:34:23.516000+00:00
-- Elapsed: 6891ms
-- Environment: FBG

select CAST_112 "FLASH-Switch Date_Granularity", DIV_440 "Median Session First Casino Int to End", IF_441 "Sessions per Active", NULL_EQ_438, DIV_442 "P75 Session First Casino Int to End" from (select CAST_111 CAST_112, equal_null(min(COUNTDISTINCT_131 / nullif(COUNTDISTINCT_117, 0)), max(COUNTDISTINCT_131 / nullif(COUNTDISTINCT_117, 0))) NULL_EQ_438, sum(MEDIAN_116) / 60 DIV_440, iff(NULL_EQ_438, max(COUNTDISTINCT_131 / nullif(COUNTDISTINCT_117, 0)), null) IF_441, sum(PERCENTILECONT_119) / 60 DIV_442 from (select SESSION_WEEK_ALK::timestamp_ltz CAST_111, median(iff(PRODUCT_NAME <> 'Web_app', SECONDS_SESSION_FIRST_CASINO_INTERACTION_TO_END, null)) MEDIAN_116, count(distinct USER_ID) COUNTDISTINCT_117, percentile_cont(0.75) within group (order by iff(PRODUCT_NAME <> 'Web_app', SECONDS_SESSION_FIRST_CASINO_INTERACTION_TO_END, null) asc) PERCENTILECONT_119, count(distinct SESSION_UUID) COUNTDISTINCT_131 from FBG_ANALYTICS.CASINO.PHH_CASINO_SESSIONS_TO_GAME_LAUNCHES_REPORT where not CASINO_SUPER_VIP and PRODUCT_NAME = 'Casino_app' and SESSION_WEEK_ALK is not null group by CAST_111, PRODUCT_NAME, dateadd(week, -1, CAST_111)) Q1 group by CAST_111) Q2 order by CAST_112 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Product-Health-Hub-5K7wHNcDUTxTnU49MXx3Xu?:displayNodeId=Rk9_-0PN2w","kind":"adhoc","request-id":"g019d73f3f8a7737e9990e41f213954cd","user-id":"XFnSY8L83Bb6SJzIJ82MNBv1Jmmyp","email":"Jaime.Meek@betfanatics.com"}
