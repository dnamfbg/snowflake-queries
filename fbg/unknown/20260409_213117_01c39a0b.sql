-- Query ID: 01c39a0b-0212-6cb9-24dd-07031936ec87
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:31:17.569000+00:00
-- Elapsed: 46ms
-- Environment: FBG

select CAST_11 "Bus Date Fc", CASH_HANDLE_FC, X_TW_FC "X Tw Fc", X_TW_WO_FAIRNESS "X Tw Wo Fairness", TW_FC "Tw Fc", TW_WO_FAIRNESS "Tw Wo Fairness", SUB_9 "Expected Fairness Cost", SUB_10 "Fairness Cost" from (select CASH_HANDLE_FC, X_TW_FC, X_TW_WO_FAIRNESS, TW_FC, TW_WO_FAIRNESS, X_TW_WO_FAIRNESS - X_TW_FC SUB_9, TW_WO_FAIRNESS - TW_FC SUB_10, BUS_DATE_FC::timestamp_ltz CAST_11 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_FAIRNESS_DS) Q1 limit 161301

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-Sample-34rdU89t8adkDkUiTTTdmE?:displayNodeId=Fao0Lu4ASB","kind":"adhoc","request-id":"g019d742815337eea97c03a665a9448eb","user-id":"RJPpDi9ofjj2luRLdu0geI6rWoD5l","email":"Brett.Pendleton@betfanatics.com"}
