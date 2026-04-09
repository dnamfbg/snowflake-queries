-- Query ID: 01c39a0b-0212-644a-24dd-070319370abb
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:31:42.591000+00:00
-- Elapsed: 98ms
-- Environment: FBG

select COUNT_13 "row-count" from (select count(1) COUNT_13 from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_WEEKLY_RETENTION right join (select HIGH_LEVEL_SEGMENT, SPORTSLIFECYCLE, CHURN_WEEK::timestamp_ltz CAST_11 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_WEEKLY_RETENTION_DS) Q2 on try_to_timestamp_ltz(NEW_SEGMENTS_WEEKLY_RETENTION.WEEK_DATE) = Q2.CAST_11 and NEW_SEGMENTS_WEEKLY_RETENTION.USER_SEGMENT = Q2.HIGH_LEVEL_SEGMENT and NEW_SEGMENTS_WEEKLY_RETENTION.LIFECYCLE = Q2.SPORTSLIFECYCLE) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-Sample-34rdU89t8adkDkUiTTTdmE?:displayNodeId=FLIThpx7-y","kind":"adhoc","request-id":"g019d74287640796bb749c47ca7860c80","user-id":"RJPpDi9ofjj2luRLdu0geI6rWoD5l","email":"Brett.Pendleton@betfanatics.com"}
