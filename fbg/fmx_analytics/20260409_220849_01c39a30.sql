-- Query ID: 01c39a30-0212-67a9-24dd-0703193fe8cb
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:08:49.750000+00:00
-- Elapsed: 1294ms
-- Environment: FBG

create or replace   view FMX_ANALYTICS.ORDERS.fmx_orders_live
  
  
  
  
  as (
    WITH orders_base AS (
    SELECT
        o.order_id,
        o.account_id,
        o.exchange_user_id,
        o.symbol,
        o.action,
        o.side,
        o.quantity AS order_quantity,
        o.price AS order_price,
        o.jurisdiction_id,
        o.collateral_withheld,
        o.fmx_fees_withheld,
        o.exchange_fees_buffer,
        o.exchange,
        o.created_at AS order_created_at,
        cm.alpha_strike AS market_name,
        cm.title AS market_title,
        cm.predict_market_type,
        cm.predict_event_type,
        cm.predict_contract_type,
        cm.markets_grouping,
        cm.sport_vs_other,
        cm.event_date,
        cm.trading_status

    FROM FMX_ANALYTICS.STAGING.stg_fmx_orders AS o

    INNER JOIN FMX_ANALYTICS.STAGING.stg_fmx_crypto_markets AS cm
        ON o.symbol = cm.symbol
),

trade_ids_agg AS (
    SELECT
        order_id,
        LISTAGG(execution_report_id, ', ') WITHIN GROUP (ORDER BY execution_report_id) AS trade_ids
    FROM FMX_ANALYTICS.STAGING.stg_fmx_execution_reports
    WHERE report_type = 'TRADE' AND execution_report_id IS NOT NULL
    GROUP BY order_id
),

order_quantities AS (
    SELECT
        order_id,
        quantity AS order_quantity
    FROM FMX_ANALYTICS.STAGING.stg_fmx_orders
),

executions_aggregated AS (
    SELECT
        er.order_id,
        SUM(
            CASE WHEN er.report_type = 'TRADE' THEN er.fmx_fees ELSE 0 END)::number(36, 2) AS
        total_fmx_fees,
        SUM(
            CASE WHEN er.report_type = 'TRADE' THEN er.exchange_fees ELSE 0 END)::number(36, 2) AS
        total_exchange_fees,
        CASE
            WHEN SUM(CASE WHEN er.report_type = 'TRADE' THEN er.quantity ELSE 0 END) > 0
                THEN
                    SUM(CASE WHEN er.report_type = 'TRADE' THEN er.report_price * er.quantity ELSE 0 END)
                    / SUM(CASE WHEN er.report_type = 'TRADE' THEN er.quantity ELSE 0 END)
        END::number(36, 4) AS avg_execution_price,
        COUNT(DISTINCT er.execution_report_id) AS execution_count,
        SUM(CASE WHEN er.report_type = 'TRADE' THEN er.quantity ELSE 0 END) AS total_filled_quantity,

        CASE
            WHEN MAX(CASE WHEN er.report_type = 'TRADE' THEN 1 ELSE 0 END) = 1
                THEN
                    CASE
                        WHEN
                            SUM(CASE WHEN er.report_type = 'TRADE' THEN er.quantity ELSE 0 END)
                            >= MAX(oq.order_quantity)
                            THEN 'FULLY_FILLED'
                        ELSE 'PARTIALLY_FILLED'
                    END
            WHEN MAX(CASE WHEN er.report_type = 'CANCELLED' THEN 1 ELSE 0 END) = 1 THEN 'CANCELLED'
            WHEN MAX(CASE WHEN er.report_type = 'REJECTED' THEN 1 ELSE 0 END) = 1 THEN 'REJECTED'
            WHEN MAX(CASE WHEN er.report_type = 'EXPIRED' THEN 1 ELSE 0 END) = 1 THEN 'EXPIRED'
            WHEN MAX(CASE WHEN er.report_type = 'REPLACED' THEN 1 ELSE 0 END) = 1 THEN 'REPLACED'
            WHEN MAX(CASE WHEN er.report_type = 'PENDING_NEW' THEN 1 ELSE 0 END) = 1 THEN 'PENDING'
            ELSE 'UNKNOWN'
        END AS execution_status,

        MAX(er.created_at) AS latest_execution_at,

        MAX(
            CASE WHEN er.report_type IN ('CANCELLED', 'REJECTED') THEN er.reason END) AS
        rejection_reason

    FROM FMX_ANALYTICS.STAGING.stg_fmx_execution_reports AS er
    LEFT JOIN order_quantities AS oq
        ON er.order_id = oq.order_id
    GROUP BY er.order_id
),


settlements_aggregated AS (
    SELECT
        symbol,
        exchange_user_id,
        SUM(payout_change)::number(36, 2) AS total_payout,
        MAX(settlement_report_id) AS settlement_report_id,
        MAX(market_result) AS market_result,
        MAX(created_at) AS settlement_created_at
    FROM FMX_ANALYTICS.STAGING.stg_fmx_settlement_reports
    GROUP BY symbol, exchange_user_id
)

SELECT
    ob.order_id,
    ob.account_id,
    ob.symbol,
    ob.market_name,
    ob.market_title,
    ob.action,
    ob.side,
    ob.order_quantity::number(36, 0) AS order_quantity,
    ob.order_price::number(36, 0) AS order_price,

    -- Execution details (aggregated)
    ea.execution_status,
    ea.total_filled_quantity::number(36, 0) AS total_filled_quantity,
    ea.avg_execution_price::number(36, 0) AS avg_execution_price,
    (ea.total_fmx_fees / 100)::number(36, 2) AS total_fmx_fees,
    ti.trade_ids,
    ea.rejection_reason,
    CASE
        WHEN ob.order_quantity > 0
            THEN ROUND((COALESCE(ea.total_filled_quantity, 0) / ob.order_quantity) * 100, 2)
        ELSE 0
    END::number(5, 2) AS fill_percentage,

    -- Fill percentage
    ob.predict_market_type,

    -- Market classification
    ob.predict_event_type,
    ob.predict_contract_type,
    ob.markets_grouping,
    ob.sport_vs_other,
    ob.event_date,
    ob.trading_status,
    sa.settlement_report_id,

    -- Settlement details
    sa.market_result,
    COALESCE(sa.total_payout, 0)::number(36, 2) AS payout_amount,
    ob.order_created_at,
    ea.latest_execution_at,

    -- Timestamps
    sa.settlement_created_at,
    ob.jurisdiction_id,
    j.jurisdiction_name,

    -- Jurisdiction
    COALESCE(ea.execution_count, 0) AS execution_count,
    (sa.settlement_report_id IS NOT NULL) AS is_settled

FROM orders_base AS ob

LEFT JOIN executions_aggregated AS ea
    ON ob.order_id = ea.order_id

LEFT JOIN trade_ids_agg AS ti
    ON ob.order_id = ti.order_id

LEFT JOIN settlements_aggregated AS sa
    ON
        ob.symbol = sa.symbol
        AND ob.exchange_user_id = sa.exchange_user_id

LEFT JOIN FMX_ANALYTICS.DIMENSIONS.dim_fmx_jurisdictions AS j
    ON ob.jurisdiction_id = j.jurisdiction_id
  )
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.fmx_orders_live", "profile_name": "user", "target_name": "default"} */
