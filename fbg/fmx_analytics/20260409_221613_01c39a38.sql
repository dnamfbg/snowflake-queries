-- Query ID: 01c39a38-0212-67a8-24dd-07031941a57f
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:16:13.492000+00:00
-- Elapsed: 61320ms
-- Environment: FBG

create or replace  table FMX_ANALYTICS.CUSTOMER.fct_fmx_combo_leg_details
    
    
    
    as (-- ─────────────────────────────────────────────────────────────────────────────
-- COMBO LEG DETAILS
-- Extension of fct_fmx_core_orders for combo (parlay) orders only.
-- One row per order × leg, enriched with leg-level market metadata and
-- settlement results. All order-level metrics are sourced directly from
-- fct_fmx_core_orders to avoid logic duplication.
-- Grain: order_id + leg_number
-- ─────────────────────────────────────────────────────────────────────────────

WITH combo_legs AS (

    SELECT
        combo_source_id,
        leg_source_id,
        ROW_NUMBER() OVER (
            PARTITION BY combo_source_id ORDER BY id
        ) AS leg_number
    FROM FMX_ANALYTICS.STAGING.stg_fmx_combo_legs
    WHERE
        combo_source_id IS NOT NULL
        AND leg_source_id IS NOT NULL

),

leg_results AS (

    SELECT
        symbol,
        MAX_BY(market_result, created_at) AS leg_market_result
    FROM FMX_ANALYTICS.STAGING.stg_fmx_settlement_reports
    GROUP BY 1

)

SELECT
    -- order identifiers
    cor.order_id,
    cor.account_id,
    cor.market_symbol AS combo_symbol,
    cor.order_created_at,
    cor.order_created_at_alk,

    -- test account flag
    cor.is_test_account,

    -- customer context
    cor.registration_state,
    cor.order_state_code,
    cor.is_vip_account,

    -- order outcome
    cor.order_status,
    cor.rejection_reason,

    -- attempted metrics
    cor.trade_action,
    cor.trade_side,
    cor.attempted_quantity,
    cor.attempted_price_usd AS combo_price_usd,
    cor.attempted_fees_usd,
    cor.attempted_contract_amount_usd,
    cor.attempted_handle_usd,

    -- filled metrics
    cor.filled_quantity,
    cor.fill_rate_percentage,
    cor.filled_price_usd,
    cor.filled_fmx_fees_usd,
    cor.fmx_fees_charged_after_refunds_and_clawbacks_usd,
    cor.filled_contract_amount_usd,
    cor.filled_handle_usd,

    -- pnl
    cor.order_pnl_before_fees_usd,
    cor.order_pnl_after_fees_usd,
    cor.settlement_pnl_usd,
    cor.total_settlement_payout_usd,

    -- leg detail
    cl.leg_number,
    cl.leg_source_id AS leg_symbol,
    leg_m.markets_grouping AS leg_markets_grouping,
    leg_m.alpha_strike AS leg_market_name,
    leg_m.title AS leg_market_title,
    leg_m.predict_market_type AS leg_predict_market_type,
    leg_m.predict_contract_type AS leg_predict_contract_type,
    leg_m.event_date AS leg_event_date,
    leg_m.trading_status AS leg_trading_status,
    COALESCE(lr.leg_market_result, 'PENDING') AS leg_market_result,

    -- combo classification
    CASE
        WHEN COUNT(DISTINCT COALESCE(leg_m.markets_grouping, 'UNKNOWN')) OVER (PARTITION BY cor.order_id) = 1
            THEN 'SAME_SPORT'
        ELSE 'MULTI_SPORT'
    END AS combo_type,

    -- leg count
    MAX(cl.leg_number) OVER (PARTITION BY cor.order_id) AS legs_per_combo,

    -- combo pattern labels
    LISTAGG(COALESCE(leg_m.markets_grouping, 'UNKNOWN'), ' + ')
    WITHIN GROUP (ORDER BY COALESCE(leg_m.markets_grouping, 'UNKNOWN'))
        OVER (PARTITION BY cor.order_id) AS leg_sports_combo,
    LISTAGG(COALESCE(leg_m.predict_market_type, 'UNKNOWN'), ' + ')
    WITHIN GROUP (ORDER BY COALESCE(leg_m.predict_market_type, 'UNKNOWN'))
        OVER (PARTITION BY cor.order_id) AS leg_market_types_combo,
    LISTAGG(COALESCE(leg_m.predict_contract_type, 'UNKNOWN'), ' + ')
    WITHIN GROUP (ORDER BY COALESCE(leg_m.predict_contract_type, 'UNKNOWN'))
        OVER (PARTITION BY cor.order_id) AS leg_contract_types_combo,
    LISTAGG(COALESCE(leg_m.alpha_strike, 'UNKNOWN'), ' + ')
    WITHIN GROUP (ORDER BY COALESCE(leg_m.alpha_strike, 'UNKNOWN'))
        OVER (PARTITION BY cor.order_id) AS leg_market_names_combo

FROM FMX_ANALYTICS.CUSTOMER.fct_fmx_core_orders AS cor
INNER JOIN combo_legs AS cl
    ON cor.market_symbol = cl.combo_source_id
LEFT JOIN FMX_ANALYTICS.STAGING.stg_fmx_crypto_markets AS leg_m
    ON cl.leg_source_id = leg_m.symbol
LEFT JOIN leg_results AS lr
    ON cl.leg_source_id = lr.symbol
WHERE cor.markets_grouping = 'COMBOS'
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.fct_fmx_combo_leg_details", "profile_name": "user", "target_name": "default"} */
