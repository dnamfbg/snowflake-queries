-- Query ID: 01c39a3e-0212-67a8-24dd-07031942db23
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:22:30.246000+00:00
-- Elapsed: 1507ms
-- Environment: FBG

create or replace  table FMX_ANALYTICS.CUSTOMER.fct_fmx_daily_forecast_vs_actual
    
    
    
    as (WITH forecast_calendar AS ( --noqa: disable=all
    SELECT
        trade_fees_fmx_usd,
        trade_fees_partner_usd,
        total_trade_fees_usd,
        deposit_fees_usd,
        interest_income_usd,
        total_promo_spend_usd,
        COALESCE(trade_fees_fmx_usd, 0) + COALESCE(interest_income_usd, 0) 
            + COALESCE(deposit_fees_usd, 0) AS total_revenue_excl_promo_usd,
        total_revenue_usd,
        actives AS forecast_actives,
        contracts_placed_sold,
        contracts_placed_sold_amt_usd,
        average_contract_price,
        deposit_count AS forecast_deposit_count,
        deposit_usd AS forecast_deposit_usd,
        total_ftus AS forecast_total_ftus,
        acquisition_promo_cost_usd,
        mtd_actives AS forecast_mtd_actives,
        date::date AS activity_date,
        DATEADD('day', 1, date::date) AS report_date
    FROM FMX_ANALYTICS.STAGING.fmx_forecasts
),

actuals AS (
    SELECT
        report_date,
        trade_fee_amt_fmx,
        trade_fee_amt_provider,
        trade_fee_amt AS total_trade_fee_amt,
        deposit_fee_amt,
        revenue_amt,
        contract_traded_amt,
        contract_traded_count,
        contract_traded_qty,
        contracts_placed_qty,
        contracts_sold_qty,
        contracts_placed_amt,
        contracts_sold_amt,
        deposit_txn_count,
        deposit_amt,
        fmx_ftus,
        actives,
        customer_balance,
        DATEADD('day', -1, report_date) AS activity_date
    FROM FMX_ANALYTICS.CUSTOMER.fct_fmx_daily_dashboard
)

SELECT
    fc.report_date,
    fc.activity_date,
    fc.trade_fees_fmx_usd AS forecast_trade_fees_fmx_usd,
    fc.trade_fees_partner_usd AS forecast_trade_fees_partner_usd,
    fc.total_trade_fees_usd AS forecast_total_trade_fees_usd,
    fc.deposit_fees_usd AS forecast_deposit_fees_usd,
    fc.interest_income_usd AS forecast_interest_income_usd,
    fc.total_promo_spend_usd AS forecast_total_promo_spend_usd,
    fc.total_revenue_excl_promo_usd AS forecast_total_revenue_excl_promo_usd,
    fc.total_revenue_usd AS forecast_total_revenue_usd,
    fc.forecast_actives,
    fc.contracts_placed_sold AS forecast_contracts_placed_sold,
    fc.contracts_placed_sold_amt_usd AS forecast_contracts_placed_sold_amt_usd,
    fc.average_contract_price AS forecast_average_contract_price,
    fc.total_trade_fees_usd + fc.contracts_placed_sold_amt_usd AS forecast_handle_usd,
    (fc.total_trade_fees_usd + fc.contracts_placed_sold_amt_usd) / 150.0 AS forecast_contract_traded_count,
    fc.forecast_deposit_count,
    fc.forecast_deposit_usd,
    fc.forecast_total_ftus,
    fc.acquisition_promo_cost_usd,
    fc.forecast_mtd_actives,
    a.trade_fee_amt_fmx AS actual_trade_fee_amt_fmx,
    a.trade_fee_amt_provider AS actual_trade_fee_amt_provider,
    a.total_trade_fee_amt AS actual_total_trade_fee_amt,
    a.deposit_fee_amt AS actual_deposit_fee_amt,
    a.revenue_amt AS actual_total_revenue_usd,
    a.actives AS actual_actives,
    a.deposit_txn_count AS actual_deposit_count,
    a.deposit_amt AS actual_deposit_usd,
    a.customer_balance AS actual_customer_balance_usd,
    a.fmx_ftus AS actual_total_ftus,
    a.contract_traded_count AS actual_contract_traded_count,
    (a.contracts_placed_qty + a.contracts_sold_qty) AS actual_contracts_placed_sold,
    (a.contracts_placed_amt + a.contracts_sold_amt) AS actual_contracts_placed_sold_amt_usd,
    CASE
        WHEN a.contract_traded_qty = 0 THEN NULL
        ELSE a.contract_traded_amt / a.contract_traded_qty
    END AS actual_average_contract_price
FROM forecast_calendar AS fc
LEFT JOIN actuals AS a
    ON fc.report_date = a.report_date
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.fct_fmx_daily_forecast_vs_actual", "profile_name": "user", "target_name": "default"} */
