-- Query ID: 01c399c7-0212-6b00-24dd-07031927e4cf
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:23:26.658000+00:00
-- Elapsed: 89ms
-- Environment: FBG

select CAST_21 "Bus Week", HIGH_LEVEL_SEGMENT "High Level Segment", ACTIVITY_SEGMENT "Activity Segment", FTUS "Ftus", CASH_HANDLE "Cash Handle", TRADING_WIN "TRADING_WIN (Custom SQL Query)", EXP_TRADING_WIN "Exp Trading Win", TRADING_NGR "Trading Ngr", TRADING_ENR "Trading Enr", LUCK_ALL "Luck All", RETENTION_COSTS "Retention Costs", ACQUISITION_COSTS "Acquisition Costs", MIGRATION_COSTS "Migration Costs", EXP_RETENTION_COSTS_WEEKLY "Exp Retention Costs Weekly", EXP_ACQUISITION_COSTS_WEEKLY "Exp Acquisition Costs Weekly", EXP_MIGRATION_COSTS_WEEKLY "Exp Migration Costs Weekly", ACTIVES "ACTIVES (Custom SQL Query)", NEW_ACTIVES "New Actives", REACTIVATIONS_ACTIVES "Reactivations Actives", RETAINED_ACTIVES "Retained Actives", ACTIVES_LAST_WEEK "Actives Last Week" from (select HIGH_LEVEL_SEGMENT, ACTIVITY_SEGMENT, FTUS, CASH_HANDLE, TRADING_WIN, EXP_TRADING_WIN, TRADING_NGR, TRADING_ENR, LUCK_ALL, RETENTION_COSTS, ACQUISITION_COSTS, MIGRATION_COSTS, EXP_RETENTION_COSTS_WEEKLY, EXP_ACQUISITION_COSTS_WEEKLY, EXP_MIGRATION_COSTS_WEEKLY, ACTIVES, NEW_ACTIVES, REACTIVATIONS_ACTIVES, RETAINED_ACTIVES, ACTIVES_LAST_WEEK, BUS_WEEK::timestamp_ltz CAST_21 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_WEEKLY_DS) Q1 limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-1-34rdU89t8adkDkUiTTTdmE?:displayNodeId=SBATYcw-h2","kind":"adhoc","request-id":"g019d73e9f7dc736fa564ba9624c4f302","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
