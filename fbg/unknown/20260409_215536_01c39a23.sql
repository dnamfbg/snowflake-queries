-- Query ID: 01c39a23-0212-6dbe-24dd-0703193cb76b
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_SM_WH
-- Executed: 2026-04-09T21:55:36.078000+00:00
-- Elapsed: 1573ms
-- Environment: FBG

select distinct(lower(media_source)) from fbg_analytics_engineering.customers.customer_mart
where lower(acquisition_channel) = 'affiliate';
