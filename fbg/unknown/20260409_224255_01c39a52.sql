-- Query ID: 01c39a52-0212-67a8-24dd-0703194752ab
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:42:55.033000+00:00
-- Elapsed: 65ms
-- Environment: FBG

select COUNT_144 "row-count" from (select count(1) COUNT_144 from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_DAILY_FORECAST full join (select OSB_SEGMENT, BUS_DATE::timestamp_ltz CAST_48 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_DAILY_DS) Q2 on try_to_timestamp_ltz(NEW_SEGMENTS_DAILY_FORECAST."DATE") = Q2.CAST_48 and NEW_SEGMENTS_DAILY_FORECAST.USER_SEGMENT = Q2.OSB_SEGMENT left join FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_DAILY_TARGETS Q4 on NEW_SEGMENTS_DAILY_FORECAST."DATE" = Q4.DATE_TARGET left join (select BUS_DATE_FC::timestamp_ltz CAST_100 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_FAIRNESS_DS) Q6 on try_to_timestamp_ltz(NEW_SEGMENTS_DAILY_FORECAST.WEEK_NUM) = Q6.CAST_100 left join (select BUS_DATE::timestamp_ltz CAST_140 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_MTD_PL_DS) Q8 on try_to_timestamp_ltz(NEW_SEGMENTS_DAILY_FORECAST."DATE") = Q8.CAST_140) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-Sample-34rdU89t8adkDkUiTTTdmE?:displayNodeId=ANVUwethcR","kind":"adhoc","request-id":"g019d7469a8ba7e5a99129b425f417121","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
