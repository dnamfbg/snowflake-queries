-- Query ID: 01c39a3e-0212-6e7d-24dd-07031942e87b
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:22:26.051000+00:00
-- Elapsed: 2391ms
-- Run Count: 2
-- Environment: FBG

create or replace  table FMX_ANALYTICS.CUSTOMER.fct_fmx_daily_dashboard
    
    
    
    as (WITH trading AS ( --noqa: disable=all
    SELECT *
    FROM FMX_ANALYTICS.CUSTOMER.int_fmx_trading_activity_daily
    WHERE is_test = 0
),

trade_fees_daily AS (
    SELECT
        trans_date_alk,
        SUM(total_trade_fee_amt) AS total_trade_fee_amt,
        SUM(trade_fee_amt_fmx) AS total_trade_fee_amt_fmx,
        SUM(trade_fee_amt_provider) AS total_trade_fee_amt_provider
    FROM FMX_ANALYTICS.CUSTOMER.int_fmx_trade_fees_daily
    GROUP BY 1
),

customers AS (
    SELECT * FROM FMX_ANALYTICS.CUSTOMER.int_fmx_daily_customer_activity
),

forecast_daily AS (
    SELECT
        DATEADD('day', 1, date::date) AS report_date,
        date::date AS activity_date,
        COALESCE(trade_fees_fmx_usd, 0) + COALESCE(interest_income_usd, 0) 
            + COALESCE(deposit_fees_usd, 0) AS forecast_total_revenue_excl_promo_usd,
        total_revenue_usd AS forecast_total_revenue_usd,
        interest_income_usd AS forecast_interest_income_usd,
        total_trade_fees_usd AS forecast_total_trade_fees_usd,
        deposit_fees_usd AS forecast_deposit_fees_usd,
        total_promo_spend_usd AS forecast_total_promo_spend_usd,
        contracts_placed_sold_amt_usd AS forecast_contracts_placed_sold_amt_usd,
        contracts_placed_sold AS forecast_contracts_placed_sold,
        actives AS forecast_actives
    FROM FMX_ANALYTICS.STAGING.fmx_forecasts
),

joined AS (
    SELECT
        t.report_date AS activity_date,
        t.contracts_placed_qty,
        t.contracts_sold_qty,
        t.contract_traded_qty,
        t.contracts_placed_amt,
        t.contracts_sold_amt,
        t.contract_traded_amt,
        t.contracts_placed_user_count,
        t.contracts_sold_user_count,
        t.contract_traded_user_count,
        t.deposit_amt,
        t.deposit_txn_count,
        t.deposit_user_count,
        t.avg_deposit_amt,
        t.withdrawal_amt,
        t.withdrawal_txn_count,
        t.withdrawal_user_count,
        t.promotions_amt,
        t.promotions_count,
        t.deposit_fee_amt,
        COALESCE(tf.total_trade_fee_amt, t.trade_fee_amt) AS trade_fee_amt,
        COALESCE(tf.total_trade_fee_amt_fmx, t.trade_fee_amt_fmx) AS trade_fee_amt_fmx,
        COALESCE(tf.total_trade_fee_amt_provider, t.trade_fee_amt_provider) AS trade_fee_amt_provider,
        t.total_handle_amt,
        t.revenue_amt_excl_promotions,
        t.revenue_amt,
        t.deposit_users,
        t.contract_traded_per_active,
        t.revenue_per_active,
        t.customer_balance,
        t.total_open_order_amt,
        t.total_executed_unsettled_amt,
        t.customer_pnl_amt,
        t.contracts_placed_count,
        t.contracts_sold_count,
        t.contract_traded_count,
        t.actives,
        t.trade_transaction_count,
        t.attempted_order_buy_count,
        t.attempted_order_sold_count,
        t.attempted_order_total_count,
        t.successful_order_total_count,
        t.order_conversion_rate,
        DATEADD('day', 1, t.report_date) AS report_date,
        COALESCE(c.fmx_ftus, 0) AS fmx_ftus,
        COALESCE(c.fmx_ftus_organic, 0) AS fmx_ftus_organic,
        COALESCE(c.fmx_ftus_performance, 0) AS fmx_ftus_performance,
        COALESCE(c.fmx_ftus_other, 0) AS fmx_ftus_other,
        COALESCE(c.new_customers_count, 0) AS new_customers_count,
        COALESCE(c.new_customers_total, 0) AS new_customers_total,
        COALESCE(c.new_non_fbg_customer_count, 0) AS new_non_fbg_customer_count,
        COALESCE(c.non_fbg_customer_login_count, 0) AS non_fbg_customer_login_count,
        COALESCE(c.new_both_fbg_fmx_customer_count, 0) AS new_both_fbg_fmx_customer_count,
        COALESCE(c.new_fbg_customer_login_count, 0) AS new_fbg_customer_login_count,
        COALESCE(f.forecast_total_revenue_excl_promo_usd, 0) AS revenue_excl_promo_forecast,
        COALESCE(f.forecast_total_revenue_usd, 0) AS revenue_forecast,
        COALESCE(f.forecast_interest_income_usd, 0) AS interest_income_forecast,
        COALESCE(f.forecast_total_trade_fees_usd, 0) AS trade_fees_forecast,
        COALESCE(f.forecast_deposit_fees_usd, 0) AS deposit_fees_forecast,
        COALESCE(f.forecast_total_promo_spend_usd, 0) AS promo_spend_forecast,
        COALESCE(f.forecast_contracts_placed_sold_amt_usd, 0) AS contracts_traded_amt_forecast,
        COALESCE(f.forecast_contracts_placed_sold, 0) AS contracts_traded_qty_forecast,
        COALESCE(f.forecast_actives, 0) AS actives_forecast
    FROM trading AS t
    LEFT JOIN trade_fees_daily AS tf
        ON t.report_date = tf.trans_date_alk
    LEFT JOIN customers AS c
        ON t.report_date = c.report_date
    LEFT JOIN forecast_daily AS f
        ON DATEADD('day', 1, t.report_date) = f.report_date
)

SELECT
    activity_date,
    contracts_placed_qty,
    contracts_sold_qty,
    contract_traded_qty,
    contracts_placed_amt,
    contracts_sold_amt,
    contract_traded_amt,
    contracts_placed_user_count,
    contracts_sold_user_count,
    contract_traded_user_count,
    total_handle_amt,
    deposit_amt,
    deposit_txn_count,
    deposit_user_count,
    avg_deposit_amt,
    withdrawal_amt,
    withdrawal_txn_count,
    withdrawal_user_count,
    promotions_amt,
    promotions_count,
    deposit_fee_amt,
    trade_fee_amt,
    trade_fee_amt_fmx,
    trade_fee_amt_provider,
    revenue_amt_excl_promotions,
    revenue_amt,
    deposit_users,
    contract_traded_per_active,
    revenue_per_active,
    customer_balance,
    total_open_order_amt,
    total_executed_unsettled_amt,
    contracts_placed_count,
    contracts_sold_count,
    contract_traded_count,
    actives,
    customer_pnl_amt,
    trade_transaction_count,
    attempted_order_buy_count,
    attempted_order_sold_count,
    attempted_order_total_count,
    successful_order_total_count,
    order_conversion_rate,
    fmx_ftus,
    fmx_ftus_organic,
    fmx_ftus_performance,
    fmx_ftus_other,
    new_customers_count,
    new_customers_total,
    new_non_fbg_customer_count,
    non_fbg_customer_login_count,
    new_both_fbg_fmx_customer_count,
    new_fbg_customer_login_count,
    report_date,
    revenue_excl_promo_forecast,
    revenue_forecast,
    interest_income_forecast,
    trade_fees_forecast,
    deposit_fees_forecast,
    promo_spend_forecast,
    contracts_traded_amt_forecast,
    contracts_traded_qty_forecast,
    actives_forecast
FROM joined
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.fct_fmx_daily_dashboard", "profile_name": "user", "target_name": "default"} */
