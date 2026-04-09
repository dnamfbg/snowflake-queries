-- Query ID: 01c39a0c-0212-67a8-24dd-07031937680b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:32:43.175000+00:00
-- Elapsed: 62ms
-- Environment: FBG

select CAST_11 "Bus Date Fc", CASH_HANDLE_FC, X_TW_FC "X Tw Fc", X_TW_WO_FAIRNESS "X Tw Wo Fairness", TW_FC "Tw Fc", TW_WO_FAIRNESS "Tw Wo Fairness", SUB_9 "Expected Fairness Cost", SUB_10 "Fairness Cost" from (select CASH_HANDLE_FC, X_TW_FC, X_TW_WO_FAIRNESS, TW_FC, TW_WO_FAIRNESS, X_TW_WO_FAIRNESS - X_TW_FC SUB_9, TW_WO_FAIRNESS - TW_FC SUB_10, BUS_DATE_FC::timestamp_ltz CAST_11 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_FAIRNESS_DS) Q1 limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-Sample-34rdU89t8adkDkUiTTTdmE?:displayNodeId=Fao0Lu4ASB","kind":"adhoc","request-id":"g019d742964587e52b7817c8e570297ba","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
