-- Query ID: 01c399df-0212-644a-24dd-0703192cd9c7
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:47:44.634000+00:00
-- Elapsed: 1375ms
-- Environment: FBG

select ACCO_ID "TopK Value", COUNT_183 "TopK Count", ISNULL_188 "TopK Null Sort" from (select *, ACCO_ID is null ISNULL_188 from (select ACCO_ID, count(1) COUNT_183 from FBG_ANALYTICS.CASINO.CASINO_SPIN_TO_WIN_DS where JURISDICTION_CODE in ('MI', 'NJ', 'PA', 'WV') and "DAY" >= to_timestamp_ntz('2026-04-04 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') group by ACCO_ID) Q1) Q2 order by ISNULL_188 desc, ACCO_ID asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Spin-To-Win-Dashboard-50B3V4sLL9WhXdjq0UdTrN","kind":"adhoc","request-id":"g019d740036c87e15b8da5d1a04cd1683","user-id":"3TyUofBuuSbc350EhKutQIJywtJzn","email":"edwin.vargas@betfanatics.com"}
