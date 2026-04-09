-- Query ID: 01c39a05-0212-6dbe-24dd-070319359907
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:25:18.762000+00:00
-- Elapsed: 99ms
-- Environment: FBG

select WEEK_NUM "Week Num", "DATE" "Date", "MONTH" "Month", USER_SEGMENT "User Segment", CASH_HANDLE_PERC "Cash Handle Perc", CASH_HANDLE "Cash Handle", TRADING_WIN "Trading Win", TRADING_NGR "Trading Ngr", FTUS "Ftus", ACTIVES "Actives", MTD_ACTIVES "Mtd Actives", NEW_UNIQUE_ACTIVES "New Unique Actives", AQUISITION_COSTS "Aquisition Costs", RETENTION_COSTS "Retention Costs", MIGRATION_COSTS "Migration Costs", BOOST_COST "Boost Cost", MTD_RETENTION "Mtd Retention", DW_LAST_UPDATED "Dw Last Updated" from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_DAILY_FORECAST Q1 limit 64701

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-1-34rdU89t8adkDkUiTTTdmE?:displayNodeId=5SAekecTs9","kind":"adhoc","request-id":"g019d74229ac3764ab8b4d60e57f23e57","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
