-- Query ID: 01c39a30-0212-644a-24dd-0703193ff0a3
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:08:08.312000+00:00
-- Elapsed: 775ms
-- Run Count: 2
-- Environment: FBG

create table FMX_ANALYTICS.STAGING.fmx_forecasts (DATE DATE,TRADE_FEES_FMX_USD bigint,TRADE_FEES_PARTNER_USD bigint,TOTAL_TRADE_FEES_USD bigint,DEPOSIT_FEES_USD bigint,INTEREST_INCOME_USD bigint,TOTAL_PROMO_SPEND_USD bigint,TOTAL_REVENUE_USD bigint,ACTIVES bigint,CONTRACTS_PLACED_SOLD bigint,CONTRACTS_PLACED_SOLD_AMT_USD bigint,AVERAGE_CONTRACT_PRICE FLOAT,DEPOSIT_COUNT bigint,DEPOSIT_USD bigint,TOTAL_FTUS bigint,ACQUISITION_PROMO_COST_USD bigint,MTD_ACTIVES bigint)
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "seed.dbt_fmx.fmx_forecasts", "profile_name": "user", "target_name": "default"} */
