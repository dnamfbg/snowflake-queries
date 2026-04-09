-- Query ID: 01c39a11-0212-6e7d-24dd-0703193901e3
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:37:49.947000+00:00
-- Elapsed: 215ms
-- Environment: FBG

select KYC_STATE "TopK Value", COUNT_9 "TopK Count", ISNULL_14 "TopK Null Sort" from (select *, KYC_STATE is null ISNULL_14 from (select KYC_STATE, count(1) COUNT_9 from FBG_REPORTS.REGULATORY.NON_OFAC_WATCHLIST where DW_CREATION_DATE >= to_timestamp_ntz('2026-04-08 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and DW_CREATION_DATE <= to_timestamp_ntz('2026-04-08 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') group by KYC_STATE) Q1) Q2 order by ISNULL_14 desc, KYC_STATE asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Non-OFAC-Watchlist-5pAeUHyVszydw7aXDq36aj","kind":"adhoc","request-id":"g019d742e128c788d907e0c6d813c2a0e","user-id":"DPKxzyCylYg9tiUNxNygASY92VR1B","email":"john.zhu@betfanatics.com"}
