-- Query ID: 01c39a30-0212-6e7d-24dd-070319401087
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:08:46.381000+00:00
-- Elapsed: 221088ms
-- Environment: FBG

create or replace  table FMX_ANALYTICS.CUSTOMER.cust_fmx_first_cash_order_events
    
    
    
    as (WITH traded_orders AS (
    SELECT DISTINCT order_id
    FROM FMX_ANALYTICS.STAGING.stg_fmx_execution_reports
    WHERE UPPER(COALESCE(report_type, 'UNKNOWN')) = 'TRADE'
),

first_cash_orders AS (
    SELECT
        ast.acco_id::varchar AS acco_id,
        MIN(ast.trans_date) AS trans_date_utc
    FROM FMX_ANALYTICS.STAGING.stg_account_statements_fmx AS ast
    INNER JOIN traded_orders AS tro
        ON ast.link_trans_ref = tro.order_id
    WHERE
        ast.trans = 'FEX_ORDER_INITIATED'
        AND COALESCE(ast.fund_type_id, 0) = 1
    GROUP BY 1
),

order_events AS (
    SELECT
        cash.acco_id,
        ast.link_trans_ref AS first_cash_order_id,
        CONVERT_TIMEZONE('UTC', 'America/Anchorage', ast.trans_date)::timestamp_ntz AS first_cash_order_ts_alk
    FROM first_cash_orders AS cash
    INNER JOIN FMX_ANALYTICS.STAGING.stg_account_statements_fmx AS ast
        ON
            ast.acco_id::varchar = cash.acco_id
            AND cash.trans_date_utc = ast.trans_date
    WHERE ast.trans = 'FEX_ORDER_INITIATED'
)

SELECT
    evt.acco_id,
    evt.first_cash_order_id,
    evt.first_cash_order_ts_alk,
    jur.jurisdiction_code AS first_cash_order_state_code,
    ABS(ast.amount) AS first_cash_order_amount_usd
FROM order_events AS evt
LEFT JOIN FMX_ANALYTICS.STAGING.stg_account_statements_fmx AS ast
    ON evt.first_cash_order_id = ast.link_trans_ref
LEFT JOIN FMX_ANALYTICS.DIMENSIONS.dim_fmx_jurisdictions AS jur
    ON ast.jurisdictions_id = jur.jurisdiction_id
QUALIFY ROW_NUMBER() OVER (PARTITION BY evt.acco_id ORDER BY ast.trans_date) = 1
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.cust_fmx_first_cash_order_events", "profile_name": "user", "target_name": "default"} */
