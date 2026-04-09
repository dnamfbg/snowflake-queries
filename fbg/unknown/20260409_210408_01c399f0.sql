-- Query ID: 01c399f0-0212-67a8-24dd-07031930794f
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:04:08.570000+00:00
-- Elapsed: 169ms
-- Environment: FBG

select CASE_TYPE "Case Type", AVG_58 "Avg .CSAT %", DIV_61 "CSAT +", COUNTDISTINCT_57 "Distinct Count of Case Number", COUNTDISTINCT_62 "sort-Pxo1ktGc9w-0" from (select CASE_TYPE, count(distinct CASE_NUMBER) COUNTDISTINCT_57, avg((try_to_double(CSAT) * 20) / 100) AVG_58, sum(iff(try_to_double(CSAT) in (5, 4), 1, 0)) / nullif(sum(iff(try_to_double(CSAT) in (1, 2), 1, 0)), 0) DIV_61, COUNTDISTINCT_57 COUNTDISTINCT_62 from FBG_ANALYTICS.OPERATIONS.CSAT_REPORTING where CASE_TYPE = 'Casino Errors' and CASE_STATUS = 'Resolved' and AGENT_NAME in ('Brett Hooper', 'Paul Plescia', 'Victor Centeno Fernandez') and CLOSED_DATE >= to_timestamp_ntz('2025-11-01 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and CLOSED_DATE <= to_timestamp_ntz('2026-04-30 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') group by CASE_TYPE) Q1 order by COUNTDISTINCT_62 desc nulls last, CASE_TYPE asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/CSAT-Dashboard-1Vrb939sp8pEMmrta4ybzV?:displayNodeId=7rPLFEBob2","kind":"adhoc","request-id":"g019d740f3a5f790986de9010f2e40224","user-id":"3TyUofBuuSbc350EhKutQIJywtJzn","email":"edwin.vargas@betfanatics.com"}
