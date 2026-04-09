-- Query ID: 01c39a4f-0212-6e7d-24dd-070319468657
-- Database: FBG_ANALYTICS_DEV
-- Schema: JORDAN_PLUCHAR
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:39:28.064000+00:00
-- Elapsed: 32564ms
-- Environment: FBG

SELECT RESPONSE_PAYLOAD
FROM fbg_analytics_engineering.application.geolocation_pings_combined
WHERE RESPONSE_PAYLOAD LIKE '{%'
  AND ERROR_CODE = '0'
LIMIT 3
