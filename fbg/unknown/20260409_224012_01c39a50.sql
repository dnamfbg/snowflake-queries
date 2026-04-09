-- Query ID: 01c39a50-0212-67a8-24dd-070319469a6f
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:40:12.821000+00:00
-- Elapsed: 153ms
-- Environment: FBG

select CAST_5 "Churn Week", HIGH_LEVEL_SEGMENT "High Level Segment", SPORTSLIFECYCLE "Sportslifecycle", ACTIVESLASTWEEK "Activeslastweek", OFWHICHACTIVETHISWEEK "Ofwhichactivethisweek" from (select HIGH_LEVEL_SEGMENT, SPORTSLIFECYCLE, ACTIVESLASTWEEK, OFWHICHACTIVETHISWEEK, CHURN_WEEK::timestamp_ltz CAST_5 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_WEEKLY_RETENTION_DS) Q1 limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-Sample-34rdU89t8adkDkUiTTTdmE?:displayNodeId=2Rq71i9No9","kind":"adhoc","request-id":"g019d74672b8d7367a12afb2ba65bfdaf","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
