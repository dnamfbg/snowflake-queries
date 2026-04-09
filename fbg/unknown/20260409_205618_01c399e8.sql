-- Query ID: 01c399e8-0212-6b00-24dd-0703192e5da3
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:56:18.194000+00:00
-- Elapsed: 792ms
-- Environment: FBG

select DATETRUNC_290 "Switch Date_Granularity_DM", SUM_292 "Game Launches", SUM_291 "Launches with Wager", SUM_293 "Launches with Cash Wager", DIV_297 "Launch > Wager %", V_295, DIV_294 "Launch > Wager Cash %" from (select date_trunc(month, SESSION_DATE_ALK::timestamp_ltz) DATETRUNC_290, sum(CONVERTED_GAME_LAUNCHES) SUM_291, sum(DISTINCT_GAME_LAUNCHES) SUM_292, sum(CASH_CONVERTED_GAME_LAUNCHES) SUM_293, SUM_293 / nullif(SUM_292, 0) DIV_294, true V_295, SUM_291 / nullif(SUM_292, 0) DIV_297 from FBG_ANALYTICS.CASINO.PHH_CASINO_SESSIONS_TO_GAME_LAUNCHES_REPORT where not CASINO_SUPER_VIP group by DATETRUNC_290) Q1 order by DATETRUNC_290 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Product-Health-Hub-5K7wHNcDUTxTnU49MXx3Xu?:displayNodeId=Xg4I-k57fx","kind":"adhoc","request-id":"g019d74080c58740290cd434d731dc805","user-id":"XFnSY8L83Bb6SJzIJ82MNBv1Jmmyp","email":"Jaime.Meek@betfanatics.com"}
