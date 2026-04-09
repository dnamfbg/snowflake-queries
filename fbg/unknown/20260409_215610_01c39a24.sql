-- Query ID: 01c39a24-0212-67a9-24dd-0703193c9eb3
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_SM_WH
-- Executed: 2026-04-09T21:56:10.040000+00:00
-- Elapsed: 1854ms
-- Environment: FBG

select distinct(lower(acquisition_sub_channel)) from fbg_analytics_engineering.customers.customer_mart
where lower(acquisition_channel) = 'affiliate'
and date(registration_date_est) >= '2025-01-01';
