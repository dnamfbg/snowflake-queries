-- Query ID: 01c39a30-0212-67a9-24dd-0703193fe2eb
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:08:22.160000+00:00
-- Elapsed: 865435ms
-- Run Count: 2
-- Environment: FBG

create or replace  table FMX_ANALYTICS.CUSTOMER.fct_fmx_crypto_market_quote_hourly
    
    
    
    as (with base as (
    select
        activity_hour_alk,
        symbol,
        best_bid_price,
        best_bid_size,
        best_ask_price,
        best_ask_size,
        best_price,
        yes_spread,
        yes_mid_price,
        has_bid,
        has_ask,
        ingest_timestamp
    from FMX_ANALYTICS.STAGING.int_fmx_crypto_market_quote_updates
    where
        ingest_timestamp is not null
        and symbol is not null
),

last_quote as (
    select
        activity_hour_alk,
        symbol,
        best_bid_price as last_best_bid_price,
        best_bid_size as last_best_bid_size,
        best_ask_price as last_best_ask_price,
        best_ask_size as last_best_ask_size,
        best_price as last_best_price,
        ingest_timestamp as last_quote_timestamp,
        yes_spread as last_spread,
        yes_mid_price as last_mid_price,
        has_bid as last_has_bid,
        has_ask as last_has_ask
    from base
    qualify row_number() over (
        partition by activity_hour_alk, symbol
        order by ingest_timestamp desc
    ) = 1
),

agg as (
    select
        activity_hour_alk,
        symbol,
        count(*) as update_count,
        sum(case when has_bid then 1 else 0 end) as has_bid_count,
        sum(case when has_ask then 1 else 0 end) as has_ask_count,
        sum(
            case when has_bid and has_ask then 1 else 0 end
        ) as has_both_count,
        avg(yes_spread) as avg_spread,
        min(yes_spread) as min_spread,
        max(yes_spread) as max_spread,
        avg(yes_mid_price) as avg_mid_price
    from base
    where activity_hour_alk is not null
    group by activity_hour_alk, symbol
)

select
    agg.activity_hour_alk,
    agg.symbol,
    agg.update_count,
    agg.has_bid_count,
    agg.has_ask_count,
    agg.has_both_count,
    agg.avg_spread,
    agg.min_spread,
    agg.max_spread,
    agg.avg_mid_price,
    last_quote.last_best_bid_price,
    last_quote.last_best_bid_size,
    last_quote.last_best_ask_price,
    last_quote.last_best_ask_size,
    last_quote.last_best_price,
    last_quote.last_spread,
    last_quote.last_mid_price,
    last_quote.last_has_bid,
    last_quote.last_has_ask,
    last_quote.last_quote_timestamp,
    date(agg.activity_hour_alk) as activity_date_alk
from agg
left join last_quote
    on
        agg.activity_hour_alk = last_quote.activity_hour_alk
        and agg.symbol = last_quote.symbol
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.fct_fmx_crypto_market_quote_hourly", "profile_name": "user", "target_name": "default"} */
