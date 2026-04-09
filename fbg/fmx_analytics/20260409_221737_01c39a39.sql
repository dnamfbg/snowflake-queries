-- Query ID: 01c39a39-0212-6cb9-24dd-0703194222b7
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:17:37.086000+00:00
-- Elapsed: 69581ms
-- Environment: FBG

create or replace  table FMX_ANALYTICS.CUSTOMER.orders_product_symbol_activity_hourly
    
    
    
    as (WITH symbol_bounds AS ( --noqa: disable=all
    SELECT
        COALESCE(MIN(activity_hour_alk), DATE_TRUNC('hour', CURRENT_TIMESTAMP() - INTERVAL '7 DAY')) AS min_hour,
        COALESCE(MAX(activity_hour_alk), DATE_TRUNC('hour', CURRENT_TIMESTAMP())) AS max_hour
    FROM FMX_ANALYTICS.CUSTOMER.orders_fmx_symbol_hourly_metrics
),

hour_spine AS (
    SELECT dh.activity_hour AS activity_hour
    FROM symbol_bounds AS b
    INNER JOIN FMX_ANALYTICS.DIMENSIONS.dim_hour AS dh
        ON dh.activity_hour BETWEEN b.min_hour AND b.max_hour
),

symbols AS (
    SELECT DISTINCT symbol
    FROM FMX_ANALYTICS.CUSTOMER.orders_fmx_symbol_hourly_metrics
    WHERE symbol IS NOT NULL
),

symbol_hour_spine AS (
    SELECT
        hs.activity_hour,
        s.symbol
    FROM hour_spine AS hs
    CROSS JOIN symbols AS s
),

base AS (
    SELECT
        activity_hour_alk AS activity_hour,
        activity_date_alk AS activity_date,
        symbol,
        COALESCE(total_contracts_buy_qty, 0) AS contracts_placed_qty,
        COALESCE(total_contracts_sold_qty, 0) AS contracts_sold_qty,
        COALESCE(total_contracts_traded_qty, 0) AS contracts_traded_qty,
        COALESCE(total_order_buys, 0) AS contracts_placed_amt,
        COALESCE(total_order_sold, 0) AS contracts_sold_amt,
        COALESCE(total_order_buys, 0) + COALESCE(total_order_sold, 0) AS contract_traded_amt,
        COALESCE(total_order_buy_count, 0) + COALESCE(total_order_sold_count, 0) AS contract_traded_count,
        COALESCE(actives, 0) AS actives
    FROM FMX_ANALYTICS.CUSTOMER.orders_fmx_symbol_hourly_metrics
),

spined AS (
    SELECT
        shs.activity_hour,
        DATE(shs.activity_hour) AS activity_date,
        shs.symbol,
        COALESCE(b.contracts_placed_qty, 0) AS contracts_placed_qty,
        COALESCE(b.contracts_sold_qty, 0) AS contracts_sold_qty,
        COALESCE(b.contracts_traded_qty, 0) AS contracts_traded_qty,
        COALESCE(b.contracts_placed_amt, 0) AS contracts_placed_amt,
        COALESCE(b.contracts_sold_amt, 0) AS contracts_sold_amt,
        COALESCE(b.contract_traded_amt, 0) AS contract_traded_amt,
        COALESCE(b.contract_traded_count, 0) AS contract_traded_count,
        COALESCE(b.actives, 0) AS actives
    FROM symbol_hour_spine AS shs
    LEFT JOIN base AS b
        ON
            shs.activity_hour = b.activity_hour
            AND shs.symbol = b.symbol
),

windowed AS (
    SELECT
        sp.*,
        SUM(contracts_traded_qty) OVER (
            PARTITION BY symbol
            ORDER BY activity_hour
            RANGE BETWEEN INTERVAL '23 HOURS' PRECEDING AND CURRENT ROW
        ) AS contract_traded_qty_24h,
        SUM(contracts_traded_qty) OVER (
            PARTITION BY symbol
            ORDER BY activity_hour
            RANGE BETWEEN INTERVAL '167 HOURS' PRECEDING AND CURRENT ROW
        ) AS contract_traded_qty_7d,
        SUM(contract_traded_amt) OVER (
            PARTITION BY symbol
            ORDER BY activity_hour
            RANGE BETWEEN INTERVAL '23 HOURS' PRECEDING AND CURRENT ROW
        ) AS contract_traded_amt_24h,
        SUM(contract_traded_amt) OVER (
            PARTITION BY symbol
            ORDER BY activity_hour
            RANGE BETWEEN INTERVAL '167 HOURS' PRECEDING AND CURRENT ROW
        ) AS contract_traded_amt_7d
    FROM spined AS sp
)

SELECT
    activity_hour,
    activity_date,
    symbol,
    contracts_placed_qty,
    contracts_sold_qty,
    contracts_traded_qty,
    contracts_placed_amt,
    contracts_sold_amt,
    contract_traded_amt,
    contract_traded_count,
    actives,
    contract_traded_qty_24h,
    contract_traded_qty_7d,
    contract_traded_amt_24h,
    contract_traded_amt_7d
FROM windowed
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.orders_product_symbol_activity_hourly", "profile_name": "user", "target_name": "default"} */
