-- Query ID: 01c39a33-0212-6dbe-24dd-070319404eb3
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:11:02.320000+00:00
-- Elapsed: 2300ms
-- Run Count: 2
-- Environment: FBG

create or replace  table FMX_ANALYTICS.CUSTOMER.fct_fmx_hourly_dashboard
    
    
    
    as (WITH trading AS ( --noqa: disable=ST06
    SELECT *
    FROM FMX_ANALYTICS.CUSTOMER.int_fmx_trading_activity_hourly
    WHERE is_test = 0
),

wallet AS (
    SELECT *
    FROM FMX_ANALYTICS.CUSTOMER.int_fmx_wallet_activity_hourly
    WHERE is_test = 0
),

activity_hours AS (
    SELECT DISTINCT activity_hour FROM trading
    UNION
    SELECT DISTINCT activity_hour FROM wallet
),

final AS (
    SELECT
        ah.activity_hour,
        COALESCE(tr.hour_of_day, wl.hour_of_day, DATE_PART('hour', ah.activity_hour)) AS hour_of_day,
        COALESCE(tr.contracts_placed_qty, 0) AS contracts_placed_qty,
        COALESCE(tr.contracts_sold_qty, 0) AS contracts_sold_qty,
        COALESCE(tr.contracts_traded_qty, 0) AS contracts_traded_qty,
        COALESCE(tr.contracts_placed_amt, 0) AS contracts_placed_amt,
        COALESCE(tr.contracts_sold_amt, 0) AS contracts_sold_amt,
        COALESCE(tr.contract_traded_amt, 0) AS contract_traded_amt,
        COALESCE(tr.contracts_placed_count, 0) AS contracts_placed_count,
        COALESCE(tr.contracts_sold_count, 0) AS contracts_sold_count,
        COALESCE(tr.contract_traded_count, 0) AS contract_traded_count,
        COALESCE(tr.actives, 0) AS actives,
        COALESCE(wl.deposit_amt, 0) AS deposit_amt,
        COALESCE(wl.deposit_count, 0) AS deposit_count,
        COALESCE(wl.deposit_user_count, 0) AS deposit_user_count,
        COALESCE(wl.withdrawal_amt, 0) AS withdrawal_amt,
        COALESCE(wl.withdrawal_count, 0) AS withdrawal_count,
        COALESCE(wl.withdrawal_user_count, 0) AS withdrawal_user_count
    FROM activity_hours AS ah
    LEFT JOIN trading AS tr
        ON ah.activity_hour = tr.activity_hour
    LEFT JOIN wallet AS wl
        ON ah.activity_hour = wl.activity_hour
    WHERE COALESCE(tr.is_test, wl.is_test, 0) = 0
)

SELECT
    DATEADD('day', 1, activity_hour) AS report_hour,
    CAST(DATEADD('day', 1, activity_hour) AS DATE) AS report_date,
    activity_hour,
    CAST(activity_hour AS DATE) AS activity_date,
    hour_of_day,
    contracts_placed_qty,
    contracts_sold_qty,
    contracts_traded_qty,
    contracts_placed_amt,
    contracts_sold_amt,
    contract_traded_amt,
    contracts_placed_count,
    contracts_sold_count,
    contract_traded_count,
    actives,
    deposit_amt,
    deposit_count,
    deposit_user_count,
    withdrawal_amt,
    withdrawal_count,
    withdrawal_user_count
FROM final
ORDER BY activity_hour
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.fct_fmx_hourly_dashboard", "profile_name": "user", "target_name": "default"} */
