-- Query ID: 01c399fb-0212-6cb9-24dd-07031933b377
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:15:48.639000+00:00
-- Elapsed: 246ms
-- Environment: FBG

select DATETRUNC_124 "Time Period", SUM_128 "$ Filled Handle", LAG_131 "Handle Previous Period", COUNTDISTINCT_125 "Actives", LAG_132 "Actives Previous Period", COUNTDISTINCT_126 "FTUs", LAG_133 "FTUs Previous Period" from (select DATETRUNC_124, COUNTDISTINCT_125, COUNTDISTINCT_126, SUM_127 SUM_128, lag(SUM_127, 1) over ( order by DATETRUNC_124 asc) LAG_131, lag(COUNTDISTINCT_125, 1) over ( order by DATETRUNC_124 asc) LAG_132, lag(COUNTDISTINCT_126, 1) over ( order by DATETRUNC_124 asc) LAG_133 from (select date_trunc(week, ORDER_CREATED_AT_ALK::timestamp_ltz) DATETRUNC_124, count(distinct iff(ORDER_STATUS = 'COMPLETED', ACCOUNT_ID, null)) COUNTDISTINCT_125, count(distinct iff(ORDER_STATUS = 'COMPLETED' and IS_FIRST_COMPLETED_TRADE, ACCOUNT_ID, null)) COUNTDISTINCT_126, sum(FILLED_HANDLE_USD) SUM_127 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_CORE_ORDERS where not IS_TEST_ACCOUNT and ORDER_CREATED_AT_ALK >= to_timestamp_ntz('2026-03-10 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and ORDER_CREATED_AT_ALK <= to_timestamp_ntz('2026-04-08 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and date_trunc(week, ORDER_CREATED_AT_ALK::timestamp_ltz) is not null group by DATETRUNC_124) Q1) Q2 order by DATETRUNC_124 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=Dp_4KzrlUo","kind":"adhoc","request-id":"g019d7419e8d17124adadb441baa851ed","user-id":"upxSWBvFzGQ3hkOD2R8HTLHwY6Hwy","email":"karissa.chabalie@betfanatics.com"}
