-- Query ID: 01c39a0f-0212-67a9-24dd-070319385407
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:35:19.867000+00:00
-- Elapsed: 86ms
-- Environment: FBG

select DATETRUNC_124 "Time Period Filter", DIV_128 "Gross Fees Per Active", LAG_129 "Gross Fees Per Active Previous Period" from (select DATETRUNC_124, SUM_125 / nullif(COUNTDISTINCT_126, 0) DIV_128, lag(DIV_128, 1) over ( order by DATETRUNC_124 asc) LAG_129 from (select date_trunc(day, ORDER_CREATED_AT_ALK::timestamp_ltz) DATETRUNC_124, sum(FILLED_FMX_FEES_USD) SUM_125, count(distinct iff(ORDER_STATUS = 'COMPLETED', ACCOUNT_ID, null)) COUNTDISTINCT_126 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_CORE_ORDERS where not IS_TEST_ACCOUNT and ORDER_CREATED_AT_ALK >= to_timestamp_ntz('2026-03-10 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and ORDER_CREATED_AT_ALK <= to_timestamp_ntz('2026-04-08 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and date_trunc(day, ORDER_CREATED_AT_ALK::timestamp_ltz) is not null group by DATETRUNC_124) Q1) Q2 order by DATETRUNC_124 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=DDEFGhOVdT","kind":"adhoc","request-id":"g019d742bc4b576698784d2f620b6c219","user-id":"upxSWBvFzGQ3hkOD2R8HTLHwY6Hwy","email":"karissa.chabalie@betfanatics.com"}
