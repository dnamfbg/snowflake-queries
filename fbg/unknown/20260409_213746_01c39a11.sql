-- Query ID: 01c39a11-0212-6b00-24dd-07031938adef
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:37:46.121000+00:00
-- Elapsed: 397ms
-- Environment: FBG

select DATETRUNC_8 "DW Creation Date", ACCOUNT_ID "Account ID", KYC_STATE "KYC State", EXTERNAL_REF "External Ref", DECISION "Decision" from (select distinct ACCOUNT_ID, EXTERNAL_REF, KYC_STATE, DECISION, date_trunc(second, DW_CREATION_DATE::timestamp_ltz) DATETRUNC_8 from FBG_REPORTS.REGULATORY.NON_OFAC_WATCHLIST where DW_CREATION_DATE >= to_timestamp_ntz('2026-04-08 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and DW_CREATION_DATE <= to_timestamp_ntz('2026-04-08 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9')) Q1 order by DATETRUNC_8 asc nulls last, ACCOUNT_ID asc, KYC_STATE asc, EXTERNAL_REF asc, DECISION asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Non-OFAC-Watchlist-5pAeUHyVszydw7aXDq36aj?:displayNodeId=SptI1hmnff","kind":"adhoc","request-id":"g019d742e00fb7cd78c5622e420c7d197","user-id":"DPKxzyCylYg9tiUNxNygASY92VR1B","email":"john.zhu@betfanatics.com"}
