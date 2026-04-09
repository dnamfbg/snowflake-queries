-- Query ID: 01c399ec-0212-644a-24dd-0703192f4cb7
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:00:04.088000+00:00
-- Elapsed: 161ms
-- Environment: FBG

select CASE_SUBTYPE "Case Subtype", AVG_58 "Avg .CSAT %", DIV_61 "CSAT +", COUNTDISTINCT_57 "Distinct Count of Case Number", COUNTDISTINCT_62 "sort-Pxo1ktGc9w-0" from (select CASE_SUBTYPE, count(distinct CASE_NUMBER) COUNTDISTINCT_57, avg((try_to_double(CSAT) * 20) / 100) AVG_58, sum(iff(try_to_double(CSAT) in (5, 4), 1, 0)) / nullif(sum(iff(try_to_double(CSAT) in (1, 2), 1, 0)), 0) DIV_61, COUNTDISTINCT_57 COUNTDISTINCT_62 from FBG_ANALYTICS.OPERATIONS.CSAT_REPORTING where CASE_SUBTYPE in ('Casino Promotions', 'Casino Errors', 'iCasino', 'Casino Spin to Win', 'Casino Payout', 'Casino Credit', 'Casino Integrity/Rules', 'Casino FanCash Spins', 'Casino Support', 'Casino Promotion') and CASE_STATUS = 'Resolved' and CLOSED_DATE >= to_timestamp_ntz('2026-04-01 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and CLOSED_DATE <= to_timestamp_ntz('2026-04-30 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') group by CASE_SUBTYPE) Q1 order by COUNTDISTINCT_62 desc nulls last, CASE_SUBTYPE asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/CSAT-Dashboard-1Vrb939sp8pEMmrta4ybzV?:displayNodeId=SvrhS0dntV","kind":"adhoc","request-id":"g019d740b7df1743a9f3caed17cda5a7d","user-id":"3TyUofBuuSbc350EhKutQIJywtJzn","email":"edwin.vargas@betfanatics.com"}
