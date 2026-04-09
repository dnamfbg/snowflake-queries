-- Query ID: 01c39a1b-0212-6b00-24dd-0703193acddf
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:47:28.053000+00:00
-- Elapsed: 193ms
-- Environment: FBG

select DATETRUNC_124 "Time Period Filter", SUM_126 "Gross Fees", LAG_127 "Gross Fees Previous Period" from (select DATETRUNC_124, SUM_125 SUM_126, lag(SUM_125, 1) over ( order by DATETRUNC_124 asc) LAG_127 from (select date_trunc(day, ORDER_CREATED_AT_ALK::timestamp_ltz) DATETRUNC_124, sum(FILLED_FMX_FEES_USD) SUM_125 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_CORE_ORDERS where not IS_TEST_ACCOUNT and ORDER_CREATED_AT_ALK >= to_timestamp_ntz('2025-12-03 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and date_trunc(day, ORDER_CREATED_AT_ALK::timestamp_ltz) is not null group by DATETRUNC_124) Q1) Q2 order by DATETRUNC_124 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=5sPJLcU5Su","kind":"adhoc","request-id":"g019d7436e40f78c780414ded2cafcd63","user-id":"XfnJC4IXnEAdUPksdXltJAdCpOxa7","email":"louis.sutton@betfanatics.com"}
