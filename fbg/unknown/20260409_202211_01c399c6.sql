-- Query ID: 01c399c6-0212-67a8-24dd-07031927d11f
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:22:11.452000+00:00
-- Elapsed: 72ms
-- Environment: FBG

select CAST_23 "Bus Date", EHOLD_BUCKET "Ehold Bucket", HANDLE_REV "Handle Rev", TW_REV "Tw Rev", ETW_REV "Etw Rev", GGR_REV "Ggr Rev", GGR_OC "Ggr Oc", EGGR_REV "Eggr Rev", NGR_REV "Ngr Rev", ENGR_REV "Engr Rev", BOOSTS_REV "Boosts Rev", ACQUISITION_REV "Acquisition Rev", RETENTION_REV "Retention Rev", TAX_REV "Tax Rev", ETAX_REV "Etax Rev", CVP_REV "Cvp Rev", ECVP_REV "Ecvp Rev", COGS_REV "Cogs Rev", ECOGS_REV "Ecogs Rev", NGR_AFTER_TAX_REV "Ngr After Tax Rev", ENGR_AFTER_TAX_REV "Engr After Tax Rev", OSB_CVP_REV "Osb Cvp Rev", OSB_ECVP_REV "Osb Ecvp Rev" from (select EHOLD_BUCKET, HANDLE_REV, TW_REV, ETW_REV, GGR_REV, GGR_OC, EGGR_REV, NGR_REV, ENGR_REV, BOOSTS_REV, ACQUISITION_REV, RETENTION_REV, TAX_REV, ETAX_REV, CVP_REV, ECVP_REV, COGS_REV, ECOGS_REV, NGR_AFTER_TAX_REV, ENGR_AFTER_TAX_REV, OSB_CVP_REV, OSB_ECVP_REV, BUS_DATE::timestamp_ltz CAST_23 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_REVENUE_FLOW_DS) Q1 limit 55701

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-1-34rdU89t8adkDkUiTTTdmE?:displayNodeId=eQrOYscwG_","kind":"adhoc","request-id":"g019d73e8d01f7f968d270f654478e5b0","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
