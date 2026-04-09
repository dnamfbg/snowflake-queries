-- Query ID: 01c399fe-0212-67a9-24dd-070319345333
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:18:48.280000+00:00
-- Elapsed: 2006ms
-- Environment: FBG

select COUNT_245 "count", SUM_246 "nullCount", COUNTDISTINCT_247 "ndv", MIN_248 "min", MAX_249 "max" from (select count(PB_MIGRATION_TYPE) COUNT_245, sum(iff(PB_MIGRATION_TYPE is null, 1, 0)) SUM_246, count(distinct PB_MIGRATION_TYPE) COUNTDISTINCT_247, min(PB_MIGRATION_TYPE) MIN_248, max(PB_MIGRATION_TYPE) MAX_249 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.ACQ_FTU_FUNNEL where not DUPLICATE_EXCLUDED_LIST_FLAG and (FBG_FTU_DATE < to_timestamp_ntz('2026-04-09 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') or FBG_FTU_DATE is null) and REG_DATE < to_timestamp_ntz('2026-04-09 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9')) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Acquisition-and-Early-Life-2LrpPTimXaYBOnlC7ctzXI?:displayNodeId=BCxLdrGDiO","kind":"adhoc","request-id":"g019d741ca52b76ba9f359e9383639ba1","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
