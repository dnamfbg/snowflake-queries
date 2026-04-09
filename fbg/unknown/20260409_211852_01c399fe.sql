-- Query ID: 01c399fe-0212-644a-24dd-070319341927
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:18:52.055000+00:00
-- Elapsed: 381ms
-- Environment: FBG

select PB_MIGRATION_TYPE "TopK Value", COUNT_246 "TopK Count", ISNULL_251 "TopK Null Sort" from (select *, PB_MIGRATION_TYPE is null ISNULL_251 from (select PB_MIGRATION_TYPE, count(1) COUNT_246 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.ACQ_FTU_FUNNEL where not DUPLICATE_EXCLUDED_LIST_FLAG and (FBG_FTU_DATE < to_timestamp_ntz('2026-04-09 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') or FBG_FTU_DATE is null) and REG_DATE < to_timestamp_ntz('2026-04-09 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') group by PB_MIGRATION_TYPE) Q1) Q2 order by ISNULL_251 desc, COUNT_246 desc, PB_MIGRATION_TYPE asc limit 1001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Acquisition-and-Early-Life-2LrpPTimXaYBOnlC7ctzXI","kind":"adhoc","request-id":"g019d741cb03a78fc98fdf0664f585f26","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
