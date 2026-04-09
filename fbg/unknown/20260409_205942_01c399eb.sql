-- Query ID: 01c399eb-0212-6b00-24dd-0703192eff57
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:59:42.204000+00:00
-- Elapsed: 477ms
-- Environment: FBG

select CASE_SUBTYPE "TopK Value", COUNT_58 "TopK Count", ISNULL_63 "TopK Null Sort", CASE_SUBTYPE_64 "Text Seach Column" from (select CASE_SUBTYPE, COUNT_58, CASE_SUBTYPE is null ISNULL_63, CASE_SUBTYPE CASE_SUBTYPE_64 from (select CASE_SUBTYPE, count(1) COUNT_58 from FBG_ANALYTICS.OPERATIONS.CSAT_REPORTING where contains(lower(CASE_SUBTYPE), lower('cas')) group by CASE_SUBTYPE) Q1) Q2 order by ISNULL_63 desc, COUNT_58 desc, CASE_SUBTYPE asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/CSAT-Dashboard-1Vrb939sp8pEMmrta4ybzV","kind":"adhoc","request-id":"g019d740b29e4729cb32298ffbd521a83","user-id":"3TyUofBuuSbc350EhKutQIJywtJzn","email":"edwin.vargas@betfanatics.com"}
