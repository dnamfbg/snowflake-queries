-- Query ID: 01c399d6-0112-65b6-0000-e307218a3052
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T20:38:07.289000+00:00
-- Elapsed: 1390ms
-- Environment: FES

WITH current_data AS (
  SELECT account_id FROM LOYALTY.SOURCE.PROGRAM_ACCOUNT_BALANCE
),
historical_data AS (
  SELECT account_id FROM LOYALTY.SOURCE.PROGRAM_ACCOUNT_BALANCE AT(OFFSET => -1800)
)
SELECT 'NEW' AS status, c.account_id
FROM current_data c LEFT JOIN historical_data h ON c.account_id = h.account_id
WHERE h.account_id IS NULL
UNION ALL
SELECT 'DELETED' AS status, h.account_id
FROM historical_data h LEFT JOIN current_data c ON h.account_id = c.account_id
WHERE c.account_id IS NULL;
