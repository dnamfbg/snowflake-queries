-- Query ID: 01c399e9-0212-67a8-24dd-0703192eb82b
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_SER_XL_WH_PROD
-- Executed: 2026-04-09T20:57:40.936000+00:00
-- Elapsed: 1487ms
-- Environment: FBG

select * from fbg_analytics_engineering.staging.dbt_cloud_model_runs where name = 'sportsbook_pasr_cert' order by run_date_utc desc limit 100

;
