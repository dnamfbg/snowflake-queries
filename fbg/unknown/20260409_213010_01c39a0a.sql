-- Query ID: 01c39a0a-0212-6cb9-24dd-07031936e2b7
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:30:10.088000+00:00
-- Elapsed: 51ms
-- Environment: FBG

select COUNT_46 "row-count" from (select count(1) COUNT_46 from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_REVENUE_FLOW_THROUGH left join (select EHOLD_BUCKET, BUS_DATE::timestamp_ltz CAST_39 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_REVENUE_FLOW_DS) Q2 on try_to_timestamp_ltz(NEW_SEGMENTS_REVENUE_FLOW_THROUGH."DATE") = Q2.CAST_39 and NEW_SEGMENTS_REVENUE_FLOW_THROUGH.HOLD_BUCKET = Q2.EHOLD_BUCKET) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-Sample-34rdU89t8adkDkUiTTTdmE?:displayNodeId=fWuXrk-TIc","kind":"adhoc","request-id":"g019d74270c2073efbfd025eaae08c4fc","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
