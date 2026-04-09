-- Query ID: 01c39a38-0212-67a8-24dd-07031941a47f
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:16:00.119000+00:00
-- Elapsed: 879ms
-- Environment: FBG

select tablename, most_recent_date, current_timestamp as refresh_timestamp, lower(current_user()) as refresh_user
from (
    select 'daily' as tablename,  max(date) as most_recent_date from fbg_analytics.casino.casino_forecast_daily_dataset
    union
    select 'daily_vip' as tablename, max(date) as most_recent_date from fbg_analytics.casino.casino_forecast_daily_vip_dataset
    union
    select 'monthly' as tablename, max(month_start_date) as most_recent_date from fbg_analytics.casino.casino_forecast_monthly_dataset
    union
    select 'monthly_vip' as tablename, max(month_start_date) as most_recent_date from fbg_analytics.casino.casino_forecast_monthly_vip_dataset
)
