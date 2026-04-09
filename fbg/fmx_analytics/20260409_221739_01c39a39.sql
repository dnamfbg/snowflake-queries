-- Query ID: 01c39a39-0212-6dbe-24dd-07031941bd07
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:17:39.573000+00:00
-- Elapsed: 1220ms
-- Environment: FBG

create or replace  table FMX_ANALYTICS.CUSTOMER.fct_fmx_sports_grouping_breakdown
    
    
    
    as (

-- Daily aggregation of sports grouping breakdown from hourly data
-- Provides backward compatibility for Sigma reports expecting daily grain

SELECT
    activity_date_alk AS activity_date,
    sports_grouping,
    SUM(contracts_placed_qty) AS contracts_placed_qty,
    SUM(contracts_sold_qty) AS contracts_sold_qty,
    SUM(contracts_traded_qty) AS contracts_traded_qty,
    SUM(contracts_placed_amt) AS contracts_placed_amt,
    SUM(contracts_sold_amt) AS contracts_sold_amt,
    SUM(contract_traded_amt) AS contract_traded_amt,
    SUM(contracts_placed_count) AS contracts_placed_count,
    SUM(contracts_sold_count) AS contracts_sold_count,
    SUM(contract_traded_count) AS contract_traded_count,
    SUM(revenue_amt) AS revenue_amt,
    DATEADD('day', 1, activity_date_alk) AS report_date
FROM FMX_ANALYTICS.CUSTOMER.fct_fmx_sports_grouping_breakdown_hourly
GROUP BY activity_date_alk, sports_grouping
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.fct_fmx_sports_grouping_breakdown", "profile_name": "user", "target_name": "default"} */
