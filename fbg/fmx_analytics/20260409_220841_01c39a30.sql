-- Query ID: 01c39a30-0212-6dbe-24dd-0703193fc7eb
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:08:41.792000+00:00
-- Elapsed: 32994ms
-- Run Count: 2
-- Environment: FBG

create or replace  table FMX_ANALYTICS.CUSTOMER.fct_nadex_daily_metrics
    
    
    
    as (-- ─────────────────────────────────────────────────────────────────────────────
-- NADEX DAILY METRICS
-- Daily volume aggregates per symbol for all NADEX participants
-- (sourced from MARKET_TRADES_DATA_RAW Kafka feed via int_fmx_market_trades_symbol_daily).
-- Rolling 90-day window from current_date.
--
-- NADEX volume includes FMX customers + all other exchange participants.
-- NADEX volume >= FMX volume for any given symbol/day.
--
-- Labels joined from fct_fmx_market_labels (same markets as FMX).
-- ─────────────────────────────────────────────────────────────────────────────

with nadex as (
    select
        activity_date_alk as activity_date,
        symbol as market_symbol,
        trade_count as total_trades,
        total_contracts,
        total_dollar_volume as total_volume_usd
    from FMX_ANALYTICS.STAGING.int_fmx_market_trades_symbol_daily
    where activity_date_alk >= dateadd(day, -90, current_date())
)

select
    n.activity_date,
    n.market_symbol,
    l.markets_grouping,
    l.sport,
    l.market_type,
    l.sub_category,
    l.product_tier,
    l.sub_league,
    n.total_volume_usd,
    n.total_contracts,
    n.total_trades
from nadex as n
left join FMX_ANALYTICS.CUSTOMER.fct_fmx_market_labels as l
    on n.market_symbol = l.symbol
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.fct_nadex_daily_metrics", "profile_name": "user", "target_name": "default"} */
