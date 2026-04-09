-- Query ID: 01c399db-0212-6b00-24dd-0703192bf6ab
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:43:04.294000+00:00
-- Elapsed: 3157ms
-- Environment: FBG

select DATETRUNC_112 "FLASH-Switch Date_Granularity", DIV_437 "P75 Session First Casino Int to End (Min)" from (select DATETRUNC_111 DATETRUNC_112, sum(PERCENTILECONT_119) / 60 DIV_437 from (select date_trunc(month, SESSION_DATE_ALK::timestamp_ltz) DATETRUNC_111, percentile_cont(0.75) within group (order by iff(PRODUCT_NAME <> 'Web_app', SECONDS_SESSION_FIRST_CASINO_INTERACTION_TO_END, null) asc) PERCENTILECONT_119 from FBG_ANALYTICS.CASINO.PHH_CASINO_SESSIONS_TO_GAME_LAUNCHES_REPORT where not CASINO_SUPER_VIP and SESSION_DATE_ALK >= to_timestamp_ntz('2026-03-01 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and SESSION_DATE_ALK <= to_timestamp_ntz('2026-03-31 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and PRODUCT_NAME = 'Sportsbook_app' and date_trunc(month, SESSION_DATE_ALK::timestamp_ltz) is not null group by PRODUCT_NAME, DATETRUNC_111, dateadd(month, -1, DATETRUNC_111)) Q1 group by DATETRUNC_111) Q2 order by DATETRUNC_112 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Product-Health-Hub-5K7wHNcDUTxTnU49MXx3Xu?:displayNodeId=Os4RYPJsoD","kind":"adhoc","request-id":"g019d73fbef79710a84e1f3958b66dda9","user-id":"XFnSY8L83Bb6SJzIJ82MNBv1Jmmyp","email":"Jaime.Meek@betfanatics.com"}
