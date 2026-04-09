-- Query ID: 01c39a30-0212-67a8-24dd-0703193fa74b
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:08:19.077000+00:00
-- Elapsed: 1357ms
-- Environment: FBG

create or replace   view FMX_ANALYTICS.STAGING.stg_kalshi_public_market
  
  
  
  
  as (
    with source as ( --noqa: disable=all
    select
        report_ticker,
        ticker_name,
        date::date as date,
        block_volume,
        daily_volume,
        high,
        low,
        open_interest,
        payout_type,
        status,
        source_file
    from FBG_SOURCE.KALSHI.KALSHI_PUBLIC_MARKET
    where date is not null
        and ticker_name is not null
)

select * from source
  )
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.stg_kalshi_public_market", "profile_name": "user", "target_name": "default"} */
