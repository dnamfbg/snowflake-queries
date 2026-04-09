-- Query ID: 01c399c6-0212-6e7d-24dd-07031927aa23
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:22:22.218000+00:00
-- Elapsed: 100ms
-- Environment: FBG

select DATETRUNC_125 "Time Period", DIV_128 "Combo Volume %", LAG_129 "Handle Previous Period" from (select DATETRUNC_125, SUM_126 / nullif(SUM_127, 0) DIV_128, lag(DIV_128, 1) over ( order by DATETRUNC_125 asc) LAG_129 from (select date_trunc(day, ORDER_CREATED_AT_ALK::timestamp_ltz) DATETRUNC_125, sum(iff(SPORT_VS_OTHER = 'COMBOS', FILLED_HANDLE_USD, null)) SUM_126, sum(FILLED_HANDLE_USD) SUM_127 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_CORE_ORDERS where IS_TEST_ACCOUNT and not IS_TEST_ACCOUNT and ORDER_CREATED_AT >= to_timestamp_ntz('2026-03-10 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and ORDER_CREATED_AT <= to_timestamp_ntz('2026-04-08 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and date_trunc(day, ORDER_CREATED_AT_ALK::timestamp_ltz) is not null group by DATETRUNC_125) Q1) Q2 order by DATETRUNC_125 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=JZ7MUqDdxC","kind":"adhoc","request-id":"g019d73e8f7c57098a3046f153b786911","user-id":"SApx2czsCNSal7ZnQBRssii1lAl4g","email":"mateo.pedroza@betfanatics.com"}
