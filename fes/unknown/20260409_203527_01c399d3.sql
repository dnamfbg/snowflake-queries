-- Query ID: 01c399d3-0112-6f44-0000-e3072188cf9e
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T20:35:27.611000+00:00
-- Elapsed: 1031ms
-- Environment: FES

SELECT period_type, period_label, period_start, period_end
FROM ENTERPRISE_METRICS.REPORTING.REPORTING_PERIODS_TTM
WHERE period_type = 'quarter'
ORDER BY period_start DESC
LIMIT 5
