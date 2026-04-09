-- Query ID: 01c399ef-0212-6b00-24dd-07031930a0af
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:03:54.551000+00:00
-- Elapsed: 129ms
-- Environment: FBG

select CASE_NUMBER "Case Number", AGENT_NAME, ACCOUNT_ID "Account ID", DATETRUNC_57 "Closed Date", CASE_TYPE "Case Type", CASE_SUBTYPE "Case Subtype", ADDITIONAL_COMMENTS__C "Additional Comments", ISSUE_RESOLVED__C "Issue Resolved?", AVG_58 "CSAT Score" from (select CASE_NUMBER, ACCOUNT_ID, CASE_TYPE, CASE_SUBTYPE, ISSUE_RESOLVED__C, ADDITIONAL_COMMENTS__C, AGENT_NAME, date_trunc(day, CLOSED_DATE::timestamp_ltz) DATETRUNC_57, avg((try_to_double(CSAT) * 20) / 100) AVG_58 from FBG_ANALYTICS.OPERATIONS.CSAT_REPORTING where AGENT_NAME in ('Brett Hooper', 'Paul Plescia') and CASE_STATUS = 'Resolved' and CASE_TYPE = 'Casino Errors' and date_trunc(day, CLOSED_DATE::timestamp_ltz) >= to_timestamp_ltz('2025-11-01T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and date_trunc(day, CLOSED_DATE::timestamp_ltz) <= to_timestamp_ltz('2026-04-30T23:59:59.999000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') group by AGENT_NAME, CASE_TYPE, CASE_NUMBER, ACCOUNT_ID, CASE_SUBTYPE, ADDITIONAL_COMMENTS__C, ISSUE_RESOLVED__C, DATETRUNC_57) Q1 order by CASE_NUMBER asc, AGENT_NAME desc nulls last, ACCOUNT_ID asc, DATETRUNC_57 asc, CASE_TYPE asc, CASE_SUBTYPE asc, ADDITIONAL_COMMENTS__C asc, ISSUE_RESOLVED__C asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/CSAT-Dashboard-1Vrb939sp8pEMmrta4ybzV?:displayNodeId=QnINbIVEIH","kind":"adhoc","request-id":"g019d740f038970fe816ac65b18a803bd","user-id":"3TyUofBuuSbc350EhKutQIJywtJzn","email":"edwin.vargas@betfanatics.com"}
