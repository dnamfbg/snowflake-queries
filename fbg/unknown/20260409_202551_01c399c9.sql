-- Query ID: 01c399c9-0212-6cb9-24dd-07031928460b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:25:51.096000+00:00
-- Elapsed: 69ms
-- Environment: FBG

select CAST_5 "Churn Week", HIGH_LEVEL_SEGMENT "High Level Segment", SPORTSLIFECYCLE "Sportslifecycle", ACTIVESLASTWEEK "Activeslastweek", OFWHICHACTIVETHISWEEK "Ofwhichactivethisweek" from (select HIGH_LEVEL_SEGMENT, SPORTSLIFECYCLE, ACTIVESLASTWEEK, OFWHICHACTIVETHISWEEK, CHURN_WEEK::timestamp_ltz CAST_5 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_WEEKLY_RETENTION_DS) Q1 limit 218401

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-1-34rdU89t8adkDkUiTTTdmE?:displayNodeId=2Rq71i9No9","kind":"adhoc","request-id":"g019d73ec2c2e733eb5e518ab856f474e","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
