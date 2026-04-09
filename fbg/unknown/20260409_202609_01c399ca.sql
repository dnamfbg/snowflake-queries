-- Query ID: 01c399ca-0212-67a9-24dd-070319287233
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:26:09.425000+00:00
-- Elapsed: 151ms
-- Environment: FBG

select DATETRUNC_45 "Calc", DIV_49 "% Success Rate Volume" from (select date_trunc(day, ORDER_CREATED_AT_ALK::timestamp_ltz) DATETRUNC_45, sum(FILLED_HANDLE_USD) / nullif(sum(ATTEMPTED_HANDLE_USD), 0) DIV_49 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_COMBO_LEG_DETAILS where IS_TEST_ACCOUNT and date_trunc(day, ORDER_CREATED_AT_ALK::timestamp_ltz) is not null group by DATETRUNC_45) Q1 order by DATETRUNC_45 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=eotLd7rGMg","kind":"adhoc","request-id":"g019d73ec72e27c048fd66003e50bcc39","user-id":"SApx2czsCNSal7ZnQBRssii1lAl4g","email":"mateo.pedroza@betfanatics.com"}
