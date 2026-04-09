-- Query ID: 01c399cf-0212-67a8-24dd-07031929858b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:31:44.015000+00:00
-- Elapsed: 1531ms
-- Environment: FBG

select COUNT_28 "row-count" from (select count(1) COUNT_28 from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_MONTHY_FORECAST left join (select HIGH_LEVEL_SEGMENT, BUS_MONTH::timestamp_ltz CAST_24 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_MONTHLY_ACTUAL_DS) Q2 on try_to_timestamp_ltz(NEW_SEGMENTS_MONTHY_FORECAST.MONTH_DATE) = Q2.CAST_24 and NEW_SEGMENTS_MONTHY_FORECAST.USER_SEGMENT = Q2.HIGH_LEVEL_SEGMENT) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-1q0KELPDUp3VLveHb0w7MT?:displayNodeId=37a_JoK8iW","kind":"adhoc","request-id":"g019d73f18c9f766bbe20d2b7318f7b0b","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
