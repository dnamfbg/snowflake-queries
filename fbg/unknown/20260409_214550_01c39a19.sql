-- Query ID: 01c39a19-0212-6cb9-24dd-0703193ab73f
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:45:50.952000+00:00
-- Elapsed: 51ms
-- Environment: FBG

select CAST_23 "Bus Date", EHOLD_BUCKET "Ehold Bucket", HANDLE_REV "Handle Rev", TW_REV "Tw Rev", ETW_REV "Etw Rev", GGR_REV "Ggr Rev", GGR_OC "Ggr Oc", EGGR_REV "Eggr Rev", NGR_REV "Ngr Rev", ENGR_REV "Engr Rev", BOOSTS_REV "Boosts Rev", ACQUISITION_REV "Acquisition Rev", RETENTION_REV "Retention Rev", TAX_REV "Tax Rev", ETAX_REV "Etax Rev", CVP_REV "Cvp Rev", ECVP_REV "Ecvp Rev", COGS_REV "Cogs Rev", ECOGS_REV "Ecogs Rev", NGR_AFTER_TAX_REV "Ngr After Tax Rev", ENGR_AFTER_TAX_REV "Engr After Tax Rev", OSB_CVP_REV "Osb Cvp Rev", OSB_ECVP_REV "Osb Ecvp Rev" from (select EHOLD_BUCKET, HANDLE_REV, TW_REV, ETW_REV, GGR_REV, GGR_OC, EGGR_REV, NGR_REV, ENGR_REV, BOOSTS_REV, ACQUISITION_REV, RETENTION_REV, TAX_REV, ETAX_REV, CVP_REV, ECVP_REV, COGS_REV, ECOGS_REV, NGR_AFTER_TAX_REV, ENGR_AFTER_TAX_REV, OSB_CVP_REV, OSB_ECVP_REV, BUS_DATE::timestamp_ltz CAST_23 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_REVENUE_FLOW_DS) Q1 limit 55701

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-Sample-34rdU89t8adkDkUiTTTdmE?:displayNodeId=eQrOYscwG_","kind":"adhoc","request-id":"g019d743569117900b15d126415fc46e2","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
