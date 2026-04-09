-- Query ID: 01c399dc-0212-6b00-24dd-0703192c72cb
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T20:44:59.063000+00:00
-- Elapsed: 2680ms
-- Environment: FBG

select * from fbg_analytics.vip.vip_contact_history
where message_type = 'Text'
and fbg_phone = '7206266262';
