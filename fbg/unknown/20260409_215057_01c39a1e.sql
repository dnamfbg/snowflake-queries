-- Query ID: 01c39a1e-0212-6e7d-24dd-0703193bd877
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:50:57.203000+00:00
-- Elapsed: 118ms
-- Environment: FBG

select DATETRUNC_124 "Time Period Filter", COUNTDISTINCT_125 "# Filled Trades", LAG_126 "# Filled Trades period before" from (select DATETRUNC_124, COUNTDISTINCT_125, lag(COUNTDISTINCT_125, 1) over ( order by DATETRUNC_124 asc) LAG_126 from (select date_trunc(day, ORDER_CREATED_AT_ALK::timestamp_ltz) DATETRUNC_124, count(distinct iff(ORDER_STATUS = 'COMPLETED', ORDER_ID, null)) COUNTDISTINCT_125 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_CORE_ORDERS where not IS_TEST_ACCOUNT and (SPORT_VS_OTHER in ('SPORT', 'OTHER') or SPORT_VS_OTHER is null) and IS_FIRST_ATTEMPTED_TRADE is not null and (ORDER_CREATED_AT_ALK >= to_timestamp_ntz('2026-03-10 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and ORDER_CREATED_AT_ALK <= to_timestamp_ntz('2026-04-08 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') or ORDER_CREATED_AT_ALK is null) and date_trunc(day, ORDER_CREATED_AT_ALK::timestamp_ltz) is not null group by DATETRUNC_124) Q1) Q2 order by DATETRUNC_124 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=5isoJXHMtV","kind":"adhoc","request-id":"g019d743a0bf17ae8afbb1cc4b7572bee","user-id":"GaIA9yeflWqMZyzjRqnQStQnKmlYD","email":"Michael.Francisco@betfanatics.com"}
