-- Query ID: 01c39a39-0212-67a9-24dd-070319420967
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:17:36.440000+00:00
-- Elapsed: 1488ms
-- Environment: FBG

create or replace  table FMX_ANALYTICS.CUSTOMER.fct_orders_symbol_hourly_metrics
    
    
    
    as (SELECT
    activity_hour_alk,
    activity_date_alk,
    symbol,
    attempted_total_order_buys,
    total_order_buys,
    total_order_sold,
    total_order_buy_fees,
    total_order_sale_fees,
    total_settlement,
    attempted_order_buy_count,
    total_order_buy_count,
    total_order_sold_count,
    actives,
    cancelled_order_count,
    rejected_order_count,
    total_contracts_buy_qty,
    total_contracts_sold_qty,
    total_contracts_traded_qty
FROM FMX_ANALYTICS.CUSTOMER.orders_fmx_symbol_hourly_metrics
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.fct_orders_symbol_hourly_metrics", "profile_name": "user", "target_name": "default"} */
