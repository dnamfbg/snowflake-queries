-- Query ID: 01c399c8-0212-6dbe-24dd-070319283087
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T20:24:19.649000+00:00
-- Elapsed: 2319ms
-- Environment: FBG

select message_date, message_type, outbound, inbound, description, acco_id, salesforce_id, lead_id, fbg_name
from fbg_analytics.vip.vip_contact_history
where fbg_name in ('Tyler Almonte', 'Matthew Biggar') and
message_date between '2026-03-01' and '2026-03-07'
