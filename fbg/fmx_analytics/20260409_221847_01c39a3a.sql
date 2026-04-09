-- Query ID: 01c39a3a-0212-67a9-24dd-07031942561f
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:18:47.416000+00:00
-- Elapsed: 62752ms
-- Run Count: 2
-- Environment: FBG

create or replace  table FMX_ANALYTICS.PRODUCT.fct_fmx_product_catalog_overview_hourly_v2
    
    
    
    as (WITH symbol_activity AS ( --noqa: disable=all
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
    FROM FMX_ANALYTICS.CUSTOMER.orders_product_symbol_activity_hourly
),

markets AS (
    SELECT
        UPPER(cm.symbol) AS symbol,
        COALESCE(cm.predict_contract_type, 'UNKNOWN') AS contract_type,
        COALESCE(cm.markets_grouping, 'UNKNOWN') AS markets_grouping,
        COALESCE(cm.name, cm.title, cm.symbol) AS market_name
    FROM FMX_ANALYTICS.STAGING.stg_fmx_crypto_markets AS cm
),

symbol_with_meta AS (
    SELECT
        sa.activity_hour,
        sa.activity_date,
        sa.symbol,
        sa.contracts_placed_qty,
        sa.contracts_sold_qty,
        sa.contracts_traded_qty,
        sa.contracts_placed_amt,
        sa.contracts_sold_amt,
        sa.contract_traded_amt,
        sa.contract_traded_count,
        sa.actives,
        sa.contract_traded_qty_24h,
        sa.contract_traded_qty_7d,
        sa.contract_traded_amt_24h,
        sa.contract_traded_amt_7d,
        COALESCE(m.contract_type, 'UNKNOWN') AS contract_type,
        COALESCE(m.markets_grouping, 'UNKNOWN') AS markets_grouping,
        COALESCE(m.market_name, sa.symbol) AS market_name
    FROM symbol_activity AS sa
    LEFT JOIN markets AS m
        ON sa.symbol = m.symbol
),

contract_type_rollup AS (
    SELECT
        activity_hour,
        activity_date,
        contract_type,
        SUM(contracts_placed_qty) AS contracts_placed_qty,
        SUM(contracts_sold_qty) AS contracts_sold_qty,
        SUM(contracts_traded_qty) AS contracts_traded_qty,
        SUM(contracts_placed_amt) AS contracts_placed_amt,
        SUM(contracts_sold_amt) AS contracts_sold_amt,
        SUM(contract_traded_amt) AS contract_traded_amt,
        SUM(contract_traded_count) AS contract_traded_count,
        SUM(actives) AS actives
    FROM symbol_with_meta
    GROUP BY 1, 2, 3
),

markets_group_rollup AS (
    SELECT
        activity_hour,
        activity_date,
        markets_grouping,
        SUM(contracts_placed_qty) AS contracts_placed_qty,
        SUM(contracts_sold_qty) AS contracts_sold_qty,
        SUM(contracts_traded_qty) AS contracts_traded_qty,
        SUM(contracts_placed_amt) AS contracts_placed_amt,
        SUM(contracts_sold_amt) AS contracts_sold_amt,
        SUM(contract_traded_amt) AS contract_traded_amt,
        SUM(contract_traded_count) AS contract_traded_count,
        SUM(actives) AS actives
    FROM symbol_with_meta
    GROUP BY 1, 2, 3
),

symbol_last_7d AS (
    SELECT
        symbol,
        activity_hour,
        contract_traded_qty_7d
    FROM symbol_activity
),

coverage AS (
    SELECT
        sa.activity_hour,
        sa.activity_date,
        COUNT(DISTINCT sa.symbol) AS total_markets,
        COUNT(DISTINCT CASE WHEN COALESCE(sl.contract_traded_qty_7d, 0) > 0 THEN sa.symbol END)
            AS markets_with_trades_7d,
        COUNT(DISTINCT CASE WHEN COALESCE(sl.contract_traded_qty_7d, 0) = 0 THEN sa.symbol END)
            AS markets_zero_trades_7d
    FROM symbol_activity AS sa
    LEFT JOIN symbol_last_7d AS sl
        ON
            sa.symbol = sl.symbol
            AND sa.activity_hour = sl.activity_hour
    GROUP BY 1, 2
)

SELECT
    'symbol' AS grain,
    symbol,
    contract_type,
    markets_grouping,
    market_name,
    activity_hour,
    activity_date,
    DATEADD('day', 1, activity_hour) AS report_hour,
    CAST(DATEADD('day', 1, activity_hour) AS DATE) AS report_date,
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
    contract_traded_amt_7d,
    NULL AS total_markets,
    NULL AS markets_with_trades_7d,
    NULL AS markets_zero_trades_7d
FROM symbol_with_meta

UNION ALL

SELECT
    'contract_type' AS grain,
    NULL AS symbol,
    contract_type,
    NULL AS markets_grouping,
    NULL AS market_name,
    activity_hour,
    activity_date,
    DATEADD('day', 1, activity_hour) AS report_hour,
    CAST(DATEADD('day', 1, activity_hour) AS DATE) AS report_date,
    contracts_placed_qty,
    contracts_sold_qty,
    contracts_traded_qty,
    contracts_placed_amt,
    contracts_sold_amt,
    contract_traded_amt,
    contract_traded_count,
    actives,
    NULL AS contract_traded_qty_24h,
    NULL AS contract_traded_qty_7d,
    NULL AS contract_traded_amt_24h,
    NULL AS contract_traded_amt_7d,
    NULL AS total_markets,
    NULL AS markets_with_trades_7d,
    NULL AS markets_zero_trades_7d
FROM contract_type_rollup

UNION ALL

SELECT
    'markets_grouping' AS grain,
    NULL AS symbol,
    NULL AS contract_type,
    markets_grouping,
    NULL AS market_name,
    activity_hour,
    activity_date,
    DATEADD('day', 1, activity_hour) AS report_hour,
    CAST(DATEADD('day', 1, activity_hour) AS DATE) AS report_date,
    contracts_placed_qty,
    contracts_sold_qty,
    contracts_traded_qty,
    contracts_placed_amt,
    contracts_sold_amt,
    contract_traded_amt,
    contract_traded_count,
    actives,
    NULL AS contract_traded_qty_24h,
    NULL AS contract_traded_qty_7d,
    NULL AS contract_traded_amt_24h,
    NULL AS contract_traded_amt_7d,
    NULL AS total_markets,
    NULL AS markets_with_trades_7d,
    NULL AS markets_zero_trades_7d
FROM markets_group_rollup

UNION ALL

SELECT
    'coverage' AS grain,
    NULL AS symbol,
    NULL AS contract_type,
    NULL AS markets_grouping,
    NULL AS market_name,
    activity_hour,
    activity_date,
    DATEADD('day', 1, activity_hour) AS report_hour,
    CAST(DATEADD('day', 1, activity_hour) AS DATE) AS report_date,
    NULL AS contracts_placed_qty,
    NULL AS contracts_sold_qty,
    NULL AS contracts_traded_qty,
    NULL AS contracts_placed_amt,
    NULL AS contracts_sold_amt,
    NULL AS contract_traded_amt,
    NULL AS contract_traded_count,
    NULL AS actives,
    NULL AS contract_traded_qty_24h,
    NULL AS contract_traded_qty_7d,
    NULL AS contract_traded_amt_24h,
    NULL AS contract_traded_amt_7d,
    total_markets,
    markets_with_trades_7d,
    markets_zero_trades_7d
FROM coverage
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.fct_fmx_product_catalog_overview_hourly_v2", "profile_name": "user", "target_name": "default"} */
