-- Query ID: 01c399c3-0212-6b00-24dd-07031926cae3
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T20:19:16.836000+00:00
-- Elapsed: 51380ms
-- Environment: FBG

SELECT
  CONVERT_TIMEZONE('UTC', 'America/New_York', trans_date) AS trans_date_et,
  *
from
fbg_source.osb_source.account_statements
where date(trans_date) >= '2025-01-01'
and date(trans_date) <= '2025-12-31'
and acco_id = 854449
order by trans_date asc
