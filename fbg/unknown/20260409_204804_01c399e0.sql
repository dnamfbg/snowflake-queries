-- Query ID: 01c399e0-0212-644a-24dd-0703192cdbdf
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:48:04.370000+00:00
-- Elapsed: 850ms
-- Environment: FBG

select CAST_112 "FLASH-Switch Date_Granularity", DIV_437 "P75 Session First Casino Int to End (Min)" from (select CAST_111 CAST_112, sum(PERCENTILECONT_119) / 60 DIV_437 from (select SESSION_WEEK_ALK::timestamp_ltz CAST_111, percentile_cont(0.75) within group (order by iff(PRODUCT_NAME <> 'Web_app', SECONDS_SESSION_FIRST_CASINO_INTERACTION_TO_END, null) asc) PERCENTILECONT_119 from FBG_ANALYTICS.CASINO.PHH_CASINO_SESSIONS_TO_GAME_LAUNCHES_REPORT where not CASINO_SUPER_VIP and SESSION_DATE_ALK >= to_timestamp_ntz('2026-02-01 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and SESSION_DATE_ALK <= to_timestamp_ntz('2026-02-28 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and PRODUCT_NAME = 'Sportsbook_app' and SESSION_WEEK_ALK is not null group by CAST_111, PRODUCT_NAME, dateadd(week, -1, CAST_111)) Q1 group by CAST_111) Q2 order by CAST_112 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Product-Health-Hub-5K7wHNcDUTxTnU49MXx3Xu?:displayNodeId=Os4RYPJsoD","kind":"adhoc","request-id":"g019d7400838e7a008d015faff45354e8","user-id":"XFnSY8L83Bb6SJzIJ82MNBv1Jmmyp","email":"Jaime.Meek@betfanatics.com"}
