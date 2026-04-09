-- Query ID: 01c399d2-0212-6dbe-24dd-0703192a2633
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:34:30.049000+00:00
-- Elapsed: 1623ms
-- Environment: FBG

select DATETRUNC_209 "Date Label", DIV_220 "Avg. APDs", DIV_218 "Avg. PDs", IF_219 "Avg. F2P Spins", SUM_221 "APDs", SUM_210 "PDs", DIV_222 HPA, DIV_223 BPA from (select date_trunc(day, SK_DATE::timestamp_ltz) DATETRUNC_209, sum(PDS) SUM_210, SUM_210 / nullif(count(distinct iff(iff(APDS > 0, 1, 0) = 1 or iff(APDS = 0 and PDS > 0, 1, 0) = 1, ACCO_ID, null)), 0) DIV_218, iff(sum(F2P_SESSIONS) > 0, sum(F2P_SESSIONS) / nullif(floor(count(distinct iff(iff(APDS > 0, 1, 0) = 1, ACCO_ID, null))), 0), null) IF_219, sum(APDS) / nullif(floor(count(distinct iff(iff(APDS > 0, 1, 0) = 1, ACCO_ID, null))), 0) DIV_220, sum(APDS) SUM_221, sum(CASH_HANDLE) / nullif(floor(count(distinct iff(iff(APDS > 0, 1, 0) = 1, ACCO_ID, null))), 0) DIV_222, sum(BET_COUNT) / nullif(floor(count(distinct iff(iff(APDS > 0, 1, 0) = 1, ACCO_ID, null))), 0) DIV_223 from FBG_ANALYTICS.CASINO.CASINO_BUSINESS_PERFORMANCE_REPORT where FTU_DATE >= to_date('2023-11-14', 'YYYY-MM-DD') and SK_DATE >= to_date('2026-01-01', 'YYYY-MM-DD') and SK_DATE <= to_date('2026-12-31', 'YYYY-MM-DD') and iff(CASINO_SUPER_VIP, 'Yes', 'No') = 'No' group by DATETRUNC_209) Q1 order by DATETRUNC_209 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Casino-Business-Performance-2mJaBcQR6v3yaSruLpDhVJ?:displayNodeId=tVXaHCqbZK","kind":"adhoc","request-id":"g019d73f412c477b5bab161b95f1e1aa6","user-id":"XFnSY8L83Bb6SJzIJ82MNBv1Jmmyp","email":"Jaime.Meek@betfanatics.com"}
