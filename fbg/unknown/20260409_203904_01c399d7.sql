-- Query ID: 01c399d7-0212-6b00-24dd-0703192ade8b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:39:04.690000+00:00
-- Elapsed: 2764ms
-- Environment: FBG

select CAST_110 "Switch Date_Granularity_DM", COUNTDISTINCT_113 "Casino Sessions", COUNTDISTINCT_114 "Sessions 1  Launch", COUNTDISTINCT_112 "Sessions 2+  Launches", COUNTDISTINCT_111 "Sessions FCS Only", COUNTDISTINCT_115 "Users", COUNTDISTINCT_116 "Users 1 Launch", COUNTDISTINCT_117 "Users  2+ Launches", COUNTDISTINCT_118 "Users FCS Only", DIV_120 "% Actives" from (select SESSION_WEEK_ALK::timestamp_ltz CAST_110, count(distinct iff(NO_FCS_LAUNCH_COUNT = 0 and FCS_LAUNCH_COUNT > 0, SESSION_UUID, null)) COUNTDISTINCT_111, count(distinct iff(DISTINCT_GAME_LAUNCHES >= 2, SESSION_UUID, null)) COUNTDISTINCT_112, count(distinct SESSION_UUID) COUNTDISTINCT_113, count(distinct iff(DISTINCT_GAME_LAUNCHES > 0, SESSION_UUID, null)) COUNTDISTINCT_114, count(distinct USER_ID) COUNTDISTINCT_115, count(distinct iff(DISTINCT_GAME_LAUNCHES > 0, USER_ID, null)) COUNTDISTINCT_116, count(distinct iff(DISTINCT_GAME_LAUNCHES >= 2, USER_ID, null)) COUNTDISTINCT_117, count(distinct iff(NO_FCS_LAUNCH_COUNT = 0 and FCS_LAUNCH_COUNT > 0, USER_ID, null)) COUNTDISTINCT_118, count(distinct iff(CASH_STAKE > 0, USER_ID, null)) / nullif(COUNTDISTINCT_115, 0) DIV_120 from FBG_ANALYTICS.CASINO.PHH_CASINO_SESSIONS_TO_GAME_LAUNCHES_REPORT where not CASINO_SUPER_VIP and SESSION_DATE_ALK >= to_timestamp_ntz('2026-02-23 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and SESSION_DATE_ALK <= to_timestamp_ntz('2026-04-05 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') group by CAST_110) Q1 order by CAST_110 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Product-Health-Hub-5K7wHNcDUTxTnU49MXx3Xu?:displayNodeId=69DzlfKEZC","kind":"adhoc","request-id":"g019d73f8476c77c7af64e71a5f912d6b","user-id":"XFnSY8L83Bb6SJzIJ82MNBv1Jmmyp","email":"Jaime.Meek@betfanatics.com"}
