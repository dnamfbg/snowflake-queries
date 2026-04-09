-- Query ID: 01c39a30-0212-67a8-24dd-0703193fab0b
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:08:37.419000+00:00
-- Elapsed: 754ms
-- Environment: FBG

create or replace   view FMX_ANALYTICS.PRODUCT.cashout_orders_alert
  
  
  
  
  as (
    WITH sold_events AS (
    SELECT
        s.trans_ref,
        s.link_trans_ref AS order_id,
        s.acco_id,
        s.trans_date AS trans_ts_utc,
        ABS(s.amount) AS cashout_usd
    FROM FMX_ANALYTICS.STAGING.stg_account_statements_fmx AS s
    WHERE
        UPPER(s.trans) = 'FEX_ORDER_SOLD'
        AND ABS(s.amount) >= 5000
),

orders AS (
    SELECT
        o.order_id,
        o.symbol
    FROM FMX_ANALYTICS.STAGING.stg_fmx_orders AS o
),

enriched AS (
    SELECT
        se.trans_ref,
        se.order_id,
        se.acco_id,
        se.trans_ts_utc,
        se.cashout_usd,
        o.symbol,
        cm.name AS market_name,
        cm.title AS market_title,
        cm.home_participant,
        cm.away_participant,
        cm.participant AS single_participant,
        cm.markets_grouping,
        cm.predict_contract_type,
        cm.predict_outcome_type,
        cm.alpha_strike,
        cm.event_date
    FROM sold_events AS se
    LEFT JOIN orders AS o
        ON se.order_id = o.order_id
    LEFT JOIN FMX_ANALYTICS.STAGING.stg_fmx_crypto_markets AS cm
        ON o.symbol = cm.symbol
)

SELECT
    trans_ts_utc AS triggered_at,
    acco_id,
    cashout_usd,
    symbol,
    market_name,
    alpha_strike,
    market_title,
    MD5(
        CONCAT(
            'cashout_orders_alert',
            ':',
            COALESCE(trans_ref, ''),
            ':',
            COALESCE(order_id, '')
        )
    ) AS alert_id
FROM enriched
  )
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.cashout_orders_alert", "profile_name": "user", "target_name": "default"} */
