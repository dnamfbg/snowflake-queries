-- Query ID: 01c39a0d-0212-6dbe-24dd-070319371d87
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:33:00.200000+00:00
-- Elapsed: 121ms
-- Environment: FBG

select CAST_5 "Churn Week", HIGH_LEVEL_SEGMENT "High Level Segment", SPORTSLIFECYCLE "Sportslifecycle", ACTIVESLASTWEEK "Activeslastweek", OFWHICHACTIVETHISWEEK "Ofwhichactivethisweek" from (select HIGH_LEVEL_SEGMENT, SPORTSLIFECYCLE, ACTIVESLASTWEEK, OFWHICHACTIVETHISWEEK, CHURN_WEEK::timestamp_ltz CAST_5 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_WEEKLY_RETENTION_DS) Q1 limit 218401

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-Sample-34rdU89t8adkDkUiTTTdmE?:displayNodeId=2Rq71i9No9","kind":"adhoc","request-id":"g019d7429a6d37557b0d825eaad7bd92c","user-id":"RJPpDi9ofjj2luRLdu0geI6rWoD5l","email":"Brett.Pendleton@betfanatics.com"}
