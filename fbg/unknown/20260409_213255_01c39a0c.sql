-- Query ID: 01c39a0c-0212-6cb9-24dd-070319377817
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:32:55.886000+00:00
-- Elapsed: 91ms
-- Environment: FBG

select CAST_11 "Bus Month", HIGH_LEVEL_SEGMENT "High Level Segment", CASH_ACTIVES "Cash Actives", CASH_HANDLE "Cash Handle", TOTAL_HANDLE "Total Handle", TRADING_WIN "Trading Win", TOTAL_GGR "Total Ggr", TRADING_NGR "Trading Ngr", ACQUISITION_COSTS "Acquisition Costs", RETENTION_COSTS "Retention Costs", MIGRATION_COSTS "Migration Costs" from (select HIGH_LEVEL_SEGMENT, CASH_ACTIVES, CASH_HANDLE, TOTAL_HANDLE, TRADING_WIN, TOTAL_GGR, TRADING_NGR, ACQUISITION_COSTS, RETENTION_COSTS, MIGRATION_COSTS, BUS_MONTH::timestamp_ltz CAST_11 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_MONTHLY_ACTUAL_DS) Q1 limit 112701

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-Sample-34rdU89t8adkDkUiTTTdmE?:displayNodeId=3K7dVDzYwm","kind":"adhoc","request-id":"g019d7429960a7b689186413bab919c54","user-id":"RJPpDi9ofjj2luRLdu0geI6rWoD5l","email":"Brett.Pendleton@betfanatics.com"}
