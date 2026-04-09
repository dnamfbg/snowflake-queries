-- Query ID: 01c399d7-0212-67a9-24dd-0703192afc5b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:39:20.006000+00:00
-- Elapsed: 3185ms
-- Environment: FBG

select PRODUCT_NAME "Product Name", DATETRUNC_110 "Switch Date_Granularity_DM", COUNTDISTINCT_111 "Casino Sessions" from (select PRODUCT_NAME, date_trunc(month, SESSION_DATE_ALK::timestamp_ltz) DATETRUNC_110, count(distinct SESSION_UUID) COUNTDISTINCT_111 from FBG_ANALYTICS.CASINO.PHH_CASINO_SESSIONS_TO_GAME_LAUNCHES_REPORT where not CASINO_SUPER_VIP and PRODUCT_NAME in ('Casino_app', 'Sportsbook_app') group by PRODUCT_NAME, DATETRUNC_110) Q1 order by PRODUCT_NAME asc, DATETRUNC_110 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Product-Health-Hub-5K7wHNcDUTxTnU49MXx3Xu?:displayNodeId=0tJGqQugh6","kind":"adhoc","request-id":"g019d73f8837f7e14b4449294f6b1a961","user-id":"XFnSY8L83Bb6SJzIJ82MNBv1Jmmyp","email":"Jaime.Meek@betfanatics.com"}
