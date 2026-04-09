-- Query ID: 01c39a05-0212-644a-24dd-070319356cc7
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:25:04.704000+00:00
-- Elapsed: 821ms
-- Environment: FBG

select * from fbg_analytics.vip.vip_status_history
where calendar_date = '2026-03-31'
and vip_status_day = 'vip'
