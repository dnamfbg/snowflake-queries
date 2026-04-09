-- Query ID: 01c39a37-0212-6e7d-24dd-070319418973
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:15:29.347000+00:00
-- Elapsed: 3490ms
-- Run Count: 2
-- Environment: FBG

create or replace  table FMX_ANALYTICS.CUSTOMER.cust_fmx_first_time_user_events
    
    
    
    as (WITH active_accounts AS (
    SELECT acco_id
    FROM FMX_ANALYTICS.DIMENSIONS.dim_fmx_accounts
    WHERE COALESCE(is_test_account, 0) = 0
),

first_time_orders AS (
    SELECT
        ftu.acco_id,
        ftu.first_order_state_code AS first_fmx_state,
        ftu.first_order_id AS first_fmx_order_id,
        ftu.first_order_ts_alk AS first_fmx_order_ts_alk
    FROM FMX_ANALYTICS.CUSTOMER.cust_fmx_first_order_events AS ftu
    INNER JOIN active_accounts AS acct
        ON ftu.acco_id = acct.acco_id
),

first_cash_orders AS (
    SELECT
        ftcu.acco_id,
        ftcu.first_cash_order_id,
        ftcu.first_cash_order_ts_alk,
        ftcu.first_cash_order_amount_usd AS first_cash_bet_amount_usd
    FROM FMX_ANALYTICS.CUSTOMER.cust_fmx_first_cash_order_events AS ftcu
    INNER JOIN active_accounts AS acct
        ON ftcu.acco_id = acct.acco_id
)

SELECT
    ftu.acco_id,
    ftu.first_fmx_state,
    ftu.first_fmx_order_id,
    ftu.first_fmx_order_ts_alk,
    ftcu.first_cash_order_id,
    ftcu.first_cash_order_ts_alk,
    ftcu.first_cash_bet_amount_usd,
    DATE_TRUNC('hour', ftu.first_fmx_order_ts_alk) AS first_fmx_order_hour_alk,
    DATE(ftu.first_fmx_order_ts_alk) AS first_fmx_order_date_alk,
    CONVERT_TIMEZONE('America/Anchorage', 'America/New_York', ftu.first_fmx_order_ts_alk) AS first_fmx_order_ts_est,
    CONVERT_TIMEZONE('America/Anchorage', 'UTC', ftu.first_fmx_order_ts_alk) AS first_fmx_order_ts_utc,
    DATE_TRUNC('hour', ftcu.first_cash_order_ts_alk) AS first_cash_order_hour_alk,
    DATE(ftcu.first_cash_order_ts_alk) AS first_cash_order_date_alk,
    CONVERT_TIMEZONE('America/Anchorage', 'America/New_York', ftcu.first_cash_order_ts_alk) AS first_cash_order_ts_est,
    CONVERT_TIMEZONE('America/Anchorage', 'UTC', ftcu.first_cash_order_ts_alk) AS first_cash_order_ts_utc,
    CURRENT_TIMESTAMP() AS last_modified_ts
FROM first_time_orders AS ftu
LEFT JOIN first_cash_orders AS ftcu
    ON ftu.acco_id = ftcu.acco_id
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.cust_fmx_first_time_user_events", "profile_name": "user", "target_name": "default"} */
